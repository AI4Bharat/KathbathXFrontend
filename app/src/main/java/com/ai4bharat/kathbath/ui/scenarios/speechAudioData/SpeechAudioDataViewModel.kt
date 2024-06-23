package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import android.annotation.SuppressLint
import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaPlayer
import android.media.MediaRecorder
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderActivityState
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.InputAudioPlayerState
import com.ai4bharat.kathbath.data.model.karya.enums.MicrotaskAssignmentStatus
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import com.ai4bharat.kathbath.ui.scenarios.speechImageData.SpeechImageDataViewModel
import com.ai4bharat.kathbath.utils.DateTimeUtils
import com.ai4bharat.kathbath.utils.PreferenceKeys
import com.ai4bharat.kathbath.utils.RawToAACEncoder
import com.ai4bharat.kathbath.utils.WAVFileUtils
import com.google.gson.JsonObject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.android.synthetic.main.microtask_speech_image_data.inputAudioPlayButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.inputAudioProgressBar
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImagePlayButton
import kotlinx.android.synthetic.main.microtask_speech_image_data.speechImageRecordButton
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.Dispatcher
import java.io.DataOutputStream
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.RandomAccessFile
import java.util.Locale
import javax.inject.Inject

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
) :
    BaseMTRendererViewModel(
        assignmentRepository,
        taskRepository,
        microTaskRepository,
        fileDirPath,
        authManager
    ) {

    private val postRecordingTime: Int = 4
    private val prerecordingTime: Int = 4
    private val maxPreRecordBytes = timeToSamples(prerecordingTime) * 2
    private var noForcedReplay: Boolean = true
    private var firstTimeActivityVisit: Boolean = true

    private var mediaPlayer: MediaPlayer? = null
    private var audioRecorder: AudioRecord? = null

    /** Input media player parameters*/
    private var inputAudioPlayerOne: MediaPlayer? = null
    private var inputAudioPlayerTwo: MediaPlayer? = null
    private val _inputAudioPlayerOneState: MutableStateFlow<InputAudioPlayerState> =
        MutableStateFlow(
            InputAudioPlayerState.DISABLED
        )
    val inputAudioPlayerOneState = _inputAudioPlayerOneState.asStateFlow()
    private val _inputAudioPlayerTwoState: MutableStateFlow<InputAudioPlayerState> =
        MutableStateFlow(
            InputAudioPlayerState.DISABLED
        )
    val inputAudioPlayerTwoState = _inputAudioPlayerTwoState.asStateFlow()
    var inputAudioPlayerOneTime: MutableLiveData<Int> = MutableLiveData<Int>(0)
    var inputAudioPlayerTwoTime: MutableLiveData<Int> = MutableLiveData<Int>(0)

    /** first -> current time, second -> total duration*/
    var inputAudioPlayerOneTimestamp: MutableLiveData<Pair<String, String>> =
        MutableLiveData<Pair<String, String>>(
            Pair("0:00", "0:00")
        )
    var inputAudioPlayerTwoTimestamp: MutableLiveData<Pair<String, String>> =
        MutableLiveData<Pair<String, String>>(Pair("0:00", "0:00"))


    /** List of coroutines used */
    private var recordingJob: Job? = null
    private var audioFileFlushJob: Job? = null
    private var inputAudioTimeUpdateJob: Job? = null
    private var preRecordingJob: Job? = null

    private var playbackProgressThread: Thread? = null

    private var allowSkipping: Boolean = false

    /** Speech data collection parameters */
    private var samplingRate: Int = 44100
    private var audioEncoding: Int = AudioFormat.ENCODING_PCM_16BIT
    private var compressAudio: Boolean = false

    private val _minBufferSize =
        AudioRecord.getMinBufferSize(samplingRate, AudioFormat.CHANNEL_IN_MONO, audioEncoding)
    private val _recorderBufferSize = _minBufferSize * 4
    private val _recorderBufferBytes = _recorderBufferSize

    /** The recorded data will be added as a ByteArray each time data is read*/
    private var recordBuffers: ArrayList<ByteArray> = arrayListOf()
    private var preRecordBuffer: Array<ByteArray>
    private var currentRecordBufferConsumed = 0
    private var recordingLength: Float = 0.0f

    //    private var preRecordBuffer: Array<ByteArray>
    var preRecordBufferConsumed: Array<Int> = Array(2) { 0 }
    private var currentPreRecordBufferIndex = 0


    /** scratch WAV file */
    private val scratchRecordingFileParams = Pair("", "wav")
    lateinit var scratchRecordingFilePath: String
    private lateinit var scratchRecordingFile: DataOutputStream
    private lateinit var scratchRecordingFileInitJob: Job

    /** Final WAV file */
    var outputRecordingFileParams = Pair("", "wav")
    lateinit var outputRecordingFilePath: String
    private var encodingJob: Job? = null
    var extempore: Boolean = false

    /** Audio recording progress */
    private val _playbackProgressPbProgress: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgressPb = _playbackProgressPbProgress.asStateFlow()

    /**Recording metrics */
    private var totalRecordedBytes = 0

    private val _playbackProgressPbMax: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgressPbMax = _playbackProgressPbMax.asStateFlow()

    private val _playBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(
            AudioRecorderButtonState.DISABLED
        )
    val playBtnState = _playBtnState.asStateFlow()

    private val _nextBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(
            AudioRecorderButtonState.DISABLED
        )
    val nextBtnState = _nextBtnState.asStateFlow()

    private val _backBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(
            AudioRecorderButtonState.DISABLED
        )
    val backBtnState = _backBtnState.asStateFlow()

    private val _recordBtnState: MutableStateFlow<AudioRecorderButtonState> =
        MutableStateFlow(
            AudioRecorderButtonState.DISABLED
        )
    val recordBtnState = _recordBtnState.asStateFlow()

    private val _recordSecondsTvText: MutableStateFlow<String> = MutableStateFlow("0")
    val recordSecondsTvText = _recordSecondsTvText.asStateFlow()

    private val _recordCentiSecondsTvText: MutableStateFlow<String> = MutableStateFlow("00")
    val recordCentiSecondsTvText = _recordCentiSecondsTvText.asStateFlow()

    private val _playRecordPromptTrigger: MutableStateFlow<Boolean> = MutableStateFlow(false)
    val playRecordPromptTrigger = _playRecordPromptTrigger.asStateFlow()

    private val _skipTaskAlertTrigger: MutableStateFlow<Boolean> = MutableStateFlow(false)
    val skipTaskAlertTrigger = _skipTaskAlertTrigger.asStateFlow()

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

    @JvmField
    var activityState: AudioRecorderActivityState =
        AudioRecorderActivityState.INIT
    var previousActivityState: AudioRecorderActivityState =
        AudioRecorderActivityState.INIT

    fun setUpInputAudio(context: Context, audioFilePath: Int) {
        inputAudioPlayerOne = MediaPlayer.create(context, audioFilePath)
        inputAudioPlayerTwo = MediaPlayer.create(context, audioFilePath)

        inputAudioPlayerOne!!.setOnPreparedListener {
            _inputAudioPlayerOneState.value = InputAudioPlayerState.PREPARED
            inputAudioPlayerOneTimestamp.value =
                Pair("0:00", DateTimeUtils.millisecondToTime(it.duration.toDouble()))
        }
        inputAudioPlayerTwo!!.setOnPreparedListener {
            _inputAudioPlayerTwoState.value = InputAudioPlayerState.PREPARED
            inputAudioPlayerTwoTimestamp.value =
                Pair("0:00", DateTimeUtils.millisecondToTime(it.duration.toDouble()))
        }

        inputAudioPlayerOne!!.setOnCompletionListener {
            inputAudioPlayerOneTime.value = 100
            _inputAudioPlayerOneState.value = InputAudioPlayerState.RELEASED
            inputAudioPlayerOneTimestamp.value =
                Pair(
                    DateTimeUtils.millisecondToTime(it.duration.toDouble()),
                    DateTimeUtils.millisecondToTime(it.duration.toDouble())
                )
        }

        inputAudioPlayerTwo!!.setOnCompletionListener {
            inputAudioPlayerTwoTime.value = 100
            _inputAudioPlayerTwoState.value = InputAudioPlayerState.RELEASED
            inputAudioPlayerTwoTimestamp.value =
                Pair(
                    DateTimeUtils.millisecondToTime(it.duration.toDouble()),
                    DateTimeUtils.millisecondToTime(it.duration.toDouble())
                )
        }
    }

    fun controlAudioPlayer(
        control: String,
        player: String = "One"
    ) {

        when (control) {
            "Start" -> {
                inputAudioPlayerOne!!.start()
                updateInputAudioTime(player)
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.start()
                        _inputAudioPlayerOneState.value = InputAudioPlayerState.PLAYING
                        inputAudioPlayerTwo!!.pause()
                        _inputAudioPlayerTwoState.value = InputAudioPlayerState.PAUSED
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.start()
                        _inputAudioPlayerTwoState.value = InputAudioPlayerState.PLAYING
                        inputAudioPlayerOne!!.pause()
                        _inputAudioPlayerOneState.value = InputAudioPlayerState.PAUSED
                    }
                }
                updateInputAudioTime(player)
            }

            "Stop" -> {
                inputAudioTimeUpdateJob?.cancel()
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.stop()
                        inputAudioPlayerOne!!.release()
                        _inputAudioPlayerOneState.value = InputAudioPlayerState.RELEASED
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.stop()
                        inputAudioPlayerTwo!!.release()
                        _inputAudioPlayerTwoState.value = InputAudioPlayerState.RELEASED
                    }
                }
            }

            "Pause" -> {
                when (player) {
                    "One" -> {
                        inputAudioPlayerOne!!.pause()
                        _inputAudioPlayerOneState.value = InputAudioPlayerState.PAUSED
                    }

                    "Two" -> {
                        inputAudioPlayerTwo!!.pause()
                        _inputAudioPlayerTwoState.value = InputAudioPlayerState.PAUSED
                    }
                }
                inputAudioTimeUpdateJob?.cancel()
            }
        }
    }


    private fun updateInputAudioTime(
        player: String = "One"
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

    override fun setupMicrotask() {

        //getAssignmentScratchFilePath is defined in the parent class
        scratchRecordingFilePath = getAssignmentScratchFilePath(scratchRecordingFileParams)
        outputRecordingFilePath = assignmentOutputContainer.getAssignmentOutputFilePath(
            microtaskAssignmentIDs[currentAssignmentIndex],
            outputRecordingFileParams
        )

        scratchRecordingFileInitJob = CoroutineScope(Dispatchers.IO).launch { resetWavFile() }
        _playbackProgressPbProgress.value = 0

        if (currentMicroTask.input.asJsonObject.getAsJsonObject("data")
                .get("instruction") != null
        ) {
//            _microTaskInstruction.value =
//                currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("instruction")
//                    .toString()
            totalRecordedBytes = 0
        }

        val hints = currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("hints")

//        _sentenceTvText.value =
//            currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()


        totalRecordedBytes = 0

        extempore = task.name.contains("Extempore Dialogue", true)
        if (extempore) {
            _recordBtnState.value = AudioRecorderButtonState.ENABLED
        }
        /** Get microtask config */
        try {
            allowSkipping = task.params.asJsonObject.get("allowSkipping").asBoolean
        } catch (e: Exception) {
            allowSkipping = false
        }

        if (firstTimeActivityVisit) {
            firstTimeActivityVisit = false
//            onAssistantClick()
        } else {
            moveToPrerecording()
        }

    }

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
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED
                )
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
                        setButtonStates(
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED
                        )
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
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED
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


    private fun initializePlayer() {
        mediaPlayer = MediaPlayer()
    }

    private fun finishRecordingAndFinalizeWavFile() {
        runBlocking {
            audioFileFlushJob =
                CoroutineScope(Dispatchers.IO).launch {
                    delay(postRecordingTime.toLong())
                    audioRecorder!!.stop()

                    recordingJob!!.join()
                    audioRecorder!!.release()

                    /** Write data to file */
                    scratchRecordingFileInitJob.join()

                    /** Write the prerecord buffer to file */
                    val bufferIndex = currentPreRecordBufferIndex
                    val otherIndex = 1 - bufferIndex
                    var currentBufferBytes = preRecordBufferConsumed[bufferIndex]
                    val otherBufferBytes = preRecordBufferConsumed[otherIndex]

                    if (currentBufferBytes < 0) {
                        currentBufferBytes = 0
                    }

                    val currentBuffer = preRecordBuffer[bufferIndex]
                    val otherBuffer = preRecordBuffer[otherIndex]

                    // If other buffer is not empty, first write tail from other buffer
                    if (otherBufferBytes != 0) {
                        scratchRecordingFile.write(
                            otherBuffer,
                            currentBufferBytes,
                            maxPreRecordBytes - currentBufferBytes
                        )
                        totalRecordedBytes = maxPreRecordBytes - currentBufferBytes
                    }

                    // write current buffer
                    scratchRecordingFile.write(currentBuffer, 0, currentBufferBytes)
                    totalRecordedBytes += currentBufferBytes

                    /** Write the main record buffer */
                    for (i in 0 until recordBuffers.lastIndex) {
                        scratchRecordingFile.write(recordBuffers[i], 0, _recorderBufferBytes)
                        totalRecordedBytes += _recorderBufferBytes
                    }

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
                    scratchRecordingFile.close()

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
            CoroutineScope(Dispatchers.IO).launch {
                audioFileFlushJob!!.join()
                if (activityState == AudioRecorderActivityState.RECORDED) {
                    if (noForcedReplay) {
                        setButtonStates(
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED,
                            AudioRecorderButtonState.ENABLED
                        )
                        setActivityState(AudioRecorderActivityState.COMPLETED)
                    } else {
                        setButtonStates(
                            AudioRecorderButtonState.DISABLED,
                            AudioRecorderButtonState.DISABLED,
                            AudioRecorderButtonState.ACTIVE,
                            AudioRecorderButtonState.DISABLED
                        )
                        setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK)
                    }
                }
            }
        }
    }

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

//    Log.e("[duration]",recordingLength.toString())
        outputData.addProperty("duration", recordingLength)
        addOutputFile("recording", outputRecordingFileParams)
//    Log.e("{OP EXT}",outputRecordingFileParams.toString())

    }

    private fun playFile(mediaFilePath: String) {
        val player: MediaPlayer = mediaPlayer!!
        player.setDataSource(mediaFilePath)
        player.prepare()
        _playbackProgressPbMax.value = player.duration
        player.start()
    }


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

                    if (readBytes == remainingBytes) {
                        currentPreRecordBufferIndex = 1 - currentPreRecordBufferIndex
                        preRecordBufferConsumed[currentPreRecordBufferIndex] = 0
                    }
                }
            }
    }

    private fun isPrerecordingState(state: AudioRecorderActivityState): Boolean {
        return state == AudioRecorderActivityState.PRERECORDING || state == AudioRecorderActivityState.COMPLETED_PRERECORDING
    }

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
        ) else outputRecordingFileParams
    }

    /** Reset wav file on a new recording creation */
    private fun resetWavFile() {
        val wavFileHandle = getAssignmentScratchFile(scratchRecordingFileParams)
        scratchRecordingFile = DataOutputStream(FileOutputStream(wavFileHandle))
        writeWavFileHeader()
    }

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


    /** Release the media player and hide seek bar */
    private fun releasePlayer() {
        mediaPlayer?.stop()
        mediaPlayer?.reset()
        mediaPlayer?.release()
        mediaPlayer = null
    }

    fun releaseRecorder() {
        if (audioRecorder?.state == AudioRecord.STATE_INITIALIZED) {
            if (audioRecorder?.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                audioRecorder?.stop()
            }
        }
        audioRecorder?.release()
        audioRecorder = null
    }

    @SuppressLint("MissingPermission")
    private fun initializeAndStartRecorder() {
        audioRecorder =
            AudioRecord(
                MediaRecorder.AudioSource.MIC,
                samplingRate,
                AudioFormat.CHANNEL_IN_MONO,
                audioEncoding,
                _recorderBufferSize
            )
        audioRecorder!!.startRecording()
    }

    /**
     * Start recording. Wait for prerecording to complete, if coming from prerecording state. Write recorded data directly to the wav file.
     */
    private fun writeAudioDataToRecordBuffer() {
        recordingJob =
            viewModelScope.launch(Dispatchers.IO) {
//                if (isPrerecordingState(previousActivityState)) {
//                    preRecordingJob!!.join()
//                }

//                totalRecordedBytes = preRecordBufferConsumed[0] + preRecordBufferConsumed[1]
//                totalRecordedBytes =
//                    if (totalRecordedBytes > maxPreRecordBytes) maxPreRecordBytes else totalRecordedBytes

                var data = ByteArray(_recorderBufferBytes)
                currentRecordBufferConsumed = 0
                var remainingSpace = _recorderBufferBytes

                var readBytes = 0
                while (activityState == AudioRecorderActivityState.RECORDING || readBytes > 0) {
                    try {
                        /** Read "currentRecordBufferConsumed" num of audio data to the bytearray data
                         * returns the amount of data consumed
                         */
                        readBytes =
                            audioRecorder!!.read(data, currentRecordBufferConsumed, remainingSpace)
                    } catch (e: Exception) {
                        // Exception likely caused by recording job getting cancelled
                        break
                    }
                    if (readBytes > 0) {
                        currentRecordBufferConsumed += readBytes
                        remainingSpace -= readBytes
                        /** If the buffer is full add more space to the buffer*/
                        if (remainingSpace == 0) {
                            /** Add the consumed data to recordBuffer(Arraylist of byte array)*/
                            recordBuffers.add(data)
                            /** Creating new buffer for storing consumed data*/
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

    private fun resetRecordingLength(duration: Int? = null) {
        fun samplesToTime(samples: Int): Int {
            return ((samples.toFloat() / samplingRate) * 1000).toInt()
        }
        viewModelScope.launch {
            val milliseconds = duration ?: samplesToTime(totalRecordedBytes / 2)
            val centiSeconds = (milliseconds / 10) % 100
            val seconds = milliseconds / 1000
            recordingLength = milliseconds.toFloat() / 1000
            _recordSecondsTvText.value = seconds.toString()
            _recordCentiSecondsTvText.value = "%02d".format(Locale.ENGLISH, centiSeconds)
        }
    }

    private fun timeToSamples(time: Int): Int {
        return time * samplingRate / 1000
    }

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

    private fun playRecordPrompt() {
        _playRecordPromptTrigger.value = true
    }

    fun skipMicrotask() {
        runBlocking {
            skipAndSaveCurrentMicrotask()
            setActivityState(AudioRecorderActivityState.SIMPLE_NEXT)
            setSkipTaskAlertTrigger(false)
        }
    }

    fun setSkipTaskAlertTrigger(value: Boolean) {
        _skipTaskAlertTrigger.value = value
    }

    fun moveToPrerecording() {
        preRecordBufferConsumed[0] = 0
        preRecordBufferConsumed[1] = 0

        if (currentAssignment.status != MicrotaskAssignmentStatus.COMPLETED) {
            setButtonStates(
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.DISABLED,
                AudioRecorderButtonState.DISABLED
            )
            // Enable next button if skipping allowed
            if (allowSkipping) {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ENABLED
                )
            }
            setActivityState(AudioRecorderActivityState.PRERECORDING)
            resetRecordingLength()
        } else {
            setButtonStates(
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED
            )

            val mPlayer = MediaPlayer()
            mPlayer.setDataSource(outputRecordingFilePath)
            mPlayer.prepare()
            resetRecordingLength(mPlayer.duration)
            mPlayer.release()
            setActivityState(AudioRecorderActivityState.COMPLETED_PRERECORDING)
        }
    }

    fun handleRecordClick() {
        // log the state transition
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "RECORD")
        message.addProperty("state", recordBtnState.toString())
        log(message)

        /** Determine action based on current state */
        when (activityState) {
            /**
             * Prerecording states: Set target button states. Wait for wave file init job and prerecording
             * job to finish. Write the prerecord buffer to wav file. Start regular recording.
             */
            AudioRecorderActivityState.PRERECORDING,
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED
                )
                setActivityState(AudioRecorderActivityState.RECORDING)
            }

            /** COMPLETED: Just reset wav file and restart recording */
            AudioRecorderActivityState.COMPLETED -> {
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED
                )

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
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED
                )

                releasePlayer()
                scratchRecordingFileInitJob =
                    viewModelScope.launch(Dispatchers.IO) { resetWavFile() }
                setActivityState(AudioRecorderActivityState.RECORDING)
            }

            /** RECORDING: Set target button states. Move to recorded state */
            AudioRecorderActivityState.RECORDING -> {
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED
                )
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
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.DISABLED
                )
                setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED)
            }

            /** If coming from first playback paused, resume player */
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED -> {
                setButtonStates(
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.DISABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.DISABLED
                )
                setActivityState(AudioRecorderActivityState.FIRST_PLAYBACK)
            }

            /** If coming from completed, play the scratch wav file */
            AudioRecorderActivityState.COMPLETED -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.ENABLED
                )
                setActivityState(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** on NEW_PLAYING, move to NEW_PAUSED */
            AudioRecorderActivityState.NEW_PLAYING -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED
                )
                setActivityState(AudioRecorderActivityState.NEW_PAUSED)
            }

            /** on NEW_PAUSED, move to NEW_PLAYING */
            AudioRecorderActivityState.NEW_PAUSED -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.ENABLED
                )
                setActivityState(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** COMPLETED_PRERECORDING: Move to old playing */
            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.ENABLED
                )
                setActivityState(AudioRecorderActivityState.OLD_PLAYING)
            }

            /** OLD_PLAYING: Move to old paused */
            AudioRecorderActivityState.OLD_PLAYING -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED
                )
                setActivityState(AudioRecorderActivityState.OLD_PAUSED)
            }

            /** OLD_PAUSED: Move to old playing */
            AudioRecorderActivityState.OLD_PAUSED -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.ENABLED
                )
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
}