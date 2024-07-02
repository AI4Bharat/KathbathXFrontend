package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import android.annotation.SuppressLint
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.widget.Toast
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.model.karya.WorkerRecord
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderActivityState
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderActivityState.*
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState.*
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.data.model.karya.enums.MicrotaskAssignmentStatus
import com.ai4bharat.kathbath.data.model.karya.enums.ScenarioType
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import com.ai4bharat.kathbath.utils.DateTimeUtils
import com.ai4bharat.kathbath.utils.PreferenceKeys
import com.ai4bharat.kathbath.utils.RawToAACEncoder
import com.google.gson.JsonObject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.io.DataOutputStream
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.RandomAccessFile
import java.util.ArrayList
import java.util.Locale
import javax.inject.Inject

private const val AUDIO_CHANNEL = AudioFormat.CHANNEL_IN_MONO

@HiltViewModel
class SpeechAudioDataViewModel
@Inject
constructor(
    assignmentRepository: AssignmentRepository,
    taskRepository: TaskRepository,
    microTaskRepository: MicroTaskRepository,
    @FilesDir fileDirPath: String,
    authManager: AuthManager,
    private val datastore: DataStore<Preferences>
) : BaseMTRendererViewModel(
    assignmentRepository,
    taskRepository,
    microTaskRepository,
    fileDirPath,
    authManager
) {

    /** Input media player parameters*/
    private var inputAudioPlayerOne: MediaPlayer? = null
    private var inputAudioPlayerTwo: MediaPlayer? = null
    val inputAudioPlayerOneState =
        MutableLiveData<InputAudioPlayerState>(InputAudioPlayerState.DISABLED)

    val inputAudioPlayerTwoState =
        MutableLiveData<InputAudioPlayerState>(InputAudioPlayerState.DISABLED)

    var inputAudioPlayerOneTime: MutableLiveData<Int> = MutableLiveData<Int>(0)
    var inputAudioPlayerTwoTime: MutableLiveData<Int> = MutableLiveData<Int>(0)

    /** first -> current time, second -> total duration*/
    var inputAudioPlayerOneTimestamp: MutableLiveData<Pair<String, String>> =
        MutableLiveData<Pair<String, String>>(
            Pair("0:00", "0:00")
        )
    var inputAudioPlayerTwoTimestamp: MutableLiveData<Pair<String, String>> =
        MutableLiveData<Pair<String, String>>(Pair("0:00", "0:00"))


    // TODO: Pass it in constructor (once we have viewModel factory)
    private val postRecordingTime: Int = 4
    private val prerecordingTime: Int = 4

    // Speech data collection parameters
    private var samplingRate: Int = 44100
    private var audioEncoding: Int = AudioFormat.ENCODING_PCM_16BIT
    private var compressAudio: Boolean = false

    /** UI strings */
    private var noForcedReplay: Boolean = true

    /** Audio recorder and media player */
    private var audioRecorder: AudioRecord? = null
    private var mediaPlayer: MediaPlayer? = null

    /** Audio recorder config parameters */
    private val _minBufferSize =
        AudioRecord.getMinBufferSize(
            samplingRate,
            AUDIO_CHANNEL, audioEncoding
        )
    private val _recorderBufferSize = _minBufferSize * 4
    private val _recorderBufferBytes = _recorderBufferSize

    /** UI State */
    @JvmField
    var activityState: AudioRecorderActivityState = AudioRecorderActivityState.INIT
    var previousActivityState: AudioRecorderActivityState = AudioRecorderActivityState.INIT

    private val _recordBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(AudioRecorderButtonState.DISABLED)
    val recordBtnState = _recordBtnState.asStateFlow()


    private val _playBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(DISABLED)
    val playBtnState = _playBtnState.asStateFlow()

    private val _nextBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(DISABLED)
    val nextBtnState = _nextBtnState.asStateFlow()

    private val _backBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(DISABLED)
    val backBtnState = _backBtnState.asStateFlow()

    private val _playRecordPromptTrigger: MutableStateFlow<Boolean> = MutableStateFlow(false)
    val playRecordPromptTrigger = _playRecordPromptTrigger.asStateFlow()

    private val _skipTaskAlertTrigger: MutableStateFlow<Boolean> = MutableStateFlow(false)
    val skipTaskAlertTrigger = _skipTaskAlertTrigger.asStateFlow()

    private val _microTaskInstruction: MutableStateFlow<String> = MutableStateFlow("")
    val microTaskInstruction = _microTaskInstruction.asStateFlow()

    private val _sentenceTvText: MutableStateFlow<String> = MutableStateFlow("")
    val sentenceTvText = _sentenceTvText.asStateFlow()

    private val _inputAudioPath: MutableStateFlow<String> = MutableStateFlow("")
    val inputAudioPath = _inputAudioPath.asStateFlow()

    private val _recordSecondsTvText: MutableStateFlow<String> = MutableStateFlow("0")
    val recordSecondsTvText = _recordSecondsTvText.asStateFlow()

    private val _recordCentiSecondsTvText: MutableStateFlow<String> = MutableStateFlow("00")
    val recordCentiSecondsTvText = _recordCentiSecondsTvText.asStateFlow()

    private val _playbackProgressPbProgress: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgressPb = _playbackProgressPbProgress.asStateFlow()

    private val _playbackProgressPbMax: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgressPbMax = _playbackProgressPbMax.asStateFlow()

    /** Recording config and state */
    private val maxPreRecordBytes = timeToSamples(prerecordingTime) * 2

    /** Microtask config */
    private var allowSkipping: Boolean = false

    private var preRecordBuffer: Array<ByteArray>
    var preRecordBufferConsumed: Array<Int> = Array(2) { 0 }
    private var currentPreRecordBufferIndex = 0
    private var totalRecordedBytes = 0
    var preRecordingJob: Job? = null
    var inputAudioTimeUpdateJob: Job? = null
    private var recordingLength: Float = 0.0f

    private var recordBuffers: ArrayList<ByteArray> = arrayListOf()
    private var currentRecordBufferConsumed = 0
    private var recordingJob: Job? = null
    private var audioFileFlushJob: Job? = null

    /** scratch WAV file */
    private val scratchRecordingFileParams = Pair("", "wav")
    lateinit var scratchRecordingFilePath: String
    private lateinit var scratchRecordingFile: DataOutputStream
    private lateinit var scratchRecordingFileInitJob: Job

    /** Final recording file */
    var outputRecordingFileParams = Pair("", "wav")
    lateinit var outputRecordingFilePath: String
    private var encodingJob: Job? = null
    var extempore: Boolean = false


    /** Playback progress thread */
    private var playbackProgressThread: Thread? = null

    private var firstTimeActivityVisit: Boolean = true


    init {
        /** setup [preRecordBuffer] */
        preRecordBuffer = Array(2) { ByteArray(maxPreRecordBytes) }

        runBlocking {
            val firstRunKey = booleanPreferencesKey(PreferenceKeys.SPEECH_DATA_ACTIVITY_VISITED)
            val data = datastore.data.first()
            firstTimeActivityVisit = data[firstRunKey] ?: true
            datastore.edit { prefs -> prefs[firstRunKey] = false }
        }
    }

    fun setPaths(pair: Pair<String, String>) {
        scratchRecordingFilePath = getAssignmentScratchFilePath(pair)
        outputRecordingFileParams = pair
        outputRecordingFilePath =
            assignmentOutputContainer.getAssignmentOutputFilePath(
                microtaskAssignmentIDs[currentAssignmentIndex],
                outputRecordingFileParams
            )
        compressAudio = false
        extempore = true
        _recordBtnState.value = ENABLED
        setActivityState(AudioRecorderActivityState.COMPLETED)
        initializePlayer()
        getFileDur(scratchRecordingFilePath)
        releasePlayer()
//    setButtonStates(ENABLED,ENABLED,ENABLED,ENABLED)

    }

    /**
     * Initialize speech data collection parameters
     */
    fun setupSpeechDataViewModel() {
        compressAudio = try {
            task.params.asJsonObject.get("compress").asBoolean
        } catch (e: Exception) {
            false
        }

        samplingRate = try {
            val rate = task.params.asJsonObject.get("sampling_rate").asString
            when (rate) {
                "8k" -> 8000
                "16k" -> 16000
                "44k" -> 44100
                else -> 44100
            }
        } catch (e: Exception) {
            44100
        }

        audioEncoding = try {
            val bitwidth = task.params.asJsonObject.get("bitwidth").asString
            when (bitwidth) {
                "8" -> AudioFormat.ENCODING_PCM_8BIT
                "16" -> AudioFormat.ENCODING_PCM_16BIT
                else -> AudioFormat.ENCODING_PCM_16BIT
            }
        } catch (e: Exception) {
            AudioFormat.ENCODING_PCM_16BIT
        }

        outputRecordingFileParams = if (compressAudio) Pair(
            "",
            "m4a"
        ) else outputRecordingFileParams //changed Pain("","wav")
//    Log.e("[TEEE]",outputRecordingFileParams.toString())
    }

    /** Shortcut to set and flush all four button states (in sequence) */
    private fun setButtonStates(
        b: AudioRecorderButtonState,
        r: AudioRecorderButtonState,
        p: AudioRecorderButtonState,
        n: AudioRecorderButtonState
    ) {
        _backBtnState.value = b
        _recordBtnState.value = r
        _playBtnState.value = p
        _nextBtnState.value = n
    }

    override fun setupMicrotask() {

        /** Get the scratch and output file paths */
        scratchRecordingFilePath = getAssignmentScratchFilePath(scratchRecordingFileParams)
        outputRecordingFilePath =
            assignmentOutputContainer.getAssignmentOutputFilePath(
                microtaskAssignmentIDs[currentAssignmentIndex],
                outputRecordingFileParams
            )


        /** Write wav file */
        scratchRecordingFileInitJob = CoroutineScope(Dispatchers.IO).launch { resetWavFile() }

        // Reset progress bar
        _playbackProgressPbProgress.value = 0

        // Set microtask instruction
        if (currentMicroTask.input.asJsonObject.getAsJsonObject("data")
                .get("instruction") != null
        ) {
            _microTaskInstruction.value =
                currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("instruction")
                    .toString()
            totalRecordedBytes = 0
        }

        val hints = currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("hints")

//        _sentenceTvText.value =
//            currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()

        if (hints != null) {
            val hintList = hints.toString().removeSurrounding("[", "]")
                .takeIf(String::isNotEmpty)
                ?.split(",")
                ?: emptyList()
//      Log.e("HINTS",hintList.random())
            if (hintList.size > 3) {
                _sentenceTvText.value += " [Hint:" + hintList.shuffled()
                    .joinToString(separator = ",", limit = 3) + "]"
            } else {
                _sentenceTvText.value += " [Hint:" + hintList.joinToString(separator = ",") + "]"
            }
        }

        totalRecordedBytes = 0

        extempore = task.name.contains("Extempore Dialogue", true)
        if (extempore) {
            _recordBtnState.value = ENABLED
        }
        /** Get microtask config */
        try {
            allowSkipping = task.params.asJsonObject.get("allowSkipping").asBoolean
        } catch (e: Exception) {
            allowSkipping = false
        }

        if (firstTimeActivityVisit) {
            firstTimeActivityVisit = false
            onAssistantClick()
        } else {
            moveToPrerecording()
        }

        setUpInputAudio()

    }

    /** Handle record button click */
    fun handleRecordClick() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "RECORD")
        message.addProperty("state", recordBtnState.toString())
        log(message)

        if (inputAudioPlayerOneState.value == InputAudioPlayerState.PLAYING) {
            controlInputAudioPlayer("Stop", "One")
        }
        if (inputAudioPlayerTwoState.value == InputAudioPlayerState.PLAYING) {
            controlInputAudioPlayer("Stop", "Two")
        }
        /** Determine action based on current state */
        when (activityState) {
            /**
             * Prerecording states: Set target button states. Wait for wave file init job and prerecording
             * job to finish. Write the prerecord buffer to wav file. Start regular recording.
             */
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                setButtonStates(DISABLED, ACTIVE, DISABLED, DISABLED)
                setActivityState(AudioRecorderActivityState.RECORDING)
            }

            /** COMPLETED: Just reset wav file and restart recording */
            AudioRecorderActivityState.COMPLETED -> {
                setButtonStates(DISABLED, ACTIVE, DISABLED, DISABLED)

                scratchRecordingFileInitJob =
                    viewModelScope.launch(Dispatchers.IO) { resetWavFile() }

                totalRecordedBytes = 0
                setActivityState(AudioRecorderActivityState.RECORDING)
            }

            /** Media player states: Stop and release media player. Reset wav file. Restart recording. */
            AudioRecorderActivityState.OLD_PLAYING,
            AudioRecorderActivityState.OLD_PAUSED,
            AudioRecorderActivityState.NEW_PLAYING,
            AudioRecorderActivityState.NEW_PAUSED,
            -> {
                setButtonStates(DISABLED, ACTIVE, DISABLED, DISABLED)

                releasePlayer()
                scratchRecordingFileInitJob =
                    viewModelScope.launch(Dispatchers.IO) { resetWavFile() }
                setActivityState(AudioRecorderActivityState.RECORDING)
            }

            /** RECORDING: Set target button states. Move to recorded state */
            AudioRecorderActivityState.RECORDING -> {
                setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
                setActivityState(AudioRecorderActivityState.RECORDED)
            }

            /**
             * All other states: Record button is not clickable. This function should not have been
             * called. Throw an error.
             */
            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            AudioRecorderActivityState.ACTIVITY_STOPPED,
            -> {
                // throw Exception("Record button should not be clicked in '$activityState' state")
            }
        }
    }

    /** Handle play button click */
    fun handlePlayClick() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "PLAY")
        message.addProperty("state", playBtnState.toString())
        log(message)

        when (activityState) {
            /** If coming from first play back, just move to pause */
            AudioRecorderActivityState.FIRST_PLAYBACK -> {
                setButtonStates(DISABLED, DISABLED, ENABLED, DISABLED)
                setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED)
            }

            /** If coming from first playback paused, resume player */
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED -> {
                setButtonStates(DISABLED, DISABLED, ACTIVE, DISABLED)
                setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK)
            }

            /** If coming from completed, play the scratch wav file */
            AudioRecorderActivityState.COMPLETED -> {
                setButtonStates(ENABLED, ENABLED, ACTIVE, ENABLED)
                setActivityState(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** on NEW_PLAYING, move to NEW_PAUSED */
            AudioRecorderActivityState.NEW_PLAYING -> {
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                setActivityState(AudioRecorderActivityState.NEW_PAUSED)
            }

            /** on NEW_PAUSED, move to NEW_PLAYING */
            AudioRecorderActivityState.NEW_PAUSED -> {
                setButtonStates(ENABLED, ENABLED, ACTIVE, ENABLED)
                setActivityState(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** COMPLETED_PRERECORDING: Move to old playing */
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                setButtonStates(ENABLED, ENABLED, ACTIVE, ENABLED)
                setActivityState(AudioRecorderActivityState.OLD_PLAYING)
            }

            /** OLD_PLAYING: Move to old paused */
            AudioRecorderActivityState.OLD_PLAYING -> {
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                setActivityState(AudioRecorderActivityState.OLD_PAUSED)
            }

            /** OLD_PAUSED: Move to old playing */
            AudioRecorderActivityState.OLD_PAUSED -> {
                setButtonStates(ENABLED, ENABLED, ACTIVE, ENABLED)
                setActivityState(AudioRecorderActivityState.OLD_PLAYING)
            }

            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.RECORDING,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            AudioRecorderActivityState.ACTIVITY_STOPPED,
            -> {
                // throw Exception("Play button should not be clicked in '$activityState' state")
            }
        }
    }

    /** Handle next button click */
    fun handleNextClick() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "NEXT")
        log(message)

        /** Disable all buttons when NEXT is clicked */
        setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
        releaseInputMediaPlayer()

        when (activityState) {
            AudioRecorderActivityState.COMPLETED_PRERECORDING, AudioRecorderActivityState.OLD_PLAYING, AudioRecorderActivityState.OLD_PAUSED -> {
                setActivityState(AudioRecorderActivityState.SIMPLE_NEXT)
            }

            AudioRecorderActivityState.COMPLETED, AudioRecorderActivityState.NEW_PLAYING, AudioRecorderActivityState.NEW_PAUSED -> {
                setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
                setActivityState(AudioRecorderActivityState.ENCODING_NEXT)
            }

            AudioRecorderActivityState.PRERECORDING -> {
                // User wants to skip the microtask
                setSkipTaskAlertTrigger(true)
            }

            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.RECORDING,
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            AudioRecorderActivityState.ACTIVITY_STOPPED,
            -> {
                // throw Exception("Next button should not be clicked in '$activityState' state")
            }
        }
    }

    /** Handle back button click */
    fun handleBackClick() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "BACK")
        log(message)

        /** Disable all buttons when NEXT is clicked */
        setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
        releaseInputMediaPlayer()

        when (activityState) {
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING,
            AudioRecorderActivityState.OLD_PLAYING,
            AudioRecorderActivityState.OLD_PAUSED,
            -> {
                setActivityState(AudioRecorderActivityState.SIMPLE_BACK)
            }

            AudioRecorderActivityState.COMPLETED, AudioRecorderActivityState.NEW_PLAYING, AudioRecorderActivityState.NEW_PAUSED -> {
                setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
                setActivityState(AudioRecorderActivityState.ENCODING_BACK)
            }

            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.RECORDING,
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            AudioRecorderActivityState.ACTIVITY_STOPPED,
            -> {
                // throw Exception("Back button should not be clicked in '$activityState' state")
            }
        }
    }

    fun onBackPressed() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "ANDROID_BACK")
        log(message)

        inputAudioPlayerOne?.release()
        inputAudioPlayerTwo?.release()

        when (activityState) {
            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            AudioRecorderActivityState.OLD_PLAYING,
            AudioRecorderActivityState.OLD_PAUSED,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            -> {
                navigateBack()
            }

            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                preRecordingJob?.cancel()
                releaseRecorder()
                navigateBack()
            }

            AudioRecorderActivityState.RECORDING -> {
                recordingJob?.cancel()
                releaseRecorder()
                navigateBack()
            }

            AudioRecorderActivityState.COMPLETED, AudioRecorderActivityState.NEW_PLAYING, AudioRecorderActivityState.NEW_PAUSED -> {
                runBlocking {
//          encodeRecording()
//          completeAndSaveCurrentMicrotask()
                    recordingJob?.cancel()
                    releaseRecorder()
                    navigateBack()
                }
            }

            AudioRecorderActivityState.ENCODING_NEXT, AudioRecorderActivityState.ENCODING_BACK -> {
                runBlocking {
                    encodingJob?.join()
                    navigateBack()
                }
            }

            AudioRecorderActivityState.ACTIVITY_STOPPED -> {
                //  throw Exception("Android back button cannot not be clicked in '$activityState' state")
            }
        }
    }

    /** On assistant click, take user through the recording process */
    fun onAssistantClick() {

        println("SADD# assistant")
        when (activityState) {
            AudioRecorderActivityState.INIT -> {
                viewModelScope.launch {
                    delay(1000)
                    playRecordPrompt()
                }
            }

            AudioRecorderActivityState.PRERECORDING, AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                runBlocking {
                    setActivityState(AudioRecorderActivityState.ASSISTANT_PLAYING)
                    preRecordingJob?.join()
                    preRecordBufferConsumed[0] = 0
                    preRecordBufferConsumed[1] = 0
                    releaseRecorder()
                    setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
                    playRecordPrompt()
                }
            }

            else -> {
            }
        }
    }

    private fun playRecordPrompt() {
        _playRecordPromptTrigger.value = true
    }

    fun setSkipTaskAlertTrigger(value: Boolean) {
        _skipTaskAlertTrigger.value = value
    }

    fun skipMicrotask() {
        runBlocking {
            skipAndSaveCurrentMicrotask()
            setActivityState(AudioRecorderActivityState.SIMPLE_NEXT)
            setSkipTaskAlertTrigger(false)
        }
    }

    /** Move from init to pre-recording */
    fun moveToPrerecording() {
        preRecordBufferConsumed[0] = 0
        preRecordBufferConsumed[1] = 0

        if (currentAssignment.status != MicrotaskAssignmentStatus.COMPLETED) {
            setButtonStates(ENABLED, ENABLED, DISABLED, DISABLED)
            // Enable next button if skipping allowed
            if (allowSkipping) {
                setButtonStates(ENABLED, ENABLED, DISABLED, ENABLED)
            }
            setActivityState(AudioRecorderActivityState.PRERECORDING)
            resetRecordingLength()
        } else {
            setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)

            val mPlayer = MediaPlayer()
            mPlayer.setDataSource(outputRecordingFilePath)
            mPlayer.prepare()
            resetRecordingLength(mPlayer.duration)
            mPlayer.release()
            setActivityState(AudioRecorderActivityState.COMPLETED_PRERECORDING)
        }
    }

    /** Set the state of the activity to the target state */
    fun setActivityState(targetState: AudioRecorderActivityState) {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "->")
        message.addProperty("from", activityState.toString())
        message.addProperty("to", targetState.toString())
        log(message)
//    Log.d("TRANSITION", "$activityState->$targetState")
        // Switch statess
        previousActivityState = activityState
        activityState = targetState

        // Handle state change
        when (activityState) {
            /**
             * INIT: release audio recorder and media player. May not be necessary? Microtask setup will
             * transition to next state
             */
            AudioRecorderActivityState.INIT -> {
                releasePlayer()
                releaseRecorder()
            }

            /** PRERECORDING: Create audio recorder and start prerecording */
            AudioRecorderActivityState.PRERECORDING -> {
                initializeAndStartRecorder()
                writeAudioDataToPrerecordBuffer()
            }

            /** COMPLETED_PRERECORDING: Create audio recorder and start prerecording */
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                initializeAndStartRecorder()
                writeAudioDataToPrerecordBuffer()
            }

            /**
             * RECORDING: If not coming from prerecording states, initialize the audio recorder and start
             * recording. Start chronometer. Write audio data to file.
             */
            AudioRecorderActivityState.RECORDING -> {
                if (!isPrerecordingState(previousActivityState)) initializeAndStartRecorder()
                _playbackProgressPbProgress.value = 0
                recordBuffers = arrayListOf()
                writeAudioDataToRecordBuffer()
            }

            /** RECORDED: Finish recording and finalize wav file. Switch to first play back */
            AudioRecorderActivityState.RECORDED -> {
                finishRecordingAndFinalizeWavFile()
            }

            /**
             * FIRST_PLAYBACK: Start media player and play the scratch wav file If coming from paused
             * state, resume player
             */
            AudioRecorderActivityState.FIRST_PLAYBACK -> {
                if (previousActivityState == AudioRecorderActivityState.RECORDED || previousActivityState == AudioRecorderActivityState.ACTIVITY_STOPPED
                ) {
                    initializePlayer()
                    mediaPlayer!!.setOnCompletionListener {
                        setActivityState(
                            AudioRecorderActivityState.COMPLETED
                        )
                    }
                    playFile(scratchRecordingFilePath)
                } else if (previousActivityState == AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED) {
                    mediaPlayer!!.start()
                }
                updatePlaybackProgress(AudioRecorderActivityState.FIRST_PLAYBACK)
            }

            /** FIRST_PLAYBACK_PAUSED: Pause media player */
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED -> {
                mediaPlayer!!.pause()
            }

            /** COMPLETED: release the media player */
            AudioRecorderActivityState.COMPLETED -> {
                playbackProgressThread?.join()
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                _playbackProgressPbProgress.value = 0
                releasePlayer()
            }

            /**
             * NEW_PLAYING: if coming from paused state, start player. Else initialize and start the
             * player. Set the onCompletion listener to go back to the completed state
             */
            AudioRecorderActivityState.NEW_PLAYING -> {
                if (previousActivityState == AudioRecorderActivityState.NEW_PAUSED) {
                    mediaPlayer!!.start()
                } else if (previousActivityState == AudioRecorderActivityState.COMPLETED) {
                    initializePlayer()
                    mediaPlayer!!.setOnCompletionListener {
                        setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                        setActivityState(AudioRecorderActivityState.COMPLETED)
                    }
                    playFile(scratchRecordingFilePath)
                }
                updatePlaybackProgress(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** NEW_PAUSED: pause the player */
            AudioRecorderActivityState.NEW_PAUSED -> {
                mediaPlayer!!.pause()
            }

            /**
             * OLD_PLAYING: if coming from paused state, start player. Else initialize and start the
             * player. Set the onCompletion listener to go back to the completed state. Play old output
             * file.
             */
            AudioRecorderActivityState.OLD_PLAYING -> {
                if (previousActivityState == AudioRecorderActivityState.OLD_PAUSED) {
                    mediaPlayer!!.start()
                } else if (previousActivityState == AudioRecorderActivityState.COMPLETED_PRERECORDING) {
                    initializePlayer()
                    mediaPlayer!!.setOnCompletionListener {
                        _playbackProgressPbProgress.value = _playbackProgressPbMax.value
                        setButtonStates(
                            ENABLED,
                            ENABLED,
                            ENABLED,
                            ENABLED
                        )
                        setActivityState(AudioRecorderActivityState.COMPLETED_PRERECORDING)
                    }
                    playFile(outputRecordingFilePath)
                }
                updatePlaybackProgress(AudioRecorderActivityState.OLD_PLAYING)
            }

            /** OLD_PAUSED: pause the player */
            AudioRecorderActivityState.OLD_PAUSED -> {
                mediaPlayer!!.pause()
            }

            /**
             * SIMPLE_NEXT: If prerecording, then wait for prerecording job to finish. Then move to next
             * microtask
             */
            AudioRecorderActivityState.SIMPLE_NEXT -> {
                runBlocking {
                    if (isPrerecordingState(previousActivityState)) {
                        preRecordingJob?.join()
                    }
                    moveToNextMicrotask()
                    setActivityState(AudioRecorderActivityState.INIT)
                }
            }

            /**
             * SIMPLE_BACK: If prerecording, then wait for prerecording job to finish. Then move to
             * previous microtask
             */
            AudioRecorderActivityState.SIMPLE_BACK -> {
                runBlocking {
                    if (isPrerecordingState(previousActivityState)) {
                        preRecordingJob?.join()
                    }
                    moveToPreviousMicrotask()
                    setActivityState(AudioRecorderActivityState.INIT)
                }
            }

            /** ENCODING_NEXT: Encode scratch file to compressed output file. Move to next microtask. */
            AudioRecorderActivityState.ENCODING_NEXT -> {
                runBlocking {
                    encodingJob =
                        viewModelScope.launch(Dispatchers.IO) {
                            encodeRecording()
                            completeAndSaveCurrentMicrotask()
                        }
                    encodingJob?.join()
                    moveToNextMicrotask()
                    setActivityState(AudioRecorderActivityState.INIT)
                }
            }

            /**
             * ENCODING_BACK: Encode scratch file to compressed output file. Move to previous microtask.
             */
            AudioRecorderActivityState.ENCODING_BACK -> {
                runBlocking {
                    encodingJob =
                        viewModelScope.launch(Dispatchers.IO) {
                            encodeRecording()
                            completeAndSaveCurrentMicrotask()
                        }
                    encodingJob?.join()
                    moveToPreviousMicrotask()
                    setActivityState(AudioRecorderActivityState.INIT)
                }
            }

            AudioRecorderActivityState.ASSISTANT_PLAYING -> {
                /** This is a dummy state to trigger events before assistant can be played */
            }

            AudioRecorderActivityState.ACTIVITY_STOPPED -> {
                /**
                 * This is a dummy state to trigger events (e.g., end recordings). [cleanupOnStop] should
                 * take care of handling actual cleanup.
                 */
            }
        }
    }

    fun cleanupOnStop() {
        setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
        setActivityState(AudioRecorderActivityState.ACTIVITY_STOPPED)

        inputAudioPlayerOne?.release()
        inputAudioPlayerTwo?.release()

        when (previousActivityState) {
            /** If prerecording, join the prerecording job. Reset buffers and release recorder. */
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                preRecordingJob?.cancel()
                preRecordBufferConsumed[0] = 0
                preRecordBufferConsumed[1] = 0
                releaseRecorder()
            }

            /**
             * If recording, join preRecordingFlushJob, recordingJob. Reset buffers and release
             * recorder.
             */

            /**
             * If recording, join preRecordingFlushJob, recordingJob. Reset buffers and release
             * recorder.
             */
            AudioRecorderActivityState.RECORDING -> {
                recordingJob?.cancel()
                preRecordBufferConsumed[0] = 0
                preRecordBufferConsumed[1] = 0
                releaseRecorder()
            }

            /** In recorded state, wait for the file flush job to complete */

            /** In recorded state, wait for the file flush job to complete */
            AudioRecorderActivityState.RECORDED -> {
                viewModelScope.launch {
                    audioFileFlushJob?.join()
                }
            }

            /** If playing state, pause media player */

            /** If playing state, pause media player */
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            AudioRecorderActivityState.NEW_PLAYING,
            AudioRecorderActivityState.NEW_PAUSED,
            AudioRecorderActivityState.OLD_PLAYING,
            AudioRecorderActivityState.OLD_PAUSED,
            -> {
                releasePlayer()
            }

            /** In simple back and next, wait for prerecording job */

            /** In simple back and next, wait for prerecording job */
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.SIMPLE_BACK -> {
                preRecordingJob?.cancel()
                releaseRecorder()
            }

            /** Nothing to do states */

            /** Nothing to do states */
            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.COMPLETED,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            AudioRecorderActivityState.ACTIVITY_STOPPED,
            -> {
                // Do nothing
            }
        }
    }

    fun resetOnResume() {
        if (activityState != AudioRecorderActivityState.ACTIVITY_STOPPED)
            return

        when (previousActivityState) {

            /** In initial states, just reset current microtask */
            AudioRecorderActivityState.INIT,
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING,
            AudioRecorderActivityState.RECORDING,
            AudioRecorderActivityState.SIMPLE_BACK,
            AudioRecorderActivityState.SIMPLE_NEXT,
            AudioRecorderActivityState.OLD_PAUSED,
            AudioRecorderActivityState.OLD_PLAYING,
            AudioRecorderActivityState.ENCODING_NEXT,
            AudioRecorderActivityState.ENCODING_BACK,
            AudioRecorderActivityState.ASSISTANT_PLAYING,
            -> {
                resetMicrotask()
                setActivityState(AudioRecorderActivityState.INIT)
            }

            /** If recorded, then move to first playback */
            AudioRecorderActivityState.RECORDED,
            AudioRecorderActivityState.FIRST_PLAYBACK,
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED,
            -> {
                setButtonStates(DISABLED, DISABLED, ACTIVE, DISABLED)
                setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK)
            }

            /** In completed states, move back to completed state */
            AudioRecorderActivityState.COMPLETED,
            AudioRecorderActivityState.NEW_PAUSED,
            AudioRecorderActivityState.NEW_PLAYING,
            -> {
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                setActivityState(AudioRecorderActivityState.COMPLETED)
            }

            /** Stopped activity is not possible */
            AudioRecorderActivityState.ACTIVITY_STOPPED -> {
                // This is not possible
            }
        }
    }

    /** Play [mediaFilePath] */
    private fun getFileDur(mediaFilePath: String) {
        val player: MediaPlayer = mediaPlayer!!
        player.setDataSource(mediaFilePath)
        player.prepare()
        val duration = player.duration
        recordingLength = duration.toFloat() / 1000
        val milliseconds = duration
        val centiSeconds = (milliseconds / 10) % 100
        val seconds = milliseconds / 1000
        _recordSecondsTvText.value = seconds.toString()
        _recordCentiSecondsTvText.value = "%02d".format(Locale.ENGLISH, centiSeconds)
    }

    /** Play [mediaFilePath] */
    private fun playFile(mediaFilePath: String) {
        val player: MediaPlayer = mediaPlayer!!
        player.setDataSource(mediaFilePath)
        player.prepare()
        _playbackProgressPbMax.value = player.duration
        player.start()
    }

    /** Update the progress bar for the player as long as the activity is in the specific state. */
    private fun updatePlaybackProgress(state: AudioRecorderActivityState) {
        val runnable = Runnable {
            while (state == activityState) {
                val currentPosition = mediaPlayer?.currentPosition
                _playbackProgressPbProgress.value =
                    currentPosition ?: _playbackProgressPbProgress.value
                Thread.sleep(100)
            }
        }
        playbackProgressThread = Thread(runnable)
        playbackProgressThread?.start()
    }

    /** Initialize [audioRecorder] */
    @SuppressLint("MissingPermission")
    private fun initializeAndStartRecorder() {
        audioRecorder =
            AudioRecord(
                MediaRecorder.AudioSource.MIC,
                samplingRate,
                AUDIO_CHANNEL,
                audioEncoding,
                _recorderBufferSize
            )
        audioRecorder!!.startRecording()
    }

    /** Reset recording length */
    private fun resetRecordingLength(duration: Int? = null) {
        viewModelScope.launch {
            val milliseconds = duration ?: samplesToTime(totalRecordedBytes / 2)
            println("SADD#D -- $duration $milliseconds $totalRecordedBytes")
            val centiSeconds = (milliseconds / 10) % 100
            val seconds = milliseconds / 1000
            recordingLength = milliseconds.toFloat() / 1000
            _recordSecondsTvText.value = seconds.toString()
            _recordCentiSecondsTvText.value = "%02d".format(Locale.ENGLISH, centiSeconds)
        }
    }

    /** Reset wav file on a new recording creation */
    private fun resetWavFile() {
        val wavFileHandle = getAssignmentScratchFile(scratchRecordingFileParams)
        scratchRecordingFile = DataOutputStream(FileOutputStream(wavFileHandle))
        writeWavFileHeader()
    }

    /** Is the current state prerecording? */
    private fun isPrerecordingState(state: AudioRecorderActivityState): Boolean {
        return state == AudioRecorderActivityState.PRERECORDING || state == AudioRecorderActivityState.COMPLETED_PRERECORDING
    }

    /** Start prerecording. In this phase, the data from the audio recorder goes into a buffer. */
    private fun writeAudioDataToPrerecordBuffer() {
        /** Keep reading until prerecording */
        preRecordingJob =
            viewModelScope.launch(Dispatchers.IO) {
                while (isPrerecordingState(activityState)) {
                    val currentBuffer = preRecordBuffer[currentPreRecordBufferIndex]
                    val consumedBytes = preRecordBufferConsumed[currentPreRecordBufferIndex]
                    val remainingBytes = maxPreRecordBytes - consumedBytes

                    val readBytes = try {
                        audioRecorder!!.read(currentBuffer, consumedBytes, remainingBytes)
                    } catch (e: Exception) {
                        break
                    }

                    preRecordBufferConsumed[currentPreRecordBufferIndex] += readBytes

//                    println("SADD# readbytes remainding $readBytes $remainingBytes")
                    if (readBytes == remainingBytes) {
                        currentPreRecordBufferIndex = 1 - currentPreRecordBufferIndex
                        preRecordBufferConsumed[currentPreRecordBufferIndex] = 0
                    }
                }
            }
    }

    /**
     * Start recording. Wait for prerecording to complete, if coming from prerecording state. Write
     * recorded data directly to the wav file.
     */
    private fun writeAudioDataToRecordBuffer() {
        recordingJob =
            viewModelScope.launch(Dispatchers.IO) {
                if (isPrerecordingState(previousActivityState)) {
                    preRecordingJob!!.join()
                }

                totalRecordedBytes = preRecordBufferConsumed[0] + preRecordBufferConsumed[1]
                totalRecordedBytes =
                    if (totalRecordedBytes > maxPreRecordBytes) maxPreRecordBytes else totalRecordedBytes

                var data = ByteArray(_recorderBufferBytes)
                currentRecordBufferConsumed = 0
                var remainingSpace = _recorderBufferBytes

                var readBytes = 0
                while (activityState == AudioRecorderActivityState.RECORDING || readBytes > 0) {
                    try {
                        readBytes =
                            audioRecorder!!.read(data, currentRecordBufferConsumed, remainingSpace)
                    } catch (e: Exception) {
                        // Exception likely caused by recording job getting cancelled
                        break
                    }
                    if (readBytes > 0) {
                        currentRecordBufferConsumed += readBytes
                        remainingSpace -= readBytes
                        if (remainingSpace == 0) {
                            recordBuffers.add(data)
                            data = ByteArray(_recorderBufferBytes)
                            currentRecordBufferConsumed = 0
                            remainingSpace = _recorderBufferBytes
                        }
                        totalRecordedBytes += readBytes
                        resetRecordingLength()
                    }
                }

                recordBuffers.add(data)
            }
    }

    /** Finish recording and finalize the wav file (update the file size) */
    private fun finishRecordingAndFinalizeWavFile() {
        runBlocking {
            audioFileFlushJob =
                CoroutineScope(Dispatchers.IO).launch {
                    delay(postRecordingTime.toLong())
                    audioRecorder!!.stop()

                    recordingJob!!.join()
                    audioRecorder!!.release()

                    /** Write data to file */

                    /** Write data to file */
                    scratchRecordingFileInitJob.join()

                    /** Write the prerecord buffer to file */
                    /** Write the prerecord buffer to file */
                    val bufferIndex = currentPreRecordBufferIndex
                    val otherIndex = 1 - bufferIndex
                    var currentBufferBytes = preRecordBufferConsumed[bufferIndex]
                    val otherBufferBytes = preRecordBufferConsumed[otherIndex]

                    println("SADD# finishRecordingAndFinalizeWavFile -2 $otherIndex ${preRecordBufferConsumed[0]} ${preRecordBufferConsumed[1]} $totalRecordedBytes $otherIndex $otherBufferBytes")
                    if (currentBufferBytes < 0) {
                        currentBufferBytes = 0
                    }

                    println("SADD# finishRecordingAndFinalizeWavFile -1 $totalRecordedBytes $otherBufferBytes")
                    val currentBuffer = preRecordBuffer[bufferIndex]
                    val otherBuffer = preRecordBuffer[otherIndex]

                    println("SADD# finishRecordingAndFinalizeWavFile 1 $totalRecordedBytes $otherBufferBytes")
                    // If other buffer is not empty, first write tail from other buffer
                    if (otherBufferBytes != 0) {
                        scratchRecordingFile.write(
                            otherBuffer,
                            currentBufferBytes,
                            maxPreRecordBytes - currentBufferBytes
                        )
                        totalRecordedBytes = maxPreRecordBytes - currentBufferBytes
                    }

                    println("SADD# finishRecordingAndFinalizeWavFile 2 $totalRecordedBytes")
                    // write current buffer
                    scratchRecordingFile.write(currentBuffer, 0, currentBufferBytes)
                    totalRecordedBytes += currentBufferBytes

                    /** Write the main record buffer */

                    /** Write the main record buffer */
                    println("SADD# finishRecordingAndFinalizeWavFile 3 $totalRecordedBytes ${recordBuffers.lastIndex} $_recorderBufferBytes")
                    for (i in 0 until recordBuffers.lastIndex) {
                        scratchRecordingFile.write(recordBuffers[i], 0, _recorderBufferBytes)
                        totalRecordedBytes += _recorderBufferBytes
                    }

                    /** Write the last buffer */

                    /** Write the last buffer */
                    try {
                        if (currentRecordBufferConsumed > 0) {
                            val lastBuffer = recordBuffers.last()
                            scratchRecordingFile.write(lastBuffer, 0, currentRecordBufferConsumed)
                            totalRecordedBytes += currentRecordBufferConsumed
                        }
                    } catch (e: Exception) {
                        // Ignore (rare) errors
                    }

                    resetRecordingLength()

                    /** Close the file */

                    /** Close the file */
                    scratchRecordingFile.close()

                    /** Fix the file size fields in the wav file */
                    /** Fix the file size fields in the wav file */
                    val dataSize = totalRecordedBytes
                    val scratchFile = RandomAccessFile(scratchRecordingFilePath, "rw")
                    writeIntAtLocation(scratchFile, dataSize + 36, 4)
                    writeIntAtLocation(scratchFile, dataSize, 40)
                    scratchFile.close()
                }

            /**
             * If still in recorded state, switch to playback. User may have stopped activity by pressing
             * home button.
             */

            /**
             * If still in recorded state, switch to playback. User may have stopped activity by pressing
             * home button.
             */
            CoroutineScope(Dispatchers.IO).launch {
                audioFileFlushJob!!.join()
                if (activityState == AudioRecorderActivityState.RECORDED) {
                    if (noForcedReplay) {
                        setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
                        setActivityState(AudioRecorderActivityState.COMPLETED)
                    } else {
                        setButtonStates(DISABLED, DISABLED, ACTIVE, DISABLED)
                        setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK)
                    }
                }
            }
        }
    }

    /** Write WAV file header */
    private fun writeWavFileHeader() {
        val bitsPerSample = if (audioEncoding == AudioFormat.ENCODING_PCM_16BIT) 16 else 8
        val bytesPerSample = bitsPerSample / 8

        writeString(scratchRecordingFile, "RIFF")
        writeInt(scratchRecordingFile, 0)
        writeString(scratchRecordingFile, "WAVE")
        writeString(scratchRecordingFile, "fmt ")
        writeInt(scratchRecordingFile, 16)
        writeShort(scratchRecordingFile, 1.toShort())
        writeShort(scratchRecordingFile, 1.toShort())
        writeInt(scratchRecordingFile, samplingRate)
        writeInt(scratchRecordingFile, samplingRate * bytesPerSample)
        writeShort(scratchRecordingFile, bytesPerSample.toShort())
        writeShort(scratchRecordingFile, bitsPerSample.toShort())
        writeString(scratchRecordingFile, "data")
        writeInt(scratchRecordingFile, 0)
    }

    /** Encode the scratch wav recording file into a compressed main file. */
    private suspend fun encodeRecording() {
        CoroutineScope(Dispatchers.IO)
            .launch {
                if (compressAudio) {
                    RawToAACEncoder(samplingRate).encode(
                        scratchRecordingFilePath,
                        outputRecordingFilePath
                    )
                } else {
                    val source = FileInputStream(scratchRecordingFilePath)
                    val destination = FileOutputStream(outputRecordingFilePath)
                    source.copyTo(destination)
                    destination.close()
                    source.close()
                }
            }
            .join()

        /** Check if the task is uploadable **/

        outputData.addProperty("duration", recordingLength)
        addOutputFile("recording", outputRecordingFileParams)

    }

    /** Helper method to convert number of [samples] to time in milliseconds */
    private fun samplesToTime(samples: Int): Int {
        return ((samples.toFloat() / samplingRate) * 1000).toInt()
    }

    /** Helper methods to convert [time] in milliseconds to number of samples */
    private fun timeToSamples(time: Int): Int {
        return time * samplingRate / 1000
    }

    /** Helper methods to write data in little endian format */
    private fun writeInt(output: DataOutputStream, value: Int) {
        output.write(value shr 0)
        output.write(value shr 8)
        output.write(value shr 16)
        output.write(value shr 24)
    }

    private fun writeIntAtLocation(output: RandomAccessFile, value: Int, location: Long) {
        val data = ByteArray(4)
        data[0] = (value shr 0).toByte()
        data[1] = (value shr 8).toByte()
        data[2] = (value shr 16).toByte()
        data[3] = (value shr 24).toByte()
        output.seek(location)
        output.write(data)
    }

    private fun writeShort(output: DataOutputStream, value: Short) {
        output.write(value.toInt() shr 0)
        output.write(value.toInt() shr 8)
    }

    private fun writeString(output: DataOutputStream, value: String) {
        for (element in value) {
            output.writeBytes(element.toString())
        }
    }

    /** Initialize [mediaPlayer] */
    private fun initializePlayer() {
        mediaPlayer = MediaPlayer()
    }

    /** Release the media player and hide seek bar */
    private fun releasePlayer() {
        mediaPlayer?.stop()
        mediaPlayer?.reset()
        mediaPlayer?.release()
        mediaPlayer = null
    }

    private fun releaseInputMediaPlayer() {
        inputAudioPlayerOne?.stop()
        inputAudioPlayerOne?.release()
        inputAudioPlayerTwo?.stop()
        inputAudioPlayerTwo?.release()
    }

    /** Release the audio recorder */
    fun releaseRecorder() {
        if (audioRecorder?.state == AudioRecord.STATE_INITIALIZED) {
            if (audioRecorder?.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                audioRecorder?.stop()
            }
        }
        audioRecorder?.release()
        audioRecorder = null
    }

    private fun updateInputAudioTime(
        player: String
    ) {
        inputAudioTimeUpdateJob?.cancel()
        inputAudioTimeUpdateJob = viewModelScope.launch(Dispatchers.IO) {
            while (true) {
                when (player) {
                    "One" -> {
                        val currentTime =
                            ((inputAudioPlayerOne!!.currentPosition.toDouble() / inputAudioPlayerOne!!.duration.toDouble()) * 100).toInt()
                        // For showing the progress in the progress bar
                        inputAudioPlayerOneTime.postValue(currentTime)
                        // For showing the current and total time stamp in the player
                        inputAudioPlayerOneTimestamp.postValue(
                            Pair(
                                DateTimeUtils.millisecondToTime(inputAudioPlayerOne!!.currentPosition.toDouble()),
                                DateTimeUtils.millisecondToTime(inputAudioPlayerOne!!.duration.toDouble())
                            )
                        )
                    }

                    "Two" -> {
                        val currentTime =
                            ((inputAudioPlayerTwo!!.currentPosition.toDouble() / inputAudioPlayerTwo!!.duration.toDouble()) * 100).toInt()
                        // For showing the progress in the progress bar
                        inputAudioPlayerTwoTime.postValue(currentTime)
                        // For showing the current and total time stamp in the player
                        inputAudioPlayerTwoTimestamp.postValue(
                            Pair(
                                DateTimeUtils.millisecondToTime(inputAudioPlayerTwo!!.currentPosition.toDouble()),
                                DateTimeUtils.millisecondToTime(inputAudioPlayerTwo!!.duration.toDouble())
                            )
                        )
                    }
                }
                delay(500)
            }
        }
    }

    fun controlInputAudioPlayer(
        control: String,
        player: String
    ) {
        if (arrayOf(
                AudioRecorderActivityState.RECORDING,
                AudioRecorderActivityState.NEW_PLAYING
            ).contains(activityState)
        ) {
            return
        }
        when (control) {
            "Start" -> {
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.start()
                        inputAudioPlayerOneState.value = InputAudioPlayerState.PLAYING
                        if (inputAudioPlayerTwoState.value == InputAudioPlayerState.PLAYING) {
                            inputAudioPlayerTwo!!.pause()
                            inputAudioPlayerTwoState.value = InputAudioPlayerState.PAUSED
                        }
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.start()
                        inputAudioPlayerTwoState.value = InputAudioPlayerState.PLAYING
                        if (inputAudioPlayerOneState.value == InputAudioPlayerState.PLAYING) {
                            inputAudioPlayerOne!!.pause()
                            inputAudioPlayerOneState.value = InputAudioPlayerState.PAUSED
                        }
                    }
                }
                setButtonStates(DISABLED, DISABLED, DISABLED, DISABLED)
                updateInputAudioTime(player)
            }

            "Stop" -> {
                inputAudioTimeUpdateJob?.cancel()
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.stop()
                        inputAudioPlayerOne!!.release()
                        inputAudioPlayerOneState.value = InputAudioPlayerState.RELEASED
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.stop()
                        inputAudioPlayerTwo!!.release()
                        inputAudioPlayerTwoState.value = InputAudioPlayerState.RELEASED
                    }

                }
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
            }

            "Pause" -> {
                inputAudioTimeUpdateJob?.cancel()
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.pause()
                        inputAudioPlayerOneState.value = InputAudioPlayerState.PAUSED
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.pause()
                        inputAudioPlayerTwoState.value = InputAudioPlayerState.PAUSED
                    }
                }
                inputAudioTimeUpdateJob?.cancel()
                setButtonStates(ENABLED, ENABLED, ENABLED, ENABLED)
            }
        }
    }

    private fun setUpInputAudio() {


        val inputAudioPromptFileNameOne =
            currentMicroTask.input.asJsonObject.getAsJsonObject("files")
                .get("audio_prompt").toString()

        val inputAudioPromptFileOne = microtaskInputContainer.getMicrotaskInputFilePath(
            currentMicroTask.id,
            inputAudioPromptFileNameOne
        ).replace("\"", "")

        inputAudioPlayerOne = MediaPlayer()
        inputAudioPlayerOne?.setDataSource(inputAudioPromptFileOne)
        inputAudioPlayerOne?.prepare()


        inputAudioPlayerOne!!.setOnPreparedListener {
            inputAudioPlayerOneState.value = InputAudioPlayerState.PREPARED
            inputAudioPlayerOneTimestamp.value =
                Pair("0:00", DateTimeUtils.millisecondToTime(it.duration.toDouble()))
        }

        inputAudioPlayerOne!!.setOnCompletionListener {
            inputAudioPlayerOneTime.value = 100
            inputAudioPlayerOneTimestamp.value =
                Pair(
                    DateTimeUtils.millisecondToTime(it.duration.toDouble()),
                    DateTimeUtils.millisecondToTime(it.duration.toDouble())
                )
        }


        if (task.scenario_name == ScenarioType.SPEECH_DC_AUDREF) {

            val inputAudioPromptFileNameTwo =
                currentMicroTask.input.asJsonObject.getAsJsonObject("files")
                    .get("audio_prompt").toString()

            val inputAudioPromptFileTwo = microtaskInputContainer.getMicrotaskInputFilePath(
                currentMicroTask.id,
                inputAudioPromptFileNameTwo
            ).replace("\"", "")

            inputAudioPlayerTwo = MediaPlayer()
            inputAudioPlayerTwo?.setDataSource(inputAudioPromptFileTwo)
            inputAudioPlayerTwo?.prepare()

            inputAudioPlayerTwo!!.setOnPreparedListener {
                inputAudioPlayerTwoState.value = InputAudioPlayerState.PREPARED
                inputAudioPlayerTwoTimestamp.value =
                    Pair("0:00", DateTimeUtils.millisecondToTime(it.duration.toDouble()))
            }

            inputAudioPlayerTwo!!.setOnCompletionListener {
                inputAudioPlayerTwoTime.value = 100
                inputAudioPlayerTwoTimestamp.value =
                    Pair(
                        DateTimeUtils.millisecondToTime(it.duration.toDouble()),
                        DateTimeUtils.millisecondToTime(it.duration.toDouble())
                    )
            }
        }


    }

}