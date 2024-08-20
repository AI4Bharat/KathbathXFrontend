package com.ai4bharat.karya.ui.dashboard

import android.app.AlertDialog
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.view.size
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.viewModelScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.work.*
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.model.karya.enums.ScenarioType
import com.ai4bharat.karya.data.model.karya.modelsExtra.TaskInfo
import com.ai4bharat.karya.databinding.FragmentDashboardBinding
import com.ai4bharat.karya.ui.base.SessionFragment
import com.ai4bharat.karya.utils.extensions.*
import com.ai4bharat.karya.BuildConfig
import com.ai4bharat.karya.data.remote.request.RegisterOrUpdateWorkerRequest
import com.ai4bharat.karya.data.service.WorkerAPI
import com.ai4bharat.karya.ui.Destination
import com.ai4bharat.karya.ui.MainActivity
import com.google.gson.JsonElement
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.fragment_dashboard.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import java.util.*
import kotlin.math.round

private const val UNIQUE_SYNC_WORK_NAME = "syncWork"

enum class ERROR_TYPE {
    SYNC_ERROR, TASK_ERROR
}

enum class ERROR_LVL {
    WARNING, ERROR
}

@AndroidEntryPoint
class DashboardFragment : SessionFragment(R.layout.fragment_dashboard) {

    val binding by viewBinding(FragmentDashboardBinding::bind)
    val viewModel: DashboardViewModel by viewModels()
    private lateinit var syncWorkRequest: OneTimeWorkRequest

    private var dialog: AlertDialog? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupViews()
        setupWorkRequests()
        observeUi()

    }

    private fun observeUi() {
        viewModel.dashboardUiState.observe(lifecycle, lifecycleScope) { dashboardUiState ->
            when (dashboardUiState) {
                is DashboardUiState.Success -> {
                    showSuccessUi(dashboardUiState.data)
                }

                is DashboardUiState.Error -> showErrorUi(
                    dashboardUiState.throwable,
                    ERROR_TYPE.TASK_ERROR,
                    ERROR_LVL.ERROR
                )

                DashboardUiState.Loading -> showLoadingUi()
            }
        }

        viewModel.progress.observe(lifecycle, lifecycleScope) { i ->
            binding.syncProgressBar.progress = i
        }

        WorkManager.getInstance(requireContext())
            .getWorkInfosForUniqueWorkLiveData(UNIQUE_SYNC_WORK_NAME)
            .observe(viewLifecycleOwner, { workInfos ->
                if (workInfos.size == 0) return@observe // Return if the workInfo List is empty
                val workInfo = workInfos[0] // Picking the first workInfo
                if (workInfo != null && workInfo.state == WorkInfo.State.SUCCEEDED) {
                    lifecycleScope.launch {
                        val warningMsg = workInfo.outputData.getString("warningMsg")
                        if (warningMsg != null) { // Check if there are any warning messages set by Workmanager
                            showErrorUi(
                                Throwable(warningMsg),
                                ERROR_TYPE.SYNC_ERROR,
                                ERROR_LVL.WARNING
                            )
                        }
                        viewModel.setProgress(100)
                        viewModel.refreshList()
                    }
                }
                if (workInfo != null && workInfo.state == WorkInfo.State.ENQUEUED) {
                    viewModel.setProgress(0)
                    viewModel.setLoading()
                }
                if (workInfo != null && workInfo.state == WorkInfo.State.RUNNING) {
                    // Check if the current work's state is "successfully finished"
                    val progress: Int = workInfo.progress.getInt("progress", 0)
                    viewModel.setProgress(progress)
                    viewModel.setLoading()
                    // refresh the UI to show microtasks
                    if (progress == 100)
                        viewLifecycleScope.launch {
                            viewModel.refreshList()
                        }
                }
                if (workInfo != null && workInfo.state == WorkInfo.State.FAILED) {
                    lifecycleScope.launch {
                        showErrorUi(
                            Throwable(workInfo.outputData.getString("errorMsg")),
                            ERROR_TYPE.SYNC_ERROR,
                            ERROR_LVL.ERROR
                        )
                        viewModel.refreshList()
                    }
                }
            })

    }

    override fun onSessionExpired() {
        WorkManager.getInstance(requireContext()).cancelAllWork()
        super.onSessionExpired()
    }

    override fun onResume() {
        super.onResume()
        viewModel.getAllTasks() // TODO: Remove onResume and get taskId from scenario viewmodel (similar to onActivity Result)
    }

    private fun setupWorkRequests() {
        // TODO: SHIFT IT FROM HERE
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        syncWorkRequest = OneTimeWorkRequestBuilder<DashboardSyncWorker>()
            .setConstraints(constraints)
            .build()
    }

    private fun setupViews() {

        with(binding) {
            tasksRv.apply {
                adapter = TaskListAdapter(emptyList(), ::onDashboardItemClick)
                layoutManager = LinearLayoutManager(context)
            }

            binding.syncCv.setOnClickListener { syncWithServer() }

            loadProfilePic()
//      loadPhone()
        }

    }


    private fun syncWithServer() {
        setupWorkRequests()
        WorkManager.getInstance(requireContext())
            .enqueueUniqueWork(UNIQUE_SYNC_WORK_NAME, ExistingWorkPolicy.KEEP, syncWorkRequest)
//    binding.syncDuration.text = "[Uploaded: "+viewModel.uploadedDataDuration+" tasks]"
    }

    private fun showSuccessUi(data: DashboardStateSuccess) {
        WorkManager.getInstance(requireContext()).getWorkInfoByIdLiveData(syncWorkRequest.id)
            .observe(viewLifecycleOwner, Observer { workInfo ->
                if (workInfo == null || workInfo.state == WorkInfo.State.SUCCEEDED || workInfo.state == WorkInfo.State.FAILED) {
                    hideLoading() // Only hide loading if no work is in queue
                }
            })
        binding.syncCv.enable()
        var videoTask = 0
        data.apply {
            (binding.tasksRv.adapter as TaskListAdapter).updateList(taskInfoData)

            // Get the count of sign video tasks
            for (task in taskInfoData) {
                if (task.scenarioName == ScenarioType.SIGN_LANGUAGE_VIDEO) {
                    videoTask += task.taskStatus.submittedMicrotasks + task.taskStatus.verifiedMicrotasks
                }
            }

            // Show total credits if it is greater than 0
            if (totalRecordedDuration.first > 0 || totalRecordedDuration.second > 0) {
                binding.rupeesEarnedCl.visible()
                binding.rupeesEarnedTv.text = String.format(
                    Locale.US,
                    "%02d:%02.0f",
                    (totalRecordedDuration.first / 60).toInt(),
                    totalRecordedDuration.first % 60
                )
//          "%.2f M".format(Locale.ENGLISH, totalRecordedDuration.first)
                binding.rupeesEarnedTv2.text = String.format(
                    Locale.US,
                    "%02d:%02.0f",
                    (totalRecordedDuration.second / 60).toInt(),
                    totalRecordedDuration.second % 60
                )
//          "%.2f M".format(Locale.ENGLISH, totalRecordedDuration.second)
//        binding.syncDurationOnPhone.text = "[On Phone: "+totalRecordedDuration.second.toString()+" tasks]"
                var completed = 0
                var submitted = 0
                for (task in taskInfoData) {
                    completed += task.taskStatus.completedMicrotasks
                    submitted += task.taskStatus.submittedMicrotasks + task.taskStatus.verifiedMicrotasks

                }
                completed += submitted
                binding.syncDurationOnPhone.text = "[On Phone: $completed  tasks]"
                binding.syncDuration.text = "[Submitted: $submitted tasks]"

            } else {
                binding.rupeesEarnedCl.gone()
            }


        }

        if (videoTask > 0) {
            runBlocking {
                val loggedInWorker = authManager.getLoggedInWorker()
                workerRepositoryBase.disableWorker(
                    loggedInWorker.idToken.toString(),
                    "disable",
                    RegisterOrUpdateWorkerRequest(loggedInWorker.extras!!)
                )
                    .catch { throwable -> Log.e("DISABLING FAILED", throwable.toString()) }
                    .collect { worker ->
                        workerRepositoryBase.upsertWorker(worker)
                        Toast.makeText(
                            context,
                            "You have been logged out, Thanks!.",
                            Toast.LENGTH_SHORT
                        ).show()
//              authManager.expireSession()
//              authManager.expireSession()
                    }
                workerRepositoryBase.upsertWorker(loggedInWorker)
            }
//        authManager.expireSession()
        }

        // expire the worker so that he is not able to submit any more tasks


        // Show a dialog box to sync with server if completed tasks and internet available
        if (requireContext().isNetworkAvailable()) {
            for (taskInfo in data.taskInfoData) {
//        if (taskInfo.scenarioName == ScenarioType.SPEECH_VERIFICATION){
//          binding.submitAreaDuration.invisible()
//        }
                if (taskInfo.taskStatus.completedMicrotasks > 0) {
                    showDialogueToSync()
                    return
                }
            }
        }

        // On seeing the person has done 1 or more video verification task, we disable the worker and use this task as proof of their work
    }

    private fun showDialogueToSync() {

        if (dialog != null && dialog!!.isShowing) return

        val builder: AlertDialog.Builder? = activity?.let {
            AlertDialog.Builder(it)
        }

        builder?.setMessage(R.string.sync_prompt_message)

        // Set buttons
        builder?.apply {
            setPositiveButton(
                R.string.yes
            ) { _, _ ->
                syncWithServer()
                dialog!!.dismiss()
            }
            setNegativeButton(R.string.no, null)
        }

        dialog = builder?.create()
        dialog!!.show()
    }

    private fun showErrorUi(throwable: Throwable, errorType: ERROR_TYPE, errorLvl: ERROR_LVL) {
        hideLoading()
        showError(throwable.message ?: "Some error Occurred", errorType, errorLvl)
        binding.syncCv.enable()
    }

    private fun showError(message: String, errorType: ERROR_TYPE, errorLvl: ERROR_LVL) {
        if (errorType == ERROR_TYPE.SYNC_ERROR) {
            WorkManager.getInstance(requireContext()).cancelAllWork()
            with(binding) {
                syncErrorMessageTv.text = message

                when (errorLvl) {
                    ERROR_LVL.ERROR -> syncErrorMessageTv.setTextColor(Color.RED)
                    ERROR_LVL.WARNING -> syncErrorMessageTv.setTextColor(Color.YELLOW)
                }
                syncErrorMessageTv.visible()
            }
        }
    }

    private fun showLoadingUi() {
        showLoading()
        binding.syncCv.disable()
        binding.syncErrorMessageTv.gone()
    }

    private fun showLoading() = binding.syncProgressBar.visible()

    private fun hideLoading() = binding.syncProgressBar.gone()

    //  private fun loadPhone(){
//    lifecycleScope.launchWhenStarted {
//      withContext(Dispatchers.IO) {
//        binding.appTb.setTitle("Dashboard | ${authManager.getLoggedInWorker().accessCode.toString()}")
//      }
//    }
//  }
    private fun loadProfilePic() {
        binding.appTb.showProfilePicture()

        lifecycleScope.launchWhenStarted {
            withContext(Dispatchers.IO) {
                val profilePicPath =
                    authManager.getLoggedInWorker().profilePicturePath ?: return@withContext
                val bitmap = BitmapFactory.decodeFile(profilePicPath)

                withContext(Dispatchers.Main.immediate) { binding.appTb.setProfilePicture(bitmap) }
            }
        }
    }

    private fun onDashboardItemClick(task: TaskInfo) {
        if (!task.isGradeCard && (task.taskStatus.assignedMicrotasks + task.taskStatus.skippedMicrotasks) > 0) {
            val taskId = task.taskID
            val status = task.taskStatus
            val completed =
                status.completedMicrotasks + status.submittedMicrotasks + status.verifiedMicrotasks
            val total = status.assignedMicrotasks + completed
            val action = with(DashboardFragmentDirections) {
                when (task.scenarioName) {
                    ScenarioType.SPEECH_DATA -> actionDashboardActivityToSpeechDataMainFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.XLITERATION_DATA -> actionDashboardActivityToUniversalTransliterationMainFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SPEECH_VERIFICATION -> actionDashboardActivityToSpeechVerificationFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.IMAGE_TRANSCRIPTION -> actionDashboardActivityToImageTranscription(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.IMAGE_LABELLING -> actionDashboardActivityToImageLabelling(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.IMAGE_ANNOTATION -> actionDashboardActivityToImageAnnotationFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.QUIZ -> actionDashboardActivityToQuiz(taskId, completed, total)
                    ScenarioType.IMAGE_DATA -> actionDashboardActivityToImageData(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SENTENCE_VALIDATION -> actionDashboardActivityToSentenceValidation(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SPEECH_TRANSCRIPTION -> actionDashboardActivityToSpeechTranscriptionFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SENTENCE_CORPUS -> actionDashboardActivityToSentenceCorpusFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SIGN_LANGUAGE_VIDEO -> DashboardFragmentDirections.actionDashboardActivityToSignVideo(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SGN_LANG_VIDEO_VERIFICATION -> DashboardFragmentDirections.actionDashboardActivityToSignVideoVerification(
                        taskId,
                        completed,
                        total
                    )

                    else -> null
                }
            }
//      if (action == null && BuildConfig.FLAVOR == "large") {
//        action = when (task.scenarioName) {
//          ScenarioType.SIGN_LANGUAGE_VIDEO -> DashboardFragmentDirections.actionDashboardActivityToSignVideo(
//            taskId,
//            completed,
//            total
//          )
//          ScenarioType.SGN_LANG_VIDEO_VERIFICATION -> DashboardFragmentDirections.actionDashboardActivityToSignVideoVerification(
//            taskId,
//            completed,
//            total
//          )
//          else -> null
//        }
//      }
            if (action != null) {
                if (task.taskInstruction == null) {
                    findNavController().navigate(action)
                } else {
                    val builder = AlertDialog.Builder(requireContext())
                    val message = task.taskInstruction
                    builder.setMessage(message)
                    println("NEW CAMERA $action")
                    builder.setNeutralButton(R.string.okay) { _, _ ->
                        findNavController().navigate(action)
                    }
                    val dialog = builder.create()
                    dialog.show()
                }
            }
        }
    }
}
