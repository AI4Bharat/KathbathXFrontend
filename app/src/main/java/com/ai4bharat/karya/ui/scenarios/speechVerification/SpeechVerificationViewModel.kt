package com.ai4bharat.karya.ui.scenarios.speechVerification

import android.media.MediaPlayer
import android.util.Log
import android.view.View
import android.widget.EditText
import androidx.annotation.StringRes
import androidx.lifecycle.viewModelScope
import com.google.gson.JsonObject
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.repo.AssignmentRepository
import com.ai4bharat.karya.data.repo.MicroTaskRepository
import com.ai4bharat.karya.data.repo.TaskRepository
import com.ai4bharat.karya.injection.qualifier.FilesDir
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererViewModel
import com.ai4bharat.karya.utils.extensions.visible
import com.google.android.material.textfield.TextInputEditText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.android.synthetic.main.microtask_speech_verification.*
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

  /** Verification status */
//  private var _accuracyRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val accuracyRating = _accuracyRating.asStateFlow()
//
//  private var _qualityRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val qualityRating = _qualityRating.asStateFlow()

  private var _decisionRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val decisionRating = _decisionRating.asStateFlow()
  private var _volumeTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
//  private var _noiseTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
//  private var _chatterTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _unclearAudioTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

  private var _noiseTickHandlerIntermittent: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _chatterTickHandlerIntermittent: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _noiseTickHandlerPersistent: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _chatterTickHandlerPersistent: MutableStateFlow<Boolean> = MutableStateFlow(false)
//  private var _miscTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)

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


  private var _commentTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _commentTextHandler: MutableStateFlow<String> = MutableStateFlow("")
  val commentTickHandler = _commentTickHandler.asStateFlow()


//  private var _volumeRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val volumeRating = _volumeRating.asStateFlow()
//
//  private var _bgNoiseRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val bgNoiseRating = _bgNoiseRating.asStateFlow()
//
//  private var _cSwitchRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val cSwitchRating = _cSwitchRating.asStateFlow()
//
//  private var _bgChatterRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val bgChatterRating = _bgChatterRating.asStateFlow()
//
//  private var _voLapRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val voLapRating = _voLapRating.asStateFlow()
//
//  private var _sstRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val sstRating = _sstRating.asStateFlow()
//
//  private var _handleReadQRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val handleReadQRating = _handleReadQRating.asStateFlow()
//
//  private var _handleExtemporeQRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val handleExtemporeQRating = _handleExtemporeQRating.asStateFlow()


//  private var _fluencyRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val fluencyRating = _fluencyRating.asStateFlow()

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

  // Button State Order: PlayButton, NextButton, BackButton
  val navAndMediaBtnGroup = _navAndMediaBtnGroup.asStateFlow()

  private val _reviewEnabled: MutableStateFlow<Boolean> = MutableStateFlow(false)
  val reviewEnabled = _reviewEnabled.asStateFlow()

  private val _showErrorWithDialog: MutableStateFlow<String> = MutableStateFlow("")
  val showErrorWithDialog = _showErrorWithDialog.asStateFlow()






  override fun setupMicrotask() {


//    _accuracyRating.value = R.string.rating_undefined
//    _qualityRating.value = R.string.rating_undefined
    _decisionRating.value = R.string.rating_undefined
    _volumeTickHandler.value = false
//    _miscTickHandler.value = false
//    _noiseTickHandler.value = false
//    _chatterTickHandler.value = false
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

//    _volumeRating.value = R.string.rating_undefined
//    _bgNoiseRating.value = R.string.rating_undefined
//    _cSwitchRating.value = R.string.rating_undefined
//    _bgChatterRating.value = R.string.rating_undefined
//    _voLapRating.value = R.string.rating_undefined
//    _sstRating.value = R.string.rating_undefined
//    _handleReadQRating.value = R.string.rating_undefined
//    _handleExtemporeQRating.value = R.string.rating_undefined

//    _fluencyRating.value = R.string.rating_undefined
//    viewModelScope.launch {
//      if (taskRepository.getById(currentMicroTask.task_id).name.contains("[conversations]",ignoreCase = true))
//      {
//        Log.e("CONVERSATIONS","Disable Read Q")
//      }
//      else if (taskRepository.getById(currentMicroTask.task_id).name.contains("[read]",ignoreCase = true))
//      {
//        Log.e("READ","Disable SST Q, EXTEMPORE Q")
//      }
//      else if (taskRepository.getById(currentMicroTask.task_id).name.contains("[extempore]",ignoreCase = true))
//      {
//        Log.e("EXTEMPORE","Disable REad Q, SST")
//      }
//    }

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

//
//    if (this.task.name.contains("read",ignoreCase = true)){
//      handleAccuracyChange(-1)
//      handleQualityChange(-1)
//    }
//
//    else if (this.task.name.contains("extempore",ignoreCase = true)){
//      handleAccuracyChange(-1)
//    }

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

//    var accuracy =
//      when (_accuracyRating.value) {
//        R.string.accuracy_good -> 2
//        R.string.accuracy_okay -> 1
//        else -> 0
//      }
//
//    var quality =
//      when (_qualityRating.value) {
//        R.string.quality_good -> 2
//        R.string.quality_okay -> 1
//        else -> 0
//      }

//    val volume =
//      when (_volumeRating.value) {
//        R.string.volume_good -> 2
//        R.string.volume_okay -> 1
//        else -> 0
//      }
//
//    val bgNoise =
//      when (_bgNoiseRating.value){
//        R.string.bgNoise_okay -> 1
//        R.string.bgNoise_bad -> 0
//        else -> 0
//      }
//
//    val cSwitching =
//      when (_cSwitchRating.value){
//        R.string.cSwitching_okay -> 1
//        R.string.cSwitching_bad -> 0
//        else -> 0
//      }
//
//    val bgChatter =
//      when (_bgChatterRating.value){
//        R.string.bgChatter_okay -> 1
//        R.string.bgChatter_bad -> 0
//        else -> 0
//      }
//    val voLap =
//      when (_voLapRating.value){
//        R.string.volap_okay -> 1
//        R.string.volap_bad -> 0
//        else -> 0
//      }
//    val sst =
//      when (_sstRating.value){
//        R.string.sst_okay -> 1
//        R.string.sst_bad -> 0
//        else -> 0
//      }
//    val readq =
//      when (_handleReadQRating.value){
//        R.string.readQuality_okay -> 1
//        R.string.readQuality_bad -> 0
//        else -> 0
//      }
//
//    val extemporq =
//      when (handleExtemporeQRating.value){
//        R.string.extemporeQuality_okay -> 1
//        R.string.extemporeQuality_okay -> 0
//        else -> 0
//      }

//    val fluency =
//      when (_fluencyRating.value) {
//        R.string.fluency_good -> 2
//        R.string.fluency_okay -> 1
//        else -> 0
//      }

//    if (this.task.name.contains("read",ignoreCase = true)){
//      accuracy = -1
//      quality = -1
//    }
//
//    else if (this.task.name.contains("extempore",ignoreCase = true)){
//      accuracy = -1
//    }

      val decision =
        when (_decisionRating.value){
          R.string.decision_okay -> "accept"
          R.string.decision_excellent -> "excellent"
          else -> "reject"
        }

      var low_vol = _volumeTickHandler.value
//      var noise = _noiseTickHandler.value
//      var chatter = _chatterTickHandler.value
      var noiseIntermittent = _noiseTickHandlerIntermittent.value
      var chatterIntermittent = _chatterTickHandlerIntermittent.value
      var noisePersistent = _noiseTickHandlerPersistent.value
      var chatterPersistent = _chatterTickHandlerPersistent.value
//      var misc = _miscTickHandler.value
      var unclearAudio = _unclearAudioTickHandler.value
      var notOnTopic = _notOnTopicTickHandler.value
      var repContent = _repContentTickHandler.value
      var longPause = _longPausesTickHandler.value
      var mispron = _misPronTickHandler.value
      var readPrompt = _readPromptTickHandler.value
      var bookRead = _bookReadTickHandler.value
      var sst = _sstTickHandler.value
      var stretching = _stretchingTickHandler.value
//      var bad_read_quality = _readqTickHandler.value
      var bad_extempore_quality = _badExtemporeTickHandler.value
      var comments = _commentTextHandler.value
      var objectionable_content = _objContTickHandler.value
      var incorrect_text_prompt = _incorrectTextTickHandler.value
      var factual_inaccuracy = _factualInaccuracyTickHandler.value
      var skipping_words = _skippingWordsTickHandler.value


    if (decision == "excellent"){
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
//      bad_extempore_quality = false
//      bad_read_quality = false
      comments = "excellent"
    }

    outputData.addProperty("decision",decision)
    outputData.addProperty("low_volume",low_vol)
//    outputData.addProperty("noise",noise)
//    outputData.addProperty("chatter",chatter)
    outputData.addProperty("noise_intermittent",noiseIntermittent)
    outputData.addProperty("chatter_intermittent",chatterIntermittent)
    outputData.addProperty("noise_persistent",noisePersistent)
    outputData.addProperty("chatter_persistent",chatterPersistent)
    outputData.addProperty("unclear_audio",unclearAudio)
    outputData.addProperty("off_topic",notOnTopic)
    outputData.addProperty("repeating_content",repContent)
    outputData.addProperty("long_pauses",longPause)
    outputData.addProperty("mispronunciation",mispron)
    outputData.addProperty("reading_prompt",readPrompt)
    outputData.addProperty("book_read",bookRead)
//    outputData.addProperty("misc",false)


    outputData.addProperty("sst",sst)
    outputData.addProperty("stretching",stretching)


    outputData.addProperty("bad_extempore_quality",bad_extempore_quality)
//    outputData.addProperty("bad_read_quality",bad_read_quality)
    outputData.addProperty("comments",comments)
    outputData.addProperty("objectionable_content",objectionable_content)
    outputData.addProperty("skipping_words",skipping_words)
    outputData.addProperty("incorrect_text_prompt",incorrect_text_prompt)
    outputData.addProperty("factual_inaccuracy",factual_inaccuracy)

//    outputData.addProperty("volume", volume)
//    outputData.addProperty("bgnoise", bgNoise)
//    outputData.addProperty("cswitch", cSwitching)
//    outputData.addProperty("bgchatter", bgChatter)
//    outputData.addProperty("volap", voLap)
//    outputData.addProperty("sst", sst)
//    outputData.addProperty("readquality", readq)
//    outputData.addProperty("extemporequality", extemporq)

//    outputData.addProperty("comment",comments)


//    outputData.addProperty("fluency", fluency)

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


//  /** Handle accuracy change */
//  fun handleAccuracyChange(@StringRes accuracy: Int) {
//    _accuracyRating.value = accuracy
//    updateReviewStatus()
//  }
//
//  /** Handle quality change */
//  fun handleQualityChange(@StringRes quality: Int) {
//    _qualityRating.value = quality
//    updateReviewStatus()
//  }

  /** Handle volume change */

  fun handleDecisionChange(@StringRes decision: Int) {
    _decisionRating.value = decision
    updateReviewStatus()
  }

  fun handleVolumeTickChange(@StringRes value: Boolean) {
    _volumeTickHandler.value = value
    updateReviewStatus()
  }

//  fun handleNoiseTickChange(@StringRes value: Boolean) {
//    _noiseTickHandler.value = value
//    updateReviewStatus()
//  }
//
//  fun handleChatterTickChange(@StringRes value: Boolean) {
//    _chatterTickHandler.value = value
//    updateReviewStatus()
//  }

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

//  fun handleMiscTickChange(@StringRes value: Boolean) {
//    _miscTickHandler.value = value
//    updateReviewStatus()
//  }
//  fun handleReadQTickChange(@StringRes value: Boolean) {
//    _readqTickHandler.value = value
//    updateReviewStatus()
//  }
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

//
//  fun handleVolumeChange(@StringRes volume: Int) {
//    _volumeRating.value = volume
//    updateReviewStatus()
//  }
//
//  /** Handle bgNoise change */
//  fun handleBgNoiseChange(@StringRes bgNoise: Int) {
//    _bgNoiseRating.value = bgNoise
//    updateReviewStatus()
//  }
//
//  fun handleCSwitchingChange(@StringRes cSwitching: Int) {
//    _cSwitchRating.value = cSwitching
//    updateReviewStatus()
//  }
//
//  fun handleBgChatterChange(@StringRes bgChatter: Int) {
//    _bgChatterRating.value = bgChatter
//    updateReviewStatus()
//  }
//
//  fun handleVoLapChange(@StringRes voLap: Int) {
//    _voLapRating.value = voLap
//    updateReviewStatus()
//  }
//
//  fun handleSstChange(@StringRes sst: Int) {
//    _sstRating.value = sst
//    updateReviewStatus()
//  }
//
//  fun handleReadQChange(@StringRes qRating: Int) {
//    _handleReadQRating.value = qRating
//    updateReviewStatus()
//  }
//  fun handleExtemporeQChange(@StringRes eRating: Int) {
//    _handleExtemporeQRating.value = eRating
//    updateReviewStatus()
//  }





//  fun handleFluencyChange(@StringRes fluency: Int) {
//    _fluencyRating.value = fluency
//    updateReviewStatus()
//  }

  private fun updateReviewStatus() {
//    val baseCase = (_volumeTickHandler.value || _noiseTickHandler.value || _chatterTickHandler.value || _unclearAudioTickHandler.value || _notOnTopicTickHandler.value || _repContentTickHandler.value || _longPausesTickHandler.value || _misPronTickHandler.value || _readPromptTickHandler.value || _bookReadTickHandler.value || _sstTickHandler.value || _stretchingTickHandler.value || _badExtemporeTickHandler.value )
    val baseCase = (_objContTickHandler.value || _skippingWordsTickHandler.value || _factualInaccuracyTickHandler.value || _incorrectTextTickHandler.value ||_volumeTickHandler.value ||
            _noiseTickHandlerIntermittent.value ||  _noiseTickHandlerPersistent.value ||
            _chatterTickHandlerIntermittent.value ||  _chatterTickHandlerPersistent.value ||
             _unclearAudioTickHandler.value || _notOnTopicTickHandler.value ||
            _repContentTickHandler.value ||
            _longPausesTickHandler.value ||
            _misPronTickHandler.value || _readPromptTickHandler.value ||
            _bookReadTickHandler.value || _sstTickHandler.value ||
            _stretchingTickHandler.value || _badExtemporeTickHandler.value ) &&
            !(_chatterTickHandlerIntermittent.value &&  _chatterTickHandlerPersistent.value) &&
            !(_noiseTickHandlerIntermittent.value &&  _noiseTickHandlerPersistent.value)





    reviewCompleted = (_decisionRating.value == R.string.decision_excellent)
            ||
      (_decisionRating.value != R.string.rating_undefined && baseCase || (_commentTickHandler.value && _commentTextHandler.value != "")) && baseCase
//              (_volumeTickHandler.value || _noiseTickHandler.value || _chatterTickHandler.value || _sstTickHandler.value || _readqTickHandler.value || _extemporeqTickHandler.value ) || ( _commentTickHandler.value && _commentTextHandler.value != ""))

//      _accuracyRating.value != R.string.rating_undefined &&
//        _qualityRating.value != R.string.rating_undefined &&
//        _volumeRating.value != R.string.rating_undefined &&
//                _bgNoiseRating.value != R.string.rating_undefined &&
//                _cSwitchRating.value != R.string.rating_undefined &&
//                _bgChatterRating.value != R.string.rating_undefined &&
//                _voLapRating.value != R.string.rating_undefined &&
//                _sstRating.value != R.string.rating_undefined &&
//                _handleReadQRating.value != R.string.rating_undefined &&
//                _handleExtemporeQRating.value != R.string.rating_undefined
//        &&
//        _fluencyRating.value != R.string.rating_undefined

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
//    _accuracyRating.value = R.string.accuracy_bad
//    _miscTickHandler.value = true
    _objContTickHandler.value = true
    _skippingWordsTickHandler.value = true
    _factualInaccuracyTickHandler.value = true
    _incorrectTextTickHandler.value = true
    _decisionRating.value = R.string.decision_bad
    _volumeTickHandler.value = true
//    _noiseTickHandler.value = true
//    _chatterTickHandler.value = true
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
//    _readqTickHandler.value = true
    _badExtemporeTickHandler.value = true
    _commentTickHandler.value = true
    _commentTextHandler.value = "corrupt"

//    _volumeRating.value = R.string.volume_bad
//    _bgNoiseRating.value = R.string.bgNoise_bad
//    _cSwitchRating.value = R.string.cSwitching_bad
//    _bgChatterRating.value = R.string.bgChatter_bad
//    _voLapRating.value = R.string.volap_bad
//    _sstRating.value = R.string.sst_bad
//    _handleReadQRating.value = R.string.readQuality_bad
//    _handleExtemporeQRating.value = R.string.extemporeQuality_bad

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
//  fun handleTracking()

}

