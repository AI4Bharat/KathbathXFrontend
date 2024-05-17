package com.ai4bharat.kathbath.ui.dashboard

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.ai4bharat.kathbath.data.model.karya.modelsExtra.TaskInfo
import com.ai4bharat.kathbath.databinding.ItemTaskBinding
import com.ai4bharat.kathbath.data.model.karya.enums.ScenarioType
import com.ai4bharat.kathbath.utils.extensions.gone
import com.ai4bharat.kathbath.utils.extensions.visible

class TaskListAdapter(
    private var tasks: List<TaskInfo>,
    private val dashboardItemClick: (task: TaskInfo) -> Unit = {},
) : RecyclerView.Adapter<TaskListAdapter.NgTaskViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): NgTaskViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val binding = ItemTaskBinding.inflate(layoutInflater, parent, false)

        return NgTaskViewHolder(binding, dashboardItemClick)
    }

    override fun onBindViewHolder(holder: NgTaskViewHolder, position: Int) {
        holder.bind(tasks[position])
    }

    override fun getItemCount(): Int {
        return tasks.size
    }

    fun addTasks(newTasks: List<TaskInfo>) {
        val oldTaskCount = tasks.size
        val tempList = mutableListOf<TaskInfo>()
        tempList.addAll(tasks)
        tempList.addAll(newTasks)

        tasks = tempList
        notifyItemRangeInserted(oldTaskCount, newTasks.size)
    }

    fun updateList(newList: List<TaskInfo>) {
        tasks = newList
        notifyDataSetChanged()
    }

    class NgTaskViewHolder(
        private val binding: ItemTaskBinding,
        private val dashboardItemClick: (task: TaskInfo) -> Unit,
    ) : RecyclerView.ViewHolder(binding.root) {

        fun bind(taskInfo: TaskInfo) {
            val status = taskInfo.taskStatus
            val verified = status.verifiedMicrotasks
            val submitted = status.submittedMicrotasks + verified
            val completed = status.completedMicrotasks + submitted
            val assigned = status.assignedMicrotasks
            val skipped = status.skippedMicrotasks
            val expired = status.expiredMicrotasks

            val totalDuration = String.format("%.2f", (status.totalDuration / 60))
            val clickable = (assigned + skipped) > 0

            with(binding) {
                // Set text
                taskNameTv.text = taskInfo.taskName
                numIncompleteTv.text = assigned.toString()
//        numCompletedTv.text = "["+ totalDuration+" M] "+completed.toString()
                numCompletedTv.text = completed.toString()

                numSubmittedTv.text = submitted.toString()
                numVerifiedTv.text = verified.toString()
                numSkippedTv.text = skipped.toString()
                numExpiredTv.text = expired.toString()

                // Set views
                completedTasksPb.max = assigned + completed
                completedTasksPb.progress = completed

                // Set speech data report
                val report = taskInfo.speechDataReport
                if (taskInfo.scenarioName == ScenarioType.SPEECH_DATA && report != null) {
                    scoreGroup.visible()
//          accuracyScore.rating = report.accuracy
//          volumeScore.rating = report.volume
//          qualityScore.rating = report.quality
                } else {
                    scoreGroup.gone()
                }

                // Task click listener
                taskLl.setOnClickListener { dashboardItemClick(taskInfo) }
                taskLl.isClickable = clickable
                taskLl.isEnabled = clickable
//                taskLl.setBackgroundColor(Color.parseColor("#C0FFB9"))
//                if (taskInfo.scenarioName == ScenarioType.SIGN_LANGUAGE_VIDEO) {
//                    taskLl.setBackgroundColor(Color.parseColor("#ff8945"))
//                }
//        if (taskInfo.taskName.contains("hindi",true)){
//          taskLl.setBackgroundColor(Color.parseColor("#FFBCBC"))
//        }
//        else if (taskInfo.taskName.contains("english",true)){
//          taskLl.setBackgroundColor(Color.parseColor("#87C8FF"))
//        }
//        else{
//          taskLl.setBackgroundColor(Color.parseColor("#C0FFB9"))
//
//        }
            }
        }
    }
}
