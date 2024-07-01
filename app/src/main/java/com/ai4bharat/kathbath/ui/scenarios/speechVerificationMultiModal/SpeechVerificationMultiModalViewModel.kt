package com.ai4bharat.kathbath.ui.scenarios.speechVerificationMultiModal

import android.media.MediaPlayer
import android.util.Log
import androidx.annotation.StringRes
import androidx.fragment.app.Fragment
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.model.karya.enums.AudioRecorderButtonState
import com.ai4bharat.kathbath.data.model.karya.enums.AudioVerificationActivityState
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.data.repo.WorkerRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import com.google.gson.JsonObject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import org.json.JSONException
import java.util.Locale
import javax.inject.Inject

@HiltViewModel
class SpeechVerificationMultiModalViewModel
@Inject
constructor(
    assignmentRepository: AssignmentRepository,
    taskRepository: TaskRepository,
    microTaskRepository: MicroTaskRepository,
    @FilesDir fileDirPath: String,
    authManager: AuthManager
) : BaseMTRendererViewModel(
    assignmentRepository,
    taskRepository,
    microTaskRepository,
    fileDirPath,
    authManager
) {

    @Inject
    lateinit var workerRepository: WorkerRepository

    /** Media player */
    private var mediaPlayer: MediaPlayer? = null


    /** UI State */
    private var activityState: AudioVerificationActivityState = AudioVerificationActivityState.INIT
    private var previousActivityState: AudioVerificationActivityState =
        AudioVerificationActivityState.INIT
    private var playBtnState: AudioRecorderButtonState = AudioRecorderButtonState.DISABLED
    private var nextBtnState: AudioRecorderButtonState = AudioRecorderButtonState.DISABLED
    private var backBtnState: AudioRecorderButtonState = AudioRecorderButtonState.DISABLED

    /** Verification status */

    private var _decisionRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
    val decisionRating = _decisionRating.asStateFlow()
    private var _volumeTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _unclearAudioTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _noiseTickHandlerIntermittent: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _chatterTickHandlerIntermittent: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _noiseTickHandlerPersistent: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _chatterTickHandlerPersistent: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _notOnTopicTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _repContentTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _longPausesTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _misPronTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _readPromptTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _bookReadTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _sstTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _stretchingTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _badExtemporeTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _objContTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _skippingWordsTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _incorrectTextTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _factualInaccuracyTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _wrongLangTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _echoTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _wrongGenderTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _wrongAgeGroupTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _duplicateSpeakerTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

    private var _commentTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
    private var _commentTextHandler: MutableStateFlow<String> = MutableStateFlow("")
    val commentTickHandler = _commentTickHandler.asStateFlow()

    private var reviewCompleted = false

    private lateinit var playbackProgressThread: Thread

    // Defining Mutable State Flows

    // These are all the different inputs that are allowed
    private var _inputPrompt: MutableStateFlow<MutableMap<String, String>> =
        MutableStateFlow(
            mutableMapOf(
                "audio_prompt" to "",
                "audio_response" to "",
                "image" to "",
                "sentence" to ""
            )
        )
    val inputPrompt = _inputPrompt.asStateFlow()

    private val _sentenceTvText: MutableStateFlow<String> = MutableStateFlow("")
    val sentenceTvText = _sentenceTvText.asStateFlow()

    private val _microtaskID: MutableStateFlow<String> = MutableStateFlow("")
    val microtaskID = _microtaskID.asStateFlow()

    private val _fileID: MutableStateFlow<String> = MutableStateFlow("")
    val fileID = _fileID.asStateFlow()

    private val _phoneNumber: MutableStateFlow<String> = MutableStateFlow("")
    val phoneNumber = _phoneNumber.asStateFlow()

    private val _fileGender: MutableStateFlow<String> = MutableStateFlow("")
    val fileGender = _fileGender.asStateFlow()

    private val _fileAgeGroup: MutableStateFlow<String> = MutableStateFlow("")
    val fileAgeGroup = _fileAgeGroup.asStateFlow()

    private val _playbackSecondsTvText: MutableStateFlow<String> = MutableStateFlow("")
    val playbackSecondsTvText = _playbackSecondsTvText.asStateFlow()

    private val _playbackCentiSecondsTvText: MutableStateFlow<String> = MutableStateFlow("")
    val playbackCentiSecondsTvText = _playbackCentiSecondsTvText.asStateFlow()

    private val _playbackProgressPbMax: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgressPbMax = _playbackProgressPbMax.asStateFlow()

    private val _playbackProgress: MutableStateFlow<Int> = MutableStateFlow(0)
    val playbackProgress = _playbackProgress.asStateFlow()

    private val _navAndMediaBtnGroup: MutableStateFlow<Triple<AudioRecorderButtonState, AudioRecorderButtonState, AudioRecorderButtonState>> =
        MutableStateFlow(
            Triple(
                AudioRecorderButtonState.DISABLED,
                AudioRecorderButtonState.DISABLED,
                AudioRecorderButtonState.DISABLED
            )
        )

    // Button State Order: PlayButton, NextButton, BackButton
    val navAndMediaBtnGroup = _navAndMediaBtnGroup.asStateFlow()

    private val _reviewEnabled: MutableStateFlow<Boolean> = MutableStateFlow(false)
    val reviewEnabled = _reviewEnabled.asStateFlow()

    private val _showErrorWithDialog: MutableStateFlow<String> = MutableStateFlow("")
    val showErrorWithDialog = _showErrorWithDialog.asStateFlow()


    override fun setupMicrotask() {

        println("SVMM setup microtask called ")

        _decisionRating.value = R.string.rating_undefined
        _volumeTickHandler.value = false
        _noiseTickHandlerIntermittent.value = false
        _chatterTickHandlerIntermittent.value = false
        _noiseTickHandlerPersistent.value = false
        _chatterTickHandlerPersistent.value = false
        _unclearAudioTickHandler.value = false

        _notOnTopicTickHandler.value = false
        _repContentTickHandler.value = false
        _longPausesTickHandler.value = false

        _misPronTickHandler.value = false

        _readPromptTickHandler.value = false
        _bookReadTickHandler.value = false

        _sstTickHandler.value = false
        _stretchingTickHandler.value = false

        _commentTickHandler.value = false
        _commentTextHandler.value = ""
        _badExtemporeTickHandler.value = false

        _objContTickHandler.value = false
        _incorrectTextTickHandler.value = false
        _factualInaccuracyTickHandler.value = false
        _skippingWordsTickHandler.value = false


        _wrongLangTickHandler.value = false
        _echoTickHandler.value = false

        _wrongGenderTickHandler.value = false
        _wrongAgeGroupTickHandler.value = false
        _duplicateSpeakerTickHandler.value = false


        _reviewEnabled.value = false
        reviewCompleted = false

//        val sentence =
//            currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()
//        _sentenceTvText.value = sentence
        println("SVMM setup microtask called ${currentMicroTask.input}")
        val recordingFileName =
            currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("recording").asString
        val recordingFile =
            microtaskInputContainer.getMicrotaskInputFilePath(
                currentMicroTask.id,
                recordingFileName
            )
        _microtaskID.value = currentMicroTask.id

        _fileID.value = _microtaskID.value

//        if (!task.name.contains("conversation", true)) {
//            val wid = currentMicroTask.input.asJsonObject.getAsJsonObject("chain").get("workerId")
//                .toString().trim('"')
//            viewModelScope.launch {
//                val localWorker = workerRepository.getWorkerById(wid)
//                if (localWorker == null) {
//                    workerRepository.getWorkerFromBox(wid)
//                        .catch { throwable -> Log.e("TRYING TO FETCH", throwable.toString()) }
//                        .collect { worker ->
//                            workerRepository.upsertWorker(worker)
//                            _fileGender.value =
//                                worker.profile?.asJsonObject?.get("gender").toString().trim('"')
//                            _phoneNumber.value =
//                                worker.profile?.asJsonObject?.get("phone").toString().trim('"')
//                            _fileAgeGroup.value =
//                                age2group(worker.profile?.asJsonObject?.get("age")!!.asInt)
//                        }
//                } else {
//                    _fileGender.value =
//                        localWorker.profile?.asJsonObject?.get("gender").toString().trim('"')
//                    _phoneNumber.value =
//                        localWorker.profile?.asJsonObject?.get("phone").toString().trim('"')
//                    _fileAgeGroup.value =
//                        age2group(localWorker.profile?.asJsonObject?.get("age")!!.asInt)
//                }
//            }
//        } else {
//            val wid1 = currentMicroTask.input.asJsonObject.getAsJsonObject("chain")
//                .get("workerAccessCode1").toString().trim('"')
//            val wid2 = currentMicroTask.input.asJsonObject.getAsJsonObject("chain")
//                .get("workerAccessCode2").toString().trim('"')
//
//            viewModelScope.launch {
//                val localWorker1 = workerRepository.getWorkerByAccessCode(wid1)
//                val localWorker2 = workerRepository.getWorkerByAccessCode(wid2)
//                if (localWorker1 != null) {
//                    _fileGender.value =
//                        localWorker1.profile?.asJsonObject?.get("gender").toString().trim('"')
//                    _phoneNumber.value =
//                        localWorker1.profile?.asJsonObject?.get("phone").toString().trim('"')
//                    _fileAgeGroup.value =
//                        age2group(localWorker1.profile?.asJsonObject?.get("age")!!.asInt)
//                } else {
//                    workerRepository.getWorkerFromBox(wid1)
//                        .catch { throwable -> Log.e("TRYING TO FETCH", throwable.toString()) }
//                        .collect { worker ->
//                            workerRepository.upsertWorker(worker)
//                            _fileGender.value =
//                                worker.profile?.asJsonObject?.get("gender").toString().trim('"')
//                            _phoneNumber.value =
//                                worker.profile?.asJsonObject?.get("phone").toString().trim('"')
//                            _fileAgeGroup.value =
//                                age2group(worker.profile?.asJsonObject?.get("age")!!.asInt)
//                        }
//                }
//                if (localWorker2 != null) {
//                    _fileGender.value += ", " + localWorker2.profile?.asJsonObject?.get("gender")
//                        .toString().trim('"')
//                    _phoneNumber.value += ", " + localWorker2.profile?.asJsonObject?.get("phone")
//                        .toString().trim('"')
//                    _fileAgeGroup.value += ", " + age2group(
//                        localWorker2.profile?.asJsonObject?.get(
//                            "age"
//                        )!!.asInt
//                    )
//                } else {
//                    workerRepository.getWorkerFromBox(wid2)
//                        .catch { throwable -> Log.e("TRYING TO FETCH", throwable.toString()) }
//                        .collect { worker ->
//                            workerRepository.upsertWorker(worker)
//                            _fileGender.value += ", " + worker.profile?.asJsonObject?.get("gender")
//                                .toString().trim('"')
//                            _phoneNumber.value += ", " + worker.profile?.asJsonObject?.get("phone")
//                                .toString().trim('"')
//                            _fileAgeGroup.value += ", " + age2group(
//                                worker.profile?.asJsonObject?.get(
//                                    "age"
//                                )!!.asInt
//                            )
//                        }
//                }
//            }
//        }


        /** setup media player */
        mediaPlayer = MediaPlayer()
        mediaPlayer!!.setOnCompletionListener {
            setActivityState(AudioVerificationActivityState.REVIEW_ENABLED)
        }
        mediaPlayer!!.setDataSource(recordingFile)

        try {
            mediaPlayer!!.prepare()
            resetRecordingLength(mediaPlayer!!.duration)
            _playbackProgressPbMax.value = mediaPlayer!!.duration
            _playbackProgress.value = 0

            setActivityState(AudioVerificationActivityState.WAIT_FOR_PLAY)
        } catch (exception: Exception) {
            // Alert dialog
            showErrorWithDialogBox("Audio file is corrupt")
        }

        setupInputPrompts()
    }

    private fun setupInputPrompts() {

        var inputAudioPromptFile = ""
        var inputImageFile = ""
        var inputAudioResponseFile = ""
        var sentence = ""

        inputAudioPromptFile = try {
            val inputAudioPromptFileName =
                currentMicroTask.input.asJsonObject.getAsJsonObject("files")
                    .get("audio_prompt").asString
            microtaskInputContainer.getMicrotaskInputFilePath(
                currentMicroTask.id,
                inputAudioPromptFileName
            )

        } catch (exception: Exception) {
            ""
        }

        inputAudioResponseFile = try {
            val inputAudioResponseFileName =
                currentMicroTask.input.asJsonObject.getAsJsonObject("files")
                    .get("audio_response").asString
            microtaskInputContainer.getMicrotaskInputFilePath(
                currentMicroTask.id,
                inputAudioResponseFileName
            )
        } catch (exception: Exception) {
            ""
        }

        inputImageFile = try {
            val inputImageFileName =
                currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("image").asString
            microtaskInputContainer.getMicrotaskInputFilePath(
                currentMicroTask.id,
                inputImageFileName
            )
        } catch (exception: Exception) {
            ""
        }

        sentence = try {
            currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()
        } catch (exception: Exception) {
            ""
        }

        _inputPrompt.value = mutableMapOf(
            "audio_prompt" to inputAudioPromptFile, "audio_response" to inputAudioResponseFile,
            "sentence" to sentence, "image" to inputImageFile
        )
        println("NEW ASSIG ${_inputPrompt.value}")

    }

    private fun age2group(age: Int): String {
        return if (age >= 60) {
            "60+"
        } else if (age in 45..59) {
            "45-60"
        } else if (age in 30..44) {
            "30-45"
        } else if (age in 18..29) {
            "18-30"
        } else {
            "Minor!"
        }

    }

    private fun showErrorWithDialogBox(msg: String) {
        _showErrorWithDialog.value = msg
    }

    /** Set activity state */
    private fun setActivityState(targetState: AudioVerificationActivityState) {
        /** Log the state transition */
        val message = JsonObject()
        message.addProperty("type", "->")
        message.addProperty("from", activityState.toString())
        message.addProperty("to", targetState.toString())
        log(message)

        /** Switch state */
        previousActivityState = activityState
        activityState = targetState

        when (activityState) {
            /** INIT: may not be necessary */
            AudioVerificationActivityState.INIT -> {
                setupMicrotask()
            }

            /** Wait for the play button to be clicked */
            AudioVerificationActivityState.WAIT_FOR_PLAY -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.DISABLED
                )
            }

            /** Start the first play back */
            AudioVerificationActivityState.FIRST_PLAYBACK -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    AudioRecorderButtonState.DISABLED
                )
                mediaPlayer!!.start()
                updatePlaybackProgress(AudioVerificationActivityState.FIRST_PLAYBACK)
            }

            /** Pause first play back */
            AudioVerificationActivityState.FIRST_PLAYBACK_PAUSED -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.DISABLED
                )
                mediaPlayer!!.pause()
            }

            /** Enable the review stage */
            AudioVerificationActivityState.REVIEW_ENABLED -> {
                playbackProgressThread.join()
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    nextBtnState
                )
                _playbackProgress
                _reviewEnabled.value = true
            }

            /** Subsequent play back */
            AudioVerificationActivityState.PLAYBACK -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ACTIVE,
                    nextBtnState
                )
                mediaPlayer!!.start()
                updatePlaybackProgress(AudioVerificationActivityState.PLAYBACK)
            }

            /** Pause subsequent play back */
            AudioVerificationActivityState.PLAYBACK_PAUSED -> {
                setButtonStates(
                    AudioRecorderButtonState.ENABLED,
                    AudioRecorderButtonState.ENABLED,
                    nextBtnState
                )
                mediaPlayer!!.pause()
            }

            /** Activity stopped */
            AudioVerificationActivityState.ACTIVITY_STOPPED -> {
            }
        }
    }

    /** Handle play button click */
    internal fun handlePlayClick() {
        /** Log the click */
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "PLAY")
        message.addProperty("state", playBtnState.toString())
        log(message)

        when (activityState) {
            AudioVerificationActivityState.WAIT_FOR_PLAY -> {
                setActivityState(AudioVerificationActivityState.FIRST_PLAYBACK)
            }

            AudioVerificationActivityState.FIRST_PLAYBACK -> {
                setActivityState(AudioVerificationActivityState.FIRST_PLAYBACK_PAUSED)
            }

            AudioVerificationActivityState.FIRST_PLAYBACK_PAUSED -> {
                setActivityState(AudioVerificationActivityState.FIRST_PLAYBACK)
            }

            AudioVerificationActivityState.REVIEW_ENABLED -> {
                setActivityState(AudioVerificationActivityState.PLAYBACK)
            }

            AudioVerificationActivityState.PLAYBACK -> {
                setActivityState(AudioVerificationActivityState.PLAYBACK_PAUSED)
            }

            AudioVerificationActivityState.PLAYBACK_PAUSED -> {
                setActivityState(AudioVerificationActivityState.PLAYBACK)
            }

            AudioVerificationActivityState.INIT, AudioVerificationActivityState.ACTIVITY_STOPPED -> {
            }
        }
    }

    /** Handle next button click */
    internal fun handleNextClick() {
        /** Log button press */
        val message = JsonObject()
        message.addProperty("type", "o")
        message.addProperty("button", "NEXT")
        log(message)


        /** Disable all buttons */
        setButtonStates(
            AudioRecorderButtonState.DISABLED,
            AudioRecorderButtonState.DISABLED,
            AudioRecorderButtonState.DISABLED
        )


        if (activityState == AudioVerificationActivityState.PLAYBACK) {
            mediaPlayer!!.stop()
        }
        mediaPlayer?.release()
        mediaPlayer = null

        val decision =
            when (_decisionRating.value) {
                R.string.decision_okay -> "accept"
                R.string.decision_excellent -> "excellent"
                else -> "reject"
            }

        var low_vol = _volumeTickHandler.value
        var noiseIntermittent = _noiseTickHandlerIntermittent.value
        var chatterIntermittent = _chatterTickHandlerIntermittent.value
        var noisePersistent = _noiseTickHandlerPersistent.value
        var chatterPersistent = _chatterTickHandlerPersistent.value
        var unclearAudio = _unclearAudioTickHandler.value
        var notOnTopic = _notOnTopicTickHandler.value
        var repContent = _repContentTickHandler.value
        var longPause = _longPausesTickHandler.value
        var mispron = _misPronTickHandler.value
        var readPrompt = _readPromptTickHandler.value
        var bookRead = _bookReadTickHandler.value
        var sst = _sstTickHandler.value
        var stretching = _stretchingTickHandler.value
        var bad_extempore_quality = _badExtemporeTickHandler.value
        var comments = _commentTextHandler.value
        var objectionable_content = _objContTickHandler.value
        var incorrect_text_prompt = _incorrectTextTickHandler.value
        var factual_inaccuracy = _factualInaccuracyTickHandler.value
        var skipping_words = _skippingWordsTickHandler.value
        var wrong_language = _wrongLangTickHandler.value
        var echo_present = _echoTickHandler.value
        var wrong_gender = _wrongGenderTickHandler.value
        var wrong_age_group = _wrongAgeGroupTickHandler.value
        var duplicate_speaker = _duplicateSpeakerTickHandler.value


        if (decision == "excellent") {
            low_vol = false
//      noise = false
//      chatter = false
            noiseIntermittent = false
            chatterIntermittent = false
            noisePersistent = false
            chatterPersistent = false
            unclearAudio = false
            notOnTopic = false
            repContent = false
            longPause = false
            mispron = false
            readPrompt = false
            bookRead = false
            sst = false
            stretching = false
//      misc = false
            objectionable_content = false
            incorrect_text_prompt = false
            factual_inaccuracy = false
            skipping_words = false
            wrong_language = false
            echo_present = false
            wrong_gender = false
            wrong_age_group = false
            duplicate_speaker = false
            bad_extempore_quality = false
//      bad_read_quality = false
            comments = "excellent"
        }

        outputData.addProperty("decision", decision)
        outputData.addProperty("low_volume", low_vol)
        outputData.addProperty("noise_intermittent", noiseIntermittent)
        outputData.addProperty("chatter_intermittent", chatterIntermittent)
        outputData.addProperty("noise_persistent", noisePersistent)
        outputData.addProperty("chatter_persistent", chatterPersistent)
        outputData.addProperty("unclear_audio", unclearAudio)
        outputData.addProperty("off_topic", notOnTopic)
        outputData.addProperty("repeating_content", repContent)
        outputData.addProperty("long_pauses", longPause)
        outputData.addProperty("mispronunciation", mispron)
        outputData.addProperty("reading_prompt", readPrompt)
        outputData.addProperty("book_read", bookRead)
        outputData.addProperty("sst", sst)
        outputData.addProperty("stretching", stretching)
        outputData.addProperty("bad_extempore_quality", bad_extempore_quality)
        outputData.addProperty("comments", comments)
        outputData.addProperty("objectionable_content", objectionable_content)
        outputData.addProperty("skipping_words", skipping_words)
        outputData.addProperty("incorrect_text_prompt", incorrect_text_prompt)
        outputData.addProperty("factual_inaccuracy", factual_inaccuracy)
        outputData.addProperty("wrong_language", wrong_language)
        outputData.addProperty("echo_present", echo_present)
        outputData.addProperty("wrong_gender", wrong_gender)
        outputData.addProperty("wrong_age_group", wrong_age_group)
        outputData.addProperty("duplicate_speaker", duplicate_speaker)
        viewModelScope.launch {
            completeAndSaveCurrentMicrotask()
            setActivityState(AudioVerificationActivityState.INIT)
            moveToNextMicrotask()
        }
    }

    /** Set button states */
    private fun setButtonStates(
        backState: AudioRecorderButtonState,
        playState: AudioRecorderButtonState,
        nextState: AudioRecorderButtonState,
    ) {
        _navAndMediaBtnGroup.value = Triple(backState, playState, nextState)
    }


    /** Handle volume change */

    fun handleDecisionChange(@StringRes decision: Int) {
        _decisionRating.value = decision
        updateReviewStatus()
    }

    fun handleVolumeTickChange(@StringRes value: Boolean) {
        _volumeTickHandler.value = value
        updateReviewStatus()
    }

    fun handleEchoTickChange(@StringRes value: Boolean) {
        _echoTickHandler.value = value
        updateReviewStatus()
    }

    fun handleWrongLangTickChange(@StringRes value: Boolean) {
        _wrongLangTickHandler.value = value
        updateReviewStatus()
    }

    fun handleWrongGenderTickChange(@StringRes value: Boolean) {
        _wrongGenderTickHandler.value = value
        updateReviewStatus()
    }

    fun handleWrongAgeGroupTickChange(@StringRes value: Boolean) {
        _wrongAgeGroupTickHandler.value = value
        updateReviewStatus()
    }

    fun handleDuplicateSpeakerTickChange(@StringRes value: Boolean) {
        _duplicateSpeakerTickHandler.value = value
        updateReviewStatus()
    }

    fun handleNoiseTickIntermittentChange(@StringRes value: Boolean) {
        _noiseTickHandlerIntermittent.value = value
        updateReviewStatus()
    }

    fun handleChatterTickIntermittentChange(@StringRes value: Boolean) {
        _chatterTickHandlerIntermittent.value = value
        updateReviewStatus()
    }

    fun handleNoiseTickPersistentChange(@StringRes value: Boolean) {
        _noiseTickHandlerPersistent.value = value
        updateReviewStatus()
    }

    fun handleChatterTickPersistentChange(@StringRes value: Boolean) {
        _chatterTickHandlerPersistent.value = value
        updateReviewStatus()
    }

    fun handleUnclearAudioTickChange(@StringRes value: Boolean) {
        _unclearAudioTickHandler.value = value
        updateReviewStatus()
    }

    fun handleNotOnTopicTickChange(@StringRes value: Boolean) {
        _notOnTopicTickHandler.value = value
        updateReviewStatus()
    }

    fun handleRepContentTickChange(@StringRes value: Boolean) {
        _repContentTickHandler.value = value
        updateReviewStatus()
    }

    fun handleLongPausesTickChange(@StringRes value: Boolean) {
        _longPausesTickHandler.value = value
        updateReviewStatus()
    }

    fun handleMisPronTickChange(@StringRes value: Boolean) {
        _misPronTickHandler.value = value
        updateReviewStatus()
    }

    fun handleReadPromptTickChange(@StringRes value: Boolean) {
        _readPromptTickHandler.value = value
        updateReviewStatus()
    }

    fun handleBookReadTickChange(@StringRes value: Boolean) {
        _bookReadTickHandler.value = value
        updateReviewStatus()
    }


    fun handleSSTTickChange(@StringRes value: Boolean) {
        _sstTickHandler.value = value
        updateReviewStatus()
    }

    fun handleStretchingTickChange(@StringRes value: Boolean) {
        _stretchingTickHandler.value = value
        updateReviewStatus()
    }

    fun handleObjContTickChange(@StringRes value: Boolean) {
        _objContTickHandler.value = value
        updateReviewStatus()
    }

    fun handleSkippingWordsTickChange(@StringRes value: Boolean) {
        _skippingWordsTickHandler.value = value
        updateReviewStatus()
    }

    fun handleIncorrectTextTickChange(@StringRes value: Boolean) {
        _incorrectTextTickHandler.value = value
        updateReviewStatus()
    }

    fun handleFactualInaccuracyTick(@StringRes value: Boolean) {
        _factualInaccuracyTickHandler.value = value
        updateReviewStatus()
    }

    fun handleBadExtemporeTickChange(@StringRes value: Boolean) {
        _badExtemporeTickHandler.value = value
        updateReviewStatus()
    }

    fun handleCommentsTickChange(@StringRes value: Boolean) {
        _commentTickHandler.value = value
        updateReviewStatus()
    }

    fun handleCommentTextChange(@StringRes value: String) {
        _commentTextHandler.value = value
        updateReviewStatus()
    }

    private fun updateReviewStatus() {
//    val baseCase = (_volumeTickHandler.value || _noiseTickHandler.value || _chatterTickHandler.value || _unclearAudioTickHandler.value || _notOnTopicTickHandler.value || _repContentTickHandler.value || _longPausesTickHandler.value || _misPronTickHandler.value || _readPromptTickHandler.value || _bookReadTickHandler.value || _sstTickHandler.value || _stretchingTickHandler.value || _badExtemporeTickHandler.value )
        val baseCase =
            (_duplicateSpeakerTickHandler.value || _wrongAgeGroupTickHandler.value || _wrongGenderTickHandler.value || _echoTickHandler.value || _wrongLangTickHandler.value || _objContTickHandler.value || _skippingWordsTickHandler.value || _factualInaccuracyTickHandler.value || _incorrectTextTickHandler.value || _volumeTickHandler.value ||
                    _noiseTickHandlerIntermittent.value || _noiseTickHandlerPersistent.value ||
                    _chatterTickHandlerIntermittent.value || _chatterTickHandlerPersistent.value ||
                    _unclearAudioTickHandler.value || _notOnTopicTickHandler.value ||
                    _repContentTickHandler.value ||
                    _longPausesTickHandler.value ||
                    _misPronTickHandler.value || _readPromptTickHandler.value ||
                    _bookReadTickHandler.value || _sstTickHandler.value ||
                    _stretchingTickHandler.value || _badExtemporeTickHandler.value) &&
                    !(_chatterTickHandlerIntermittent.value && _chatterTickHandlerPersistent.value) &&
                    !(_noiseTickHandlerIntermittent.value && _noiseTickHandlerPersistent.value)

        reviewCompleted = (_decisionRating.value == R.string.decision_excellent)
                ||
                (_decisionRating.value != R.string.rating_undefined && baseCase || (_commentTickHandler.value && _commentTextHandler.value != "")) && baseCase

        if (reviewCompleted) {
            setButtonStates(
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.ENABLED
            )
            nextBtnState = AudioRecorderButtonState.ENABLED
        } else {
            setButtonStates(
                AudioRecorderButtonState.DISABLED,
                AudioRecorderButtonState.ENABLED,
                AudioRecorderButtonState.DISABLED
            )
            nextBtnState = AudioRecorderButtonState.DISABLED

        }
    }

    /** Update the progress bar for the player as long as the activity is in the specific state. */
    private fun updatePlaybackProgress(state: AudioVerificationActivityState) {
        val runnable = Runnable {
            while (state == activityState) {
                val currentPosition =
                    try {
                        mediaPlayer?.currentPosition
                    } catch (e: Exception) {
                        null
                    }
                _playbackProgress.value = currentPosition ?: _playbackProgress.value
                Thread.sleep(100)
            }
        }
        playbackProgressThread = Thread(runnable)
        playbackProgressThread.start()
    }

    /** Reset recording length */
    private fun resetRecordingLength(duration: Int) {
        viewModelScope.launch {
            val centiSeconds = (duration / 10) % 100
            val seconds = duration / 1000
            _playbackSecondsTvText.value = seconds.toString()
            _playbackCentiSecondsTvText.value = "%02d".format(Locale.ENGLISH, centiSeconds)
        }
    }

    // Handle the corrupt Audio Case
    fun handleCorruptAudio() {
        _objContTickHandler.value = true
        _skippingWordsTickHandler.value = true
        _factualInaccuracyTickHandler.value = true
        _incorrectTextTickHandler.value = true
        _decisionRating.value = R.string.decision_bad
        _volumeTickHandler.value = true
        _noiseTickHandlerIntermittent.value = true
        _chatterTickHandlerIntermittent.value = true
        _noiseTickHandlerPersistent.value = true
        _chatterTickHandlerPersistent.value = true
        _unclearAudioTickHandler.value = true
        _notOnTopicTickHandler.value = true
        _repContentTickHandler.value = true
        _longPausesTickHandler.value = true
        _misPronTickHandler.value = true
        _readPromptTickHandler.value = true
        _bookReadTickHandler.value = true
        _sstTickHandler.value = true
        _stretchingTickHandler.value = true
        _badExtemporeTickHandler.value = true
        _commentTickHandler.value = true
        _commentTextHandler.value = "corrupt"
        _wrongLangTickHandler.value = true
        _echoTickHandler.value = true
        _wrongGenderTickHandler.value = true
        _wrongAgeGroupTickHandler.value = true
        _duplicateSpeakerTickHandler.value = true
        outputData.addProperty("flag", "corrupt")

        // Move to next task
        handleNextClick()
    }

    fun handleSeekBarChange(int: Int, boolean: Boolean) {
        if (boolean) {
            mediaPlayer!!.pause()
            Thread.sleep(100)
            mediaPlayer!!.seekTo(int)
            Thread.sleep(100)
            setActivityState(AudioVerificationActivityState.PLAYBACK)
        }
    }

    fun onBackPressed() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        setActivityState(AudioVerificationActivityState.ACTIVITY_STOPPED)
        navigateBack()

    }


}

