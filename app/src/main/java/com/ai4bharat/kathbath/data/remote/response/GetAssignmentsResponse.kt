package com.ai4bharat.kathbath.data.remote.response

import com.google.gson.annotations.SerializedName
import com.ai4bharat.kathbath.data.model.karya.MicroTaskAssignmentRecord
import com.ai4bharat.kathbath.data.model.karya.MicroTaskRecord
import com.ai4bharat.kathbath.data.model.karya.TaskRecord

data class GetAssignmentsResponse(
  @SerializedName("tasks") val tasks: List<TaskRecord>,
  @SerializedName("microtasks") val microTasks: List<MicroTaskRecord>,
  @SerializedName("assignments") val assignments: List<MicroTaskAssignmentRecord>
)
