package com.ai4bharat.karyatts.ui.scenarios.speechVerification

import android.media.MediaPlayer
import androidx.annotation.StringRes
import androidx.lifecycle.viewModelScope
import com.google.gson.JsonObject
import com.ai4bharat.karyatts.R
import com.ai4bharat.karyatts.data.manager.AuthManager
import com.ai4bharat.karyatts.data.repo.AssignmentRepository
import com.ai4bharat.karyatts.data.repo.MicroTaskRepository
import com.ai4bharat.karyatts.data.repo.TaskRepository
import com.ai4bharat.karyatts.injection.qualifier.FilesDir
import com.ai4bharat.karyatts.ui.scenarios.common.BaseMTRendererViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject

@HiltViewModel
class SpeechVerificationViewModel
@Inject
constructor(
  assignmentRepository: AssignmentRepository,
  taskRepository: TaskRepository,
  microTaskRepository: MicroTaskRepository,
  @FilesDir fileDirPath: String,
  authManager: AuthManager,
) : BaseMTRendererViewModel(
  assignmentRepository,
  taskRepository,
  microTaskRepository,
  fileDirPath,
  authManager
) {

  /** UI button states */
  enum class ButtonState {
    DISABLED,
    ENABLED,
    ACTIVE
  }

  /** Activity states */
  private enum class ActivityState {
    INIT,
    WAIT_FOR_PLAY,
    FIRST_PLAYBACK,
    FIRST_PLAYBACK_PAUSED,
    REVIEW_ENABLED,
    PLAYBACK,
    PLAYBACK_PAUSED,
    ACTIVITY_STOPPED
  }

  /** Media player */
  private var mediaPlayer: MediaPlayer? = null

  /** UI State */
  private var activityState: ActivityState = ActivityState.INIT
  private var previousActivityState: ActivityState = ActivityState.INIT
  private var playBtnState: ButtonState = ButtonState.DISABLED
  private var nextBtnState: ButtonState = ButtonState.DISABLED
  private var backBtnState: ButtonState = ButtonState.DISABLED

  private var _decisionRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val decisionRating = _decisionRating.asStateFlow()
  // Handlers
  private var _volumeTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _noiseTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _chatterTickHandlerIntermittent: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _fanTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _silenceTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _pageFlipTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _objContTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _skippingWordsTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _incorrectTextTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _incorrectStyleTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _unnaturalTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _repContentTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _tooSlowTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _tooFastTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _misPronTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _wrongSpeakerTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _weakEmotionTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _othersTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _dramaticTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _otherTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _wrongLangTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _echoTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _commentTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _commentTextHandler: MutableStateFlow<String> = MutableStateFlow("")
  val commentTickHandler = _commentTickHandler.asStateFlow()

  private var reviewCompleted = false
  private lateinit var playbackProgressThread: Thread

  // Defining Mutable State Flows
  private val _sentenceTvText: MutableStateFlow<String> = MutableStateFlow("")
  val sentenceTvText = _sentenceTvText.asStateFlow()

  private val _microtaskID: MutableStateFlow<String> = MutableStateFlow("")
  val microtaskID = _microtaskID.asStateFlow()

  private val _playbackSecondsTvText: MutableStateFlow<String> = MutableStateFlow("")
  val playbackSecondsTvText = _playbackSecondsTvText.asStateFlow()

  private val _playbackCentiSecondsTvText: MutableStateFlow<String> = MutableStateFlow("")
  val playbackCentiSecondsTvText = _playbackCentiSecondsTvText.asStateFlow()

  private val _playbackProgressPbMax: MutableStateFlow<Int> = MutableStateFlow(0)
  val playbackProgressPbMax = _playbackProgressPbMax.asStateFlow()

  private val _playbackProgress: MutableStateFlow<Int> = MutableStateFlow(0)
  val playbackProgress = _playbackProgress.asStateFlow()

  private val _navAndMediaBtnGroup: MutableStateFlow<Triple<ButtonState, ButtonState, ButtonState>> =
    MutableStateFlow(Triple(ButtonState.DISABLED, ButtonState.DISABLED, ButtonState.DISABLED))

  val navAndMediaBtnGroup = _navAndMediaBtnGroup.asStateFlow()

  private val _reviewEnabled: MutableStateFlow<Boolean> = MutableStateFlow(false)
  val reviewEnabled = _reviewEnabled.asStateFlow()

  private val _showErrorWithDialog: MutableStateFlow<String> = MutableStateFlow("")
  val showErrorWithDialog = _showErrorWithDialog.asStateFlow()

  override fun setupMicrotask() {
    _decisionRating.value = R.string.rating_undefined
    _volumeTickHandler.value = false
    _noiseTickHandler.value = false
    _chatterTickHandlerIntermittent.value = false
    _fanTickHandler.value = false
    _silenceTickHandler.value = false
    _pageFlipTickHandler.value = false
    _objContTickHandler.value = false
    _repContentTickHandler.value = false
    _skippingWordsTickHandler.value = false
    _incorrectTextTickHandler.value = false
    _incorrectStyleTickHandler.value = false
    _unnaturalTickHandler.value = false
    _repContentTickHandler.value = false
    _tooSlowTickHandler.value = false
    _tooFastTickHandler.value = false
    _misPronTickHandler.value = false
    _wrongSpeakerTickHandler.value = false
    _weakEmotionTickHandler.value = false
    _wrongLangTickHandler.value = false
    _otherTickHandler.value = false
    _othersTickHandler.value = false
    _commentTickHandler.value = false
    _commentTextHandler.value = ""
    _dramaticTickHandler.value = false
    _echoTickHandler.value = false
    _reviewEnabled.value = false
    reviewCompleted = false

    val sentence =
      currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()
    val recordingFileName =
      currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("recording").asString
    val recordingFile =
      microtaskInputContainer.getMicrotaskInputFilePath(currentMicroTask.id, recordingFileName)
    _microtaskID.value = currentMicroTask.id
    _sentenceTvText.value = sentence

    /** setup media player */
    mediaPlayer = MediaPlayer()
    mediaPlayer!!.setOnCompletionListener { setActivityState(ActivityState.REVIEW_ENABLED) }
    mediaPlayer!!.setDataSource(recordingFile)

    try {
      mediaPlayer!!.prepare()
      resetRecordingLength(mediaPlayer!!.duration)
      _playbackProgressPbMax.value = mediaPlayer!!.duration
      _playbackProgress.value = 0

      setActivityState(ActivityState.WAIT_FOR_PLAY)
    } catch (exception: Exception) {
      // Alert dialog
      showErrorWithDialogBox("Audio file is corrupt")
    }
  }

  private fun showErrorWithDialogBox(msg: String) {
    _showErrorWithDialog.value = msg
  }

  /** Set activity state */
  private fun setActivityState(targetState: ActivityState) {
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
      ActivityState.INIT -> {
        setupMicrotask()
      }

      /** Wait for the play button to be clicked */
      ActivityState.WAIT_FOR_PLAY -> {
        setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, ButtonState.DISABLED)
      }

      /** Start the first play back */
      ActivityState.FIRST_PLAYBACK -> {
        setButtonStates(ButtonState.ENABLED, ButtonState.ACTIVE, ButtonState.DISABLED)
        mediaPlayer!!.start()
        updatePlaybackProgress(ActivityState.FIRST_PLAYBACK)
      }

      /** Pause first play back */
      ActivityState.FIRST_PLAYBACK_PAUSED -> {
        setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, ButtonState.DISABLED)
        mediaPlayer!!.pause()
      }

      /** Enable the review stage */
      ActivityState.REVIEW_ENABLED -> {
        playbackProgressThread.join()
        setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, nextBtnState)
        _reviewEnabled.value = true
      }

      /** Subsequent play back */
      ActivityState.PLAYBACK -> {
        setButtonStates(ButtonState.ENABLED, ButtonState.ACTIVE, nextBtnState)
        mediaPlayer!!.start()
        updatePlaybackProgress(ActivityState.PLAYBACK)
      }

      /** Pause subsequent play back */
      ActivityState.PLAYBACK_PAUSED -> {
        setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, nextBtnState)
        mediaPlayer!!.pause()
      }

      /** Activity stopped */
      ActivityState.ACTIVITY_STOPPED -> {
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
      ActivityState.WAIT_FOR_PLAY -> {
        setActivityState(ActivityState.FIRST_PLAYBACK)
      }
      ActivityState.FIRST_PLAYBACK -> {
        setActivityState(ActivityState.FIRST_PLAYBACK_PAUSED)
      }
      ActivityState.FIRST_PLAYBACK_PAUSED -> {
        setActivityState(ActivityState.FIRST_PLAYBACK)
      }
      ActivityState.REVIEW_ENABLED -> {
        setActivityState(ActivityState.PLAYBACK)
      }
      ActivityState.PLAYBACK -> {
        setActivityState(ActivityState.PLAYBACK_PAUSED)
      }
      ActivityState.PLAYBACK_PAUSED -> {
        setActivityState(ActivityState.PLAYBACK)
      }
      ActivityState.INIT, ActivityState.ACTIVITY_STOPPED -> {
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
    setButtonStates(ButtonState.DISABLED, ButtonState.DISABLED, ButtonState.DISABLED)


    if (activityState == ActivityState.PLAYBACK) {
      mediaPlayer!!.stop()
    }
    mediaPlayer?.release()
    mediaPlayer = null

      val decision =
        when (_decisionRating.value){
          R.string.decision_okay -> "accept"
          R.string.decision_excellent -> "excellent"
          else -> "reject"
        }

      var low_vol = _volumeTickHandler.value
      var noise = _noiseTickHandler.value
      var chatterIntermittent = _chatterTickHandlerIntermittent.value
      var fan = _fanTickHandler.value
      var silence = _silenceTickHandler.value
      var pageFlip = _pageFlipTickHandler.value
      var objCont = _objContTickHandler.value
      var skippingWords = _skippingWordsTickHandler.value
      var incorrectText = _incorrectTextTickHandler.value
      var incorrectStyle = _incorrectStyleTickHandler.value
      var unnatural = _unnaturalTickHandler.value
      var repContent = _repContentTickHandler.value
      var tooSlow = _tooSlowTickHandler.value
      var tooFast = _tooFastTickHandler.value
      var misPron = _misPronTickHandler.value
      var wrongSpeaker = _wrongSpeakerTickHandler.value
      var weakEmotion = _weakEmotionTickHandler.value
      var others = _othersTickHandler.value
      var dramatic = _dramaticTickHandler.value
      var other = _otherTickHandler.value
      var wrongLang = _wrongLangTickHandler.value
      var echo = _echoTickHandler.value
      var comments = _commentTextHandler.value

    if (decision == "excellent"){
      low_vol = false
      noise = false
      chatterIntermittent = false
      fan = false
      silence = false
      pageFlip = false
      objCont = false
      skippingWords = false
      incorrectText = false
      incorrectStyle = false
      unnatural = false
      repContent = false
      tooSlow = false
      tooFast = false
      misPron = false
      wrongSpeaker = false
      weakEmotion = false
      others = false
      dramatic = false
      other = false
      wrongLang = false
      echo = false
      comments = "excellent"
    }

    outputData.addProperty("decision",decision)
    outputData.addProperty("low_volume",low_vol)
    outputData.addProperty("noise", noise)
    outputData.addProperty("chatter", chatterIntermittent)
    outputData.addProperty("fan", fan)
    outputData.addProperty("silence", silence)
    outputData.addProperty("page_flip", pageFlip)
    outputData.addProperty("objectionable_content", objCont)
    outputData.addProperty("skipping_words", skippingWords)
    outputData.addProperty("incorrect_text", incorrectText)
    outputData.addProperty("incorrect_style", incorrectStyle)
    outputData.addProperty("unnatural", unnatural)
    outputData.addProperty("repeating_content", repContent)
    outputData.addProperty("too_slow", tooSlow)
    outputData.addProperty("too_fast", tooFast)
    outputData.addProperty("mispronounce", misPron)
    outputData.addProperty("wrong_speaker", wrongSpeaker)
    outputData.addProperty("weak_emotion", weakEmotion)
    outputData.addProperty("others", others)
    outputData.addProperty("other", other)
    outputData.addProperty("wrong_language", wrongLang)
    outputData.addProperty("echo", echo)
    outputData.addProperty("comments",comments)
    viewModelScope.launch {
      completeAndSaveCurrentMicrotask()
      setActivityState(ActivityState.INIT)
      moveToNextMicrotask()
    }
  }

  /** Set button states */
  private fun setButtonStates(
    backState: ButtonState,
    playState: ButtonState,
    nextState: ButtonState,
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

  fun handleNoiseTickChange(@StringRes value: Boolean) {
    _noiseTickHandler.value = value
    updateReviewStatus()
  }

  fun handleFanTickChange(@StringRes value: Boolean) {
    _fanTickHandler.value = value
    updateReviewStatus()
  }
  fun handleSilenceTickChange(@StringRes value: Boolean) {
    _silenceTickHandler.value = value
    updateReviewStatus()
  }

  fun handlePageFlipTickChange(@StringRes value: Boolean) {
    _pageFlipTickHandler.value = value
    updateReviewStatus()
  }

  fun handleIncorrectStyleTickChange(@StringRes value: Boolean) {
    _incorrectStyleTickHandler.value = value
    updateReviewStatus()
  }

  fun handleUnnaturalTickChange(@StringRes value: Boolean) {
    _unnaturalTickHandler.value = value
    updateReviewStatus()
  }

  fun handleTooFastTickChange(@StringRes value: Boolean) {
    _tooFastTickHandler.value = value
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


  fun handleChatterTickIntermittentChange(@StringRes value: Boolean) {
    _chatterTickHandlerIntermittent.value = value
    updateReviewStatus()
  }

  fun handleRepContentTickChange(@StringRes value: Boolean) {
    _repContentTickHandler.value = value
    updateReviewStatus()
  }

  fun handleTooSlowTickChange(@StringRes value: Boolean) {
    _tooSlowTickHandler.value = value
    updateReviewStatus()
  }

  fun handleMisPronTickChange(@StringRes value: Boolean) {
    _misPronTickHandler.value = value
    updateReviewStatus()
  }

  fun handleWrongSpeakerTickChange(@StringRes value: Boolean) {
    _wrongSpeakerTickHandler.value = value
    updateReviewStatus()
  }

  fun handleWeakEmotionTickChange(@StringRes value: Boolean) {
    _weakEmotionTickHandler.value = value
    updateReviewStatus()
  }

  fun handleOthersTickChange(@StringRes value: Boolean) {
    _othersTickHandler.value = value
    updateReviewStatus()
  }
  fun handleDramaticTickChange(@StringRes value: Boolean) {
    _dramaticTickHandler.value = value
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

 fun handleCommentsTickChange(@StringRes value: Boolean) {
    _commentTickHandler.value = value
    updateReviewStatus()
  }
  fun handleCommentTextChange(@StringRes value: String) {
    _commentTextHandler.value = value
    updateReviewStatus()
  }

  private fun updateReviewStatus() {
    val baseCase = (_echoTickHandler.value||_wrongLangTickHandler.value||_objContTickHandler.value ||
             _skippingWordsTickHandler.value || _incorrectTextTickHandler.value ||_volumeTickHandler.value ||
            _noiseTickHandler.value || _chatterTickHandlerIntermittent.value ||
             _fanTickHandler.value || _silenceTickHandler.value || _pageFlipTickHandler.value ||
            _objContTickHandler.value || _skippingWordsTickHandler.value || _incorrectTextTickHandler.value ||
            _incorrectStyleTickHandler.value || _unnaturalTickHandler.value || _repContentTickHandler.value ||
            _tooSlowTickHandler.value || _tooFastTickHandler.value || _misPronTickHandler.value ||
            _wrongSpeakerTickHandler.value || _weakEmotionTickHandler.value || _othersTickHandler.value ||
            _dramaticTickHandler.value)

    reviewCompleted = (_decisionRating.value == R.string.decision_excellent)
            ||
      (_decisionRating.value != R.string.rating_undefined && baseCase || (_commentTickHandler.value && _commentTextHandler.value != "")) && baseCase

    if (reviewCompleted) {
      setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, ButtonState.ENABLED)
    }
    else{
      setButtonStates(ButtonState.DISABLED, ButtonState.ENABLED, ButtonState.DISABLED)

    }
  }

  /** Update the progress bar for the player as long as the activity is in the specific state. */
  private fun updatePlaybackProgress(state: ActivityState) {
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
    // Give 2 on all reports
    _decisionRating.value = R.string.decision_bad
    _volumeTickHandler.value = true
    _noiseTickHandler.value = true
    _chatterTickHandlerIntermittent.value = true
    _fanTickHandler.value = true
    _silenceTickHandler.value = true
    _pageFlipTickHandler.value = true
    _objContTickHandler.value = true
    _skippingWordsTickHandler.value = true
    _incorrectTextTickHandler.value = true
    _incorrectStyleTickHandler.value = true
    _unnaturalTickHandler.value = true
    _repContentTickHandler.value = true
    _tooSlowTickHandler.value = true
    _tooFastTickHandler.value = true
    _misPronTickHandler.value = true
    _wrongSpeakerTickHandler.value = true
    _weakEmotionTickHandler.value = true
    _othersTickHandler.value = true
    _dramaticTickHandler.value = true
    _otherTickHandler.value = true
    _wrongLangTickHandler.value = true
    _echoTickHandler.value = true
    _commentTickHandler.value = true
    _commentTextHandler.value = "corrupt"
    _wrongLangTickHandler.value = true
    outputData.addProperty("flag", "corrupt")

    // Move to next task
    handleNextClick()
  }

  fun handleSeekBarChange(int: Int, boolean: Boolean){
    if (boolean){
      mediaPlayer!!.pause()
      Thread.sleep(100)
      mediaPlayer!!.seekTo(int)
      Thread.sleep(100)
      setActivityState(ActivityState.PLAYBACK)
    }
  }
}

