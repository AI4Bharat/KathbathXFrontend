package com.ai4bharat.kathbath.ui.scenarios.imageTextData

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.data.repo.TaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ImageTextDataViewModel
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

    private val _imageFilePath: MutableStateFlow<String> = MutableStateFlow("")
    val imageFilePath = _imageFilePath.asStateFlow()

    /**
     * Complete microtask and move to next
     */
    fun completeTranscription(transcription: String) {
        // Add output transcription
        outputData.addProperty("transcription", transcription)
        viewModelScope.launch {
            completeAndSaveCurrentMicrotask()
            moveToNextMicrotask()
        }
    }

    /**
     * Setup image transcription microtask
     */
    override fun setupMicrotask() {
        // Get and set the image file
        _imageFilePath.value = try {
            val imageFileName =
                currentMicroTask.input.asJsonObject.getAsJsonObject("files").get("image").asString
            microtaskInputContainer.getMicrotaskInputFilePath(currentMicroTask.id, imageFileName)
        } catch (e: Exception) {
            ""
        }
    }

}