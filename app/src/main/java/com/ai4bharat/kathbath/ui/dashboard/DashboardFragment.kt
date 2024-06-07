package com.ai4bharat.kathbath.ui.dashboard

import android.app.AlertDialog
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import android.graphics.Color
import android.os.Bundle
import android.view.View
import androidx.activity.OnBackPressedCallback
import androidx.core.content.edit
import androidx.fragment.app.viewModels
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.viewModelScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.work.*
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.enums.ScenarioType
import com.ai4bharat.kathbath.data.model.karya.modelsExtra.TaskInfo
import com.ai4bharat.kathbath.databinding.FragmentDashboardBinding
import com.ai4bharat.kathbath.ui.base.SessionFragment
import com.ai4bharat.kathbath.utils.extensions.*
import com.ai4bharat.kathbath.data.manager.KaryaDatabase
import com.ai4bharat.kathbath.data.manager.SharedPreferenceManager
import com.ai4bharat.kathbath.utils.LanguageUtils
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*

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
    private var sharedPreferenceManager: SharedPreferenceManager? = null

    private var dialog: AlertDialog? = null


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupViews()
        setupWorkRequests()
        observeUi()

    }

    override fun onAttach(context: Context) {
        super.onAttach(context)

        val callback = object : OnBackPressedCallback(
            true
        ) {
            override fun handleOnBackPressed() {
                finish()
            }
        }

        sharedPreferenceManager = SharedPreferenceManager(context)
        requireActivity().onBackPressedDispatcher.addCallback(this, callback)
    }


    private fun observeUi() {
        viewModel.dashboardUiState.observe(lifecycle, lifecycleScope) { dashboardUiState ->
            when (dashboardUiState) {
                is DashboardUiState.Success -> {
                    println("The current available status iss ${dashboardUiState.data}")
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

        viewModel.viewModelScope.launch {
            viewModel.getWorkerDetails()
        }

        WorkManager.getInstance(requireContext())
            .getWorkInfosForUniqueWorkLiveData(UNIQUE_SYNC_WORK_NAME)
            .observe(viewLifecycleOwner) { workInfos ->
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
            }

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

            binding.syncPromptTv.setOnClickListener(View.OnClickListener {
                syncWithServer()
            })

            logoutView.setOnClickListener(View.OnClickListener {
                showLogoutDialog()

            })

            shareAppButton.setOnClickListener(View.OnClickListener {
//                viewModel.shownReferralDialog = true
//                setShowReferral()
                val referralDialog = ReferralDialog(requireContext(), viewModel.workerDetails)
                referralDialog.show()
            })


        }
    }

    private fun showLogoutDialog() {

        val logoutAlertDialogBuilder: AlertDialog.Builder =
            AlertDialog.Builder(requireContext(), R.style.CustomAlertDialog)
        logoutAlertDialogBuilder.setTitle("Confirm Log Out")
        logoutAlertDialogBuilder.setMessage("Make sure you submit all the recorded data before logging out.")
        logoutAlertDialogBuilder.setPositiveButton("Log out") { _, _ ->
            clearAllDataAndLogout()
        }
        logoutAlertDialogBuilder.setNegativeButton("Cancel") { dialog, _ -> dialog.dismiss() }
        logoutAlertDialogBuilder.show()
    }

    private fun clearAllDataAndLogout() {
        lifecycleScope.launch {
            withContext(Dispatchers.IO) {
                KaryaDatabase.getInstance(requireContext())?.clearAllTables()
                authManager.expireSession()
            }
        }
        sharedPreferenceManager?.clearAllValue()
        findNavController().navigate(R.id.action_dashboardActivity_to_login)
    }

    private fun syncWithServer() {
        setupWorkRequests()
        WorkManager.getInstance(requireContext())
            .enqueueUniqueWork(UNIQUE_SYNC_WORK_NAME, ExistingWorkPolicy.KEEP, syncWorkRequest)
    }

    private fun showReferralDialog(completed: Int, submitted: Int, assigned: Int) {
        val referralDialogShown = sharedPreferenceManager!!.getBooleanValue("referralDialogShown")
        println("COMPLETED AND SUBMITTED $referralDialogShown")
        if (completed > 0 && submitted > 0 && assigned == 0 && completed == submitted
            && !referralDialogShown
        ) {
            val referralDialog = ReferralDialog(requireContext(), viewModel.workerDetails)
            referralDialog.show()
            sharedPreferenceManager!!.setBooleanValue("referralDialogShown", true)
        }
    }

    private fun showSuccessUi(data: DashboardStateSuccess) {
        WorkManager.getInstance(requireContext()).getWorkInfoByIdLiveData(syncWorkRequest.id)
            .observe(viewLifecycleOwner, Observer { workInfo ->
                if (workInfo == null || workInfo.state == WorkInfo.State.SUCCEEDED || workInfo.state == WorkInfo.State.FAILED) {
                    hideLoading() // Only hide loading if no work is in queue
                }
                println("The job was done ${data.taskInfoData}")
            })
        binding.syncCv.enable()
        data.apply {
            (binding.tasksRv.adapter as TaskListAdapter).updateList(taskInfoData)

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
                var assigned = 0
                for (task in taskInfoData) {
                    completed += task.taskStatus.completedMicrotasks
                    submitted += task.taskStatus.submittedMicrotasks + task.taskStatus.verifiedMicrotasks
                    assigned += task.taskStatus.assignedMicrotasks

                }
                completed += submitted
                showReferralDialog(completed, submitted, assigned)

                println("COMPLETED AND SUBMITTED is $completed $submitted $assigned IS")
                binding.syncDurationOnPhone.text = "[On Phone: $completed  Tasks]"
                binding.syncDuration.text = "[Uploaded: $submitted Tasks]"

            } else {
                binding.rupeesEarnedCl.gone()
            }

        }

        // Show a dialog box to sync with server if completed tasks and internet available
        if (requireContext().isNetworkAvailable()) {
            for (taskInfo in data.taskInfoData) {
                if (taskInfo.taskStatus.completedMicrotasks > 0) {
                    showDialogueToSync()
                    return
                }
            }
        }

    }

    private fun showDialogueToSync() {

        if (dialog != null && dialog!!.isShowing) return

        val builder: AlertDialog.Builder? = activity?.let {
            AlertDialog.Builder(it, R.style.AlertDialogStyle)
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

    private fun onDashboardItemClick(task: TaskInfo) {

        if (!task.isGradeCard && (task.taskStatus.assignedMicrotasks + task.taskStatus.skippedMicrotasks) > 0) {
            val taskId = task.taskID
            val status = task.taskStatus
            val completed =
                status.completedMicrotasks + status.submittedMicrotasks + status.verifiedMicrotasks
            val total = status.assignedMicrotasks + completed
            var action = with(DashboardFragmentDirections) {
                when (task.scenarioName) {
                    ScenarioType.SPEECH_DATA -> actionDashboardActivityToSpeechDataMainFragment(
                        taskId,
                        completed,
                        total
                    )

                    ScenarioType.SPEECH_VERIFICATION -> actionDashboardActivityToSpeechVerificationFragment(
                        taskId,
                        completed,
                        total
                    )

                    else -> null
                }
            }

            if (action != null) {
                if (task.taskInstruction == null) {
                    findNavController().navigate(action)
                } else {

                    val builder = AlertDialog.Builder(requireContext(), R.style.AlertDialogStyle)
                    var message = task.taskInstruction
                    if (message == "-") {
                        message = getInstruction()
                    }
                    builder.setMessage(message)
                    builder.setNeutralButton(R.string.okay) { _, _ ->
                        findNavController().navigate(action)
                    }
                    val dialog = builder.create()
                    dialog.show()
                }
            }
        }
    }

    private fun getInstruction(): String {
        val workerDetails = viewModel.workerDetails
        if (workerDetails != null) {
            val languageCode = workerDetails.language
            val language = LanguageUtils.getLanguageFromCode(languageCode)
            if (language == "") {
                return "Please speak in your native language"
            }
            return "Please speak in $language"
        }
        return "Please speak in your native language"
    }
}
