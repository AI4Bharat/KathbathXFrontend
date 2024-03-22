package com.ai4bharat.karya.ui.scenarios.sentenceValidation

import androidx.lifecycle.viewModelScope
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.repo.AssignmentRepository
import com.ai4bharat.karya.data.repo.MicroTaskRepository
import com.ai4bharat.karya.data.repo.TaskRepository
import com.ai4bharat.karya.injection.qualifier.FilesDir
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SentenceValidationViewModel
@Inject
constructor(
  assignmentRepository: AssignmentRepository,
  taskRepository: TaskRepository,
  microTaskRepository: MicroTaskRepository,
  @FilesDir fileDirPath: String,
  authManager: AuthManager,
): BaseMTRendererViewModel(
  assignmentRepository,
  taskRepository,
  microTaskRepository,
  fileDirPath,
  authManager
)
{
  // UI elements controlled by the view model

  // Sentence
  private val _sentence: MutableStateFlow<String> = MutableStateFlow("")
  val sentence = _sentence.asStateFlow()

  /**
   * Setup sentence validation microtask
   */
  override fun setupMicrotask() {
    val inputData = currentMicroTask.input.asJsonObject.getAsJsonObject("data")
    _sentence.value = inputData.get("sentence").asString
  }

  /**
   * Submit response
   */
  fun submitResponse(grammar: Boolean, spelling: Boolean, appropriate: Boolean) {
    outputData.addProperty("grammar", grammar)
    outputData.addProperty("spelling", spelling)
    outputData.addProperty("appropriate", appropriate)

    viewModelScope.launch {
      completeAndSaveCurrentMicrotask()
      moveToNextMicrotask()
    }
  }
}
