package com.ai4bharat.kathbath.ui.scenarios.speechAudioData

import android.annotation.SuppressLint
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaPlayer
import android.media.MediaRecorder
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderActivityState
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.Dispatcher
import java.io.DataOutputStream
import java.io.FileOutputStream
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

    private var recodedAudioPlayer: MediaPlayer? = null
    private var audioRecorder: AudioRecord? = null

    /** List of coroutines used */
    private var recordingJob: Job? = null

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
    private var currentRecordBufferConsumed = 0
    private var recordingLength: Float = 0.0f

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


    @JvmField
    var activityState: AudioRecorderActivityState =
        AudioRecorderActivityState.INIT
    var previousActivityState: AudioRecorderActivityState =
        AudioRecorderActivityState.INIT

    override fun setupMicrotask() {

        //getAssignmentScratchFilePath is defined in the parent class
        scratchRecordingFilePath = getAssignmentScratchFilePath(scratchRecordingFileParams)
        outputRecordingFilePath = assignmentOutputContainer.getAssignmentOutputFilePath(
            microtaskAssignmentIDs[currentAssignmentIndex],
            outputRecordingFileParams
        )

        scratchRecordingFileInitJob = CoroutineScope(Dispatchers.IO).launch { resetWavFile() }
        _playbackProgressPbProgress.value = 0

    }

    fun handleRecordClick() {
        when (activityState) {
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

        }
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
//        writeWavFileHeader()
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

    fun setActivityState(targetState: AudioRecorderActivityState) {
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

//            /** PRERECORDING: Create audio recorder and start prerecording */
//            AudioRecorderActivityState.PRERECORDING -> {
//                initializeAndStartRecorder()
//                writeAudioDataToPrerecordBuffer()
//            }
//
//            /** COMPLETED_PRERECORDING: Create audio recorder and start prerecording */
//            AudioRecorderActivityState.COMPLETED_PRERECORDING -> {
//                initializeAndStartRecorder()
//                writeAudioDataToPrerecordBuffer()
//            }

            /**
             * RECORDING: If not coming from prerecording states, initialize the audio recorder and start
             * recording. Start chronometer. Write audio data to file.
             */
            AudioRecorderActivityState.RECORDING -> {
//                if (!isPrerecordingState(previousActivityState))
                initializeAndStartRecorder()
                _playbackProgressPbProgress.value = 0
                recordBuffers = arrayListOf()
                writeAudioDataToRecordBuffer()
            }

            /** RECORDED: Finish recording and finalize wav file. Switch to first play back */
            AudioRecorderActivityState.RECORDED -> {
//                finishRecordingAndFinalizeWavFile()
            }

            /**
             * FIRST_PLAYBACK: Start media player and play the scratch wav file If coming from paused
             * state, resume player
             */
            AudioRecorderActivityState.FIRST_PLAYBACK -> {
//                if (previousActivityState == AudioRecorderActivityState.RECORDED || previousActivityState == AudioRecorderActivityState.ACTIVITY_STOPPED
//                ) {
//                    initializePlayer()
//                    mediaPlayer!!.setOnCompletionListener {
//                        setActivityState(
//                            AudioRecorderActivityState.COMPLETED
//                        )
//                    }
//                    playFile(scratchRecordingFilePath)
//                } else if (previousActivityState == AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED) {
//                    mediaPlayer!!.start()
//                }
//                updatePlaybackProgress(AudioRecorderActivityState.FIRST_PLAYBACK)
            }

            /** FIRST_PLAYBACK_PAUSED: Pause media player */
            AudioRecorderActivityState.FIRST_PLAYBACK_PAUSED -> {
//                mediaPlayer!!.pause()
            }

            /** COMPLETED: release the media player */
            AudioRecorderActivityState.COMPLETED -> {
//                playbackProgressThread?.join()
//                setButtonStates(
//                    AudioRecorderButtonState.ENABLED,
//                    AudioRecorderButtonState.ENABLED,
//                    AudioRecorderButtonState.ENABLED,
//                    AudioRecorderButtonState.ENABLED
//                )
//                _playbackProgressPbProgress.value = 0
//                releasePlayer()
            }

            /**
             * NEW_PLAYING: if coming from paused state, start player. Else initialize and start the
             * player. Set the onCompletion listener to go back to the completed state
             */
            AudioRecorderActivityState.NEW_PLAYING -> {
//                if (previousActivityState == AudioRecorderActivityState.NEW_PAUSED) {
//                    mediaPlayer!!.start()
//                } else if (previousActivityState == AudioRecorderActivityState.COMPLETED) {
//                    initializePlayer()
//                    mediaPlayer!!.setOnCompletionListener {
//                        setButtonStates(
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED
//                        )
//                        setActivityState(AudioRecorderActivityState.COMPLETED)
//                    }
//                    playFile(scratchRecordingFilePath)
//                }
//                updatePlaybackProgress(AudioRecorderActivityState.NEW_PLAYING)
            }

            /** NEW_PAUSED: pause the player */
            AudioRecorderActivityState.NEW_PAUSED -> {
//                mediaPlayer!!.pause()
            }

            /**
             * OLD_PLAYING: if coming from paused state, start player. Else initialize and start the
             * player. Set the onCompletion listener to go back to the completed state. Play old output
             * file.
             */
            AudioRecorderActivityState.OLD_PLAYING -> {
//                if (previousActivityState == AudioRecorderActivityState.OLD_PAUSED) {
//                    mediaPlayer!!.start()
//                } else if (previousActivityState == AudioRecorderActivityState.COMPLETED_PRERECORDING) {
//                    initializePlayer()
//                    mediaPlayer!!.setOnCompletionListener {
//                        _playbackProgressPbProgress.value = _playbackProgressPbMax.value
//                        setButtonStates(
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED,
//                            AudioRecorderButtonState.ENABLED,
//                        )
//                        setActivityState(AudioRecorderActivityState.COMPLETED_PRERECORDING)
//                    }
//                    playFile(outputRecordingFilePath)
//                }
//                updatePlaybackProgress(AudioRecorderActivityState.OLD_PLAYING)
            }

            /** OLD_PAUSED: pause the player */
            AudioRecorderActivityState.OLD_PAUSED -> {
//                mediaPlayer!!.pause()
            }

            /**
             * SIMPLE_NEXT: If prerecording, then wait for prerecording job to finish. Then move to next
             * microtask
             */
            AudioRecorderActivityState.SIMPLE_NEXT -> {
//                runBlocking {
//                    if (isPrerecordingState(previousActivityState)) {
//                        preRecordingJob?.join()
//                    }
//                    moveToNextMicrotask()
//                    setActivityState(AudioRecorderActivityState.INIT)
//                }
            }

            /**
             * SIMPLE_BACK: If prerecording, then wait for prerecording job to finish. Then move to
             * previous microtask
             */
            AudioRecorderActivityState.SIMPLE_BACK -> {
//                runBlocking {
//                    if (isPrerecordingState(previousActivityState)) {
//                        preRecordingJob?.join()
//                    }
//                    moveToPreviousMicrotask()
//                    setActivityState(AudioRecorderActivityState.INIT)
//                }
            }

            /** ENCODING_NEXT: Encode scratch file to compressed output file. Move to next microtask. */
            AudioRecorderActivityState.ENCODING_NEXT -> {
//                runBlocking {
//                    encodingJob =
//                        viewModelScope.launch(Dispatchers.IO) {
//                            encodeRecording()
//                            completeAndSaveCurrentMicrotask()
//                        }
//                    encodingJob?.join()
//                    moveToNextMicrotask()
//                    setActivityState(AudioRecorderActivityState.INIT)
//                }
            }

            /**
             * ENCODING_BACK: Encode scratch file to compressed output file. Move to previous microtask.
             */
            AudioRecorderActivityState.ENCODING_BACK -> {
//                runBlocking {
//                    encodingJob =
//                        viewModelScope.launch(Dispatchers.IO) {
//                            encodeRecording()
//                            completeAndSaveCurrentMicrotask()
//                        }
//                    encodingJob?.join()
//                    moveToPreviousMicrotask()
//                    setActivityState(AudioRecorderActivityState.INIT)
//                }
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

    /** Release the media player and hide seek bar */
    private fun releasePlayer() {
        recodedAudioPlayer?.stop()
        recodedAudioPlayer?.reset()
        recodedAudioPlayer?.release()
        recodedAudioPlayer = null
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

}