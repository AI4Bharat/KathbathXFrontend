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
import com.google.android.material.textfield.TextInputEditText
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

  /** Verification status */
//  private var _accuracyRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val accuracyRating = _accuracyRating.asStateFlow()
//
//  private var _qualityRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val qualityRating = _qualityRating.asStateFlow()

  private var _volumeRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val volumeRating = _volumeRating.asStateFlow()

  private var _bgNoiseRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val bgNoiseRating = _bgNoiseRating.asStateFlow()

  private var _cSwitchRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val cSwitchRating = _cSwitchRating.asStateFlow()

  private var _bgChatterRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val bgChatterRating = _bgChatterRating.asStateFlow()

  private var _voLapRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val voLapRating = _voLapRating.asStateFlow()

  private var _sstRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val sstRating = _sstRating.asStateFlow()

  private var _handleReadQRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val handleReadQRating = _handleReadQRating.asStateFlow()

  private var _handleExtemporeQRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
  val handleExtemporeQRating = _handleExtemporeQRating.asStateFlow()


//  private var _fluencyRating: MutableStateFlow<Int> = MutableStateFlow(R.string.rating_undefined)
//  val fluencyRating = _fluencyRating.asStateFlow()

  private var reviewCompleted = false

  private lateinit var playbackProgressThread: Thread

  // Defining Mutable State Flows
  private val _sentenceTvText: MutableStateFlow<String> = MutableStateFlow("")
  val sentenceTvText = _sentenceTvText.asStateFlow()

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

  private val _commentText: MutableStateFlow<String> = MutableStateFlow("")
  val commentText = _commentText.asStateFlow()

  override fun setupMicrotask() {
//    _accuracyRating.value = R.string.rating_undefined
//    _qualityRating.value = R.string.rating_undefined
    _volumeRating.value = R.string.rating_undefined
    _bgNoiseRating.value = R.string.rating_undefined
    _cSwitchRating.value = R.string.rating_undefined
    _bgChatterRating.value = R.string.rating_undefined
    _voLapRating.value = R.string.rating_undefined
    _sstRating.value = R.string.rating_undefined

//    _fluencyRating.value = R.string.rating_undefined
    viewModelScope.launch {
      if (taskRepository.getById(currentMicroTask.task_id).name.contains("[conversations]",ignoreCase = true))
      {
        Log.e("CONVERSATIONS","Disable Read Q")
      }
      else if (taskRepository.getById(currentMicroTask.task_id).name.contains("[read]",ignoreCase = true))
      {
        Log.e("READ","Disable SST Q, EXTEMPORE Q")
      }
      else if (taskRepository.getById(currentMicroTask.task_id).name.contains("[extempore]",ignoreCase = true))
      {
        Log.e("EXTEMPORE","Disable REad Q, SST")
      }
    }

    _reviewEnabled.value = false
    reviewCompleted = false

    val sentence =
      currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()
    val recordingFileName =
      currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("recording").asString
    val recordingFile =
      microtaskInputContainer.getMicrotaskInputFilePath(currentMicroTask.id, recordingFileName)

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

    val volume =
      when (_volumeRating.value) {
        R.string.volume_good -> 2
        R.string.volume_okay -> 1
        else -> 0
      }

    val bgNoise =
      when (_bgNoiseRating.value){
        R.string.bgNoise_okay -> 1
        R.string.bgNoise_bad -> 0
        else -> 0
      }

    val cSwitching =
      when (_cSwitchRating.value){
        R.string.cSwitching_okay -> 1
        R.string.cSwitching_bad -> 0
        else -> 0
      }

    val bgChatter =
      when (_bgChatterRating.value){
        R.string.bgChatter_okay -> 1
        R.string.bgChatter_bad -> 0
        else -> 0
      }
    val voLap =
      when (_voLapRating.value){
        R.string.volap_okay -> 1
        R.string.volap_bad -> 0
        else -> 0
      }
    val sst =
      when (_sstRating.value){
        R.string.sst_okay -> 1
        R.string.sst_bad -> 0
        else -> 0
      }
    val readq =
      when (_handleReadQRating.value){
        R.string.readQuality_okay -> 1
        R.string.readQuality_bad -> 0
        else -> 0
      }

    val extemporq =
      when (handleExtemporeQRating.value){
        R.string.extemporeQuality_okay -> 1
        R.string.extemporeQuality_okay -> 0
        else -> 0
      }

   val comments = getView()/

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



//    outputData.addProperty("interactiveness", accuracy)
//    outputData.addProperty("extempore_quality", quality)
    outputData.addProperty("volume", volume)
    outputData.addProperty("bgnoise", bgNoise)
    outputData.addProperty("cswitch", cSwitching)
    outputData.addProperty("bgchatter", bgChatter)
    outputData.addProperty("volap", voLap)
    outputData.addProperty("sst", sst)
    outputData.addProperty("readquality", readq)
    outputData.addProperty("extemporequality", extemporq)

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
  fun handleVolumeChange(@StringRes volume: Int) {
    _volumeRating.value = volume
    updateReviewStatus()
  }

  /** Handle bgNoise change */
  fun handleBgNoiseChange(@StringRes bgNoise: Int) {
    _bgNoiseRating.value = bgNoise
    updateReviewStatus()
  }

  fun handleCSwitchingChange(@StringRes cSwitching: Int) {
    _cSwitchRating.value = cSwitching
    updateReviewStatus()
  }

  fun handleBgChatterChange(@StringRes bgChatter: Int) {
    _bgChatterRating.value = bgChatter
    updateReviewStatus()
  }

  fun handleVoLapChange(@StringRes voLap: Int) {
    _voLapRating.value = voLap
    updateReviewStatus()
  }

  fun handleSstChange(@StringRes sst: Int) {
    _sstRating.value = sst
    updateReviewStatus()
  }

  fun handleReadQChange(@StringRes qRating: Int) {
    _handleReadQRating.value = qRating
    updateReviewStatus()
  }
  fun handleExtemporeQChange(@StringRes eRating: Int) {
    _handleExtemporeQRating.value = eRating
    updateReviewStatus()
  }





//  fun handleFluencyChange(@StringRes fluency: Int) {
//    _fluencyRating.value = fluency
//    updateReviewStatus()
//  }

  private fun updateReviewStatus() {
    reviewCompleted =
//      _accuracyRating.value != R.string.rating_undefined &&
//        _qualityRating.value != R.string.rating_undefined &&
        _volumeRating.value != R.string.rating_undefined &&
                _bgNoiseRating.value != R.string.rating_undefined &&
                _cSwitchRating.value != R.string.rating_undefined &&
                _bgChatterRating.value != R.string.rating_undefined &&
                _voLapRating.value != R.string.rating_undefined &&
                _sstRating.value != R.string.rating_undefined &&
                _handleReadQRating.value != R.string.rating_undefined &&
                _handleExtemporeQRating.value != R.string.rating_undefined
//        &&
//        _fluencyRating.value != R.string.rating_undefined

    if (reviewCompleted) {
      setButtonStates(ButtonState.ENABLED, ButtonState.ENABLED, ButtonState.ENABLED)
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
    _volumeRating.value = R.string.volume_bad
    _bgNoiseRating.value = R.string.bgNoise_bad
    _cSwitchRating.value = R.string.cSwitching_bad
    _bgChatterRating.value = R.string.bgChatter_bad
    _voLapRating.value = R.string.volap_bad
    _sstRating.value = R.string.sst_bad
    _handleReadQRating.value = R.string.readQuality_bad
    _handleExtemporeQRating.value = R.string.extemporeQuality_bad

    outputData.addProperty("flag", "corrupt")

    // Move to next task
    handleNextClick()
  }

}

