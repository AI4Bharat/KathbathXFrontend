package com.ai4bharat.karya.ui.scenarios.signVideoVerification

import android.util.Log
import androidx.annotation.StringRes
import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.R
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.google.gson.JsonObject
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.repo.AssignmentRepository
import com.ai4bharat.karya.data.repo.MicroTaskRepository
import com.ai4bharat.karya.data.repo.TaskRepository
import com.ai4bharat.karya.data.repo.WorkerRepository
import com.ai4bharat.karya.injection.qualifier.FilesDir
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererViewModel
import com.ai4bharat.karya.ui.scenarios.signVideoVerification.SignVideoVerificationViewModel.ButtonState.DISABLED
import com.ai4bharat.karya.ui.scenarios.signVideoVerification.SignVideoVerificationViewModel.ButtonState.ENABLED
import com.ai4bharat.karya.ui.scenarios.speechVerification.SpeechVerificationViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

@HiltViewModel
class SignVideoVerificationViewModel
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
  authManager) {

  @Inject
  lateinit var workerRepository: WorkerRepository

  var score: String = "undefined"
  var wrongGender: Boolean = false
  var wrongAgeGroup: Boolean = false
  var duplicateWorker: Boolean = false
  var remarks: String = ""

  /** UI State **/
//  private val _backBtnState: MutableStateFlow<ButtonState> = MutableStateFlow(ENABLED)
//  val backBtnState = _backBtnState.asStateFlow()

  private var _decisionRating: MutableStateFlow<String> = MutableStateFlow("undefined")
  val decisionRating = _decisionRating.asStateFlow()

  private val _nextBtnState: MutableStateFlow<ButtonState> = MutableStateFlow(ENABLED)
  val nextBtnState = _nextBtnState.asStateFlow()

  private val _fileID: MutableStateFlow<String> = MutableStateFlow("")
  val fileID = _fileID.asStateFlow()

  private val _fileGender: MutableStateFlow<String> = MutableStateFlow("")
  val fileGender = _fileGender.asStateFlow()

  private val _fileAgeGroup: MutableStateFlow<String> = MutableStateFlow("")
  val fileAgeGroup = _fileAgeGroup.asStateFlow()
//  private val _oldRemarks: MutableStateFlow<String> = MutableStateFlow("")
//  val oldRemarks = _oldRemarks.asStateFlow()
//
//  private val _microtaskID: MutableStateFlow<String> = MutableStateFlow("")
//  val microtaskID = _microtaskID.asStateFlow()

//  private val _oldScore: MutableStateFlow<Int> = MutableStateFlow(0)
//  val oldScore = _oldScore.asStateFlow()

  private val _sentenceTvText: MutableStateFlow<String> = MutableStateFlow("")
  val sentenceTvText = _sentenceTvText.asStateFlow()

  private val _recordingFile: MutableStateFlow<String> = MutableStateFlow("")
  val recordingFile = _recordingFile.asStateFlow()

  private val _videoPlayerVisibility: MutableStateFlow<Boolean> = MutableStateFlow(false)
  val videoPlayerVisibility = _videoPlayerVisibility.asStateFlow()

  private var _wrongGenderTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _wrongAgeGroupTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _duplicateSpeakerTickHandler: MutableStateFlow<Boolean> = MutableStateFlow(false)
  private var _commentTextHandler: MutableStateFlow<String> = MutableStateFlow("")

  /**
   * UI button states
   *
   * [DISABLED]: Greyed out. Cannot click [ENABLED]: Can click
   */
  enum class ButtonState {
    DISABLED,
    ENABLED
  }



  /** Shortcut to set and flush all four button states (in sequence) */
  private fun setButtonStates(b: ButtonState, n: ButtonState) {
//    _backBtnState.value = b
    _nextBtnState.value = n
  }

  /** Handle next button click */
  fun handleNextClick() {
    // log the state transition
    val message = JsonObject()
    message.addProperty("type", "o")
    message.addProperty("button", "NEXT")
    log(message)

    outputData.addProperty("decision", score)
    outputData.addProperty("wrong_gender", wrongGender)
    outputData.addProperty("wrong_age_group", wrongAgeGroup)
    outputData.addProperty("duplicate_speaker", duplicateWorker)
    outputData.addProperty("commments", remarks)

    _videoPlayerVisibility.value = false

    viewModelScope.launch {
      completeAndSaveCurrentMicrotask()
      moveToNextMicrotask()
    }
    resetStates()
  }

  private fun resetStates() {
    score = "undefined"
    remarks = ""
    wrongAgeGroup = false
    wrongGender = false
    duplicateWorker = false
  }

  /** Handle back button click */
  fun handleBackClick() {
    // log the state transition
    val message = JsonObject()
    message.addProperty("type", "o")
    message.addProperty("button", "BACK")
    log(message)

    moveToPreviousMicrotask()
  }

  fun onBackPressed() {
    // log the state transition
    val message = JsonObject()
    message.addProperty("type", "o")
    message.addProperty("button", "ANDROID_BACK")
    log(message)
    navigateBack()
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

  override fun setupMicrotask() {


    // TODO: Pick up from server
    val sentence = currentMicroTask.input.asJsonObject.getAsJsonObject("data").get("sentence").toString()

    try {
      val recordingFileName =
        currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("recording").asString
      val recordFilePath = microtaskInputContainer.getMicrotaskInputFilePath(
        currentMicroTask.id,
        recordingFileName
      )
//      _microtaskID.value = currentMicroTask.id
      _fileID.value = currentMicroTask.id
      _recordingFile.value = recordFilePath
      _videoPlayerVisibility.value = true
      _sentenceTvText.value = sentence

      val wid = currentMicroTask.input.asJsonObject.getAsJsonObject("chain").get("workerId").toString().trim('"')
      viewModelScope.launch {
        val localWorker = workerRepository.getWorkerById(wid)
        if (localWorker == null) {
          workerRepository.getWorkerFromBox(wid)
            .catch {
                throwable -> Log.e("TRYING TO FETCH",throwable.toString()) }
            .collect {
                worker -> workerRepository.upsertWorker(worker)
              _fileGender.value = worker.profile?.asJsonObject?.get("gender").toString().trim('"')
              _fileAgeGroup.value = age2group(worker.profile?.asJsonObject?.get("age")!!.asInt)
            }
        }
        else {
          _fileGender.value = localWorker.profile?.asJsonObject?.get("gender").toString().trim('"')
          _fileAgeGroup.value = age2group(localWorker.profile?.asJsonObject?.get("age")!!.asInt)
        }
      }
    } catch (e: Exception) {
      FirebaseCrashlytics.getInstance().recordException(e)
      // log the state transition
      val message = JsonObject()
      message.addProperty("type", "m")
      message.addProperty("message", "NO_FILE")
      log(message)

      outputData.addProperty("score", "undefined")
      outputData.addProperty("remarks", "No recording file present")

      _videoPlayerVisibility.value = false

      viewModelScope.launch {
        completeAndSaveCurrentMicrotask()
        moveToNextMicrotask()
      }
      resetStates()
    }

  }


//  fun handleDecisionChange(@StringRes decision: String) {
//    _decisionRating.value = decision
//    updateReviewStatus()
//  }
//
//  fun handleWrongGenderTickChange(@StringRes value: Boolean) {
//    _wrongGenderTickHandler.value = value
//    updateReviewStatus()
//  }
//
//  fun handleWrongAgeGroupTickChange(@StringRes value: Boolean) {
//    _wrongAgeGroupTickHandler.value = value
//    updateReviewStatus()
//  }
//
//  fun handleDuplicateSpeakerTickChange(@StringRes value: Boolean) {
//    _duplicateSpeakerTickHandler.value = value
//    updateReviewStatus()
//  }
//
//  fun handleCommentTextChange(@StringRes value: String) {
//    _commentTextHandler.value = value
//    updateReviewStatus()
//  }

//  private fun updateReviewStatus() {
////    val baseCase = (_volumeTickHandler.value || _noiseTickHandler.value || _chatterTickHandler.value || _unclearAudioTickHandler.value || _notOnTopicTickHandler.value || _repContentTickHandler.value || _longPausesTickHandler.value || _misPronTickHandler.value || _readPromptTickHandler.value || _bookReadTickHandler.value || _sstTickHandler.value || _stretchingTickHandler.value || _badExtemporeTickHandler.value )
//    val baseCase = (_wrongAgeGroupTickHandler.value||_wrongGenderTickHandler.value||_duplicateSpeakerTickHandler.value)
//    reviewCompleted = (_decisionRating.value == "accept")
//            ||
//            (_decisionRating.value != "undefined" && baseCase)
//
//    if (reviewCompleted) {
//      setButtonStates(ENABLED,ENABLED)
//    }
//    else{
//      setButtonStates(DISABLED,DISABLED)
//
//    }
//  }

}
