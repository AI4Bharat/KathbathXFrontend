package com.ai4bharat.kathbath.ui.scenarios.speechImageData

import android.content.ContentValues.TAG
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaPlayer
import android.util.Log
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecordingState
import com.ai4bharat.kathbath.data.model.karya.enums.MicrotaskAssignmentStatus
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.media_handler.KathbathAudioRecorderHelper
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import com.ai4bharat.kathbath.ui.scenarios.speechData.SpeechDataMainViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.io.DataOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.RandomAccessFile
import java.util.Locale
import javax.inject.Inject

@HiltViewModel
class SpeechImageDataViewModel
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

    var audioRecorderHelper: KathbathAudioRecorderHelper = KathbathAudioRecorderHelper()
    var audioRecorder: AudioRecord = audioRecorderHelper.getAudioRecorder()
    var recordingJob: Job? = null
    var audioFlushJob: Job? = null
    var scratchRecordingFileInitJob: Job? = null
    lateinit var scratchRecordingFilePath: String
    var recordingStatus: MutableLiveData<AudioRecordingState> =
        MutableLiveData<AudioRecordingState>(AudioRecordingState.INITIALIZED)
    private var recordBuffers: ArrayList<ByteArray> = arrayListOf()
    private lateinit var scratchRecordingFile: DataOutputStream
    private var samplingRate: Int = 44100
    private var totalRecordedBytes = 0
    private val scratchRecordingFileParams = Pair("", "wav")
    var outputRecordingFileParams = Pair("", "wav")
    lateinit var outputRecordingFilePath: String
    var extempore: Boolean = false
    var preRecordBufferConsumed: Array<Int> = Array(2) { 0 }
    var recordedDuration: MutableLiveData<Int> = MutableLiveData<Int>(0)

    private fun setRecordingStatus(status: AudioRecordingState) {
        recordingStatus.value = status
    }

    fun startRecording() {
        println("THE $audioRecorder")
        if (recordingJob?.isActive == true) {
            recordingJob?.cancel()
            audioRecorder.stop()
            setRecordingStatus(AudioRecordingState.FINISHED)
//            resetWavFile()
//            resetRecordingLength()
            println("The buffer size is ${recordBuffers.get(0).size} ${recordBuffers.get(1).size} ${recordBuffers.size}")
//            recordBuffers = arrayListOf()
            return
        }

        setRecordingStatus(AudioRecordingState.RECORDING)
        audioRecorder.startRecording()
        recordingJob = viewModelScope.launch(Dispatchers.IO) {
            var data = ByteArray(audioRecorderHelper._recorderBufferSize)
            var currentRecordBufferConsumer = 0
            var remainingSpace = audioRecorderHelper._recorderBufferSize

            var readBytes = 0
            while (recordingStatus.value == AudioRecordingState.RECORDING || readBytes > 0) {
                try {
                    readBytes = audioRecorder.read(
                        data,
                        currentRecordBufferConsumer,
                        remainingSpace
                    )
                } catch (e: Exception) {
                    println("Exception ${e.toString()}")
                    break
                }

                if (readBytes > 0) {
                    currentRecordBufferConsumer += readBytes
                    remainingSpace -= readBytes
                    if (remainingSpace <= 0) {
                        recordBuffers.add(data)
                        data = ByteArray(audioRecorderHelper._recorderBufferSize)
                        currentRecordBufferConsumer = 0
                        remainingSpace = audioRecorderHelper._recorderBufferSize
                    }
                    totalRecordedBytes += readBytes
                    resetRecordingLength()
                }
            }
            recordBuffers.add(data)
        }
    }

    private fun resetWavFile() {
        val wavFileHandle = getAssignmentScratchFile(scratchRecordingFileParams)
        scratchRecordingFile = DataOutputStream(FileOutputStream(wavFileHandle))
        writeWavFileHeader()
    }

    fun finishAndSaveRecording() {

        runBlocking {
            audioFlushJob = CoroutineScope(Dispatchers.IO).launch {
                scratchRecordingFileInitJob!!.join()

                for (i in 0 until recordBuffers.lastIndex) {
                    println("The read bytes are $i")
                    scratchRecordingFile.write(
                        recordBuffers[i],
                        0,
                        audioRecorderHelper._recorderBufferSize
                    )
                    totalRecordedBytes += audioRecorderHelper._recorderBufferSize
                }

                scratchRecordingFile.close()
                val dataSize = totalRecordedBytes
                val scratchFile =
                    RandomAccessFile(scratchRecordingFilePath, "rw")
                writeIntAtLocation(scratchFile, dataSize + 36, 4)
                writeIntAtLocation(scratchFile, dataSize, 40)
                println("File path is $scratchRecordingFilePath ${scratchFile.length()}")
                scratchFile.close()
            }
        }
    }

    private fun playAudio(filePath: String) {
        val mediaPlayer = MediaPlayer()
        mediaPlayer.setDataSource(filePath)
        println("Media player Initialized $filePath")
        mediaPlayer.setOnPreparedListener {
            it.start()
            println("Media player started")
        }
        mediaPlayer.setOnCompletionListener {
            println("Media player stopped")
        }
    }

    private fun writeWavFileHeader() {
        val bitsPerSample = 16
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

    private fun writeShort(output: DataOutputStream, value: Short) {
        output.write(value.toInt() shr 0)
        output.write(value.toInt() shr 8)
    }

    private fun writeString(output: DataOutputStream, value: String) {
        for (element in value) {
            output.writeBytes(element.toString())
        }
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

    private fun writeInt(output: DataOutputStream, value: Int) {
        output.write(value shr 0)
        output.write(value shr 8)
        output.write(value shr 16)
        output.write(value shr 24)
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
//        _playbackProgressPbProgress.value = 0

        // Set microtask instruction
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

//        if (hints != null) {
//            val hintList = hints.toString().removeSurrounding("[", "]")
//                .takeIf(String::isNotEmpty)
//                ?.split(",")
//                ?: emptyList()
////      Log.e("HINTS",hintList.random())
//            if (hintList.size > 3) {
//                _sentenceTvText.value += " [Hint:" + hintList.shuffled()
//                    .joinToString(separator = ",", limit = 3) + "]"
//            } else {
//                _sentenceTvText.value += " [Hint:" + hintList.joinToString(separator = ",") + "]"
//            }
//        }

        totalRecordedBytes = 0

//        extempore = task.name.contains("Extempore Dialogue", true)
//        if (extempore) {
//            _recordBtnState.value = SpeechDataMainViewModel.ButtonState.ENABLED
//        }
        /** Get microtask config */
//        try {
//            allowSkipping = task.params.asJsonObject.get("allowSkipping").asBoolean
//        } catch (e: Exception) {
//            allowSkipping = false
//        }

//        if (firstTimeActivityVisit) {
//            firstTimeActivityVisit = false
//            onAssistantClick()
//        } else {
        moveToPrerecording()
//        }
    }

    fun moveToPrerecording() {
        preRecordBufferConsumed[0] = 0
        preRecordBufferConsumed[1] = 0

        if (currentAssignment.status != MicrotaskAssignmentStatus.COMPLETED) {
//            resetRecordingLength()
        } else {
//            setButtonStates(
//                SpeechDataMainViewModel.ButtonState.ENABLED,
//                SpeechDataMainViewModel.ButtonState.ENABLED,
//                SpeechDataMainViewModel.ButtonState.ENABLED,
//                SpeechDataMainViewModel.ButtonState.ENABLED
//            )

            val mPlayer = MediaPlayer()
            mPlayer.setDataSource(outputRecordingFilePath)
            mPlayer.prepare()
            resetRecordingLength(mPlayer.duration)
            mPlayer.release()
//            setActivityState(SpeechDataMainViewModel.ActivityState.COMPLETED_PRERECORDING)
        }
    }

    private fun resetRecordingLength(duration: Int? = null) {
        viewModelScope.launch {
            val milliseconds = duration ?: samplesToTime(totalRecordedBytes / 2)
            val centiSeconds = (milliseconds / 10) % 100
            val seconds = milliseconds / 1000
            recordedDuration.value = seconds
//            recordingLength = milliseconds.toFloat() / 1000
        }
    }

    private fun samplesToTime(samples: Int): Int {
        return ((samples.toFloat() / samplingRate) * 1000).toInt()
    }

}