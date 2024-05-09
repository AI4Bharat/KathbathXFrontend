package com.ai4bharat.karyatts.data.repo

import com.ai4bharat.karyatts.data.local.daos.MicroTaskAssignmentDao
import com.ai4bharat.karyatts.data.local.daos.TaskDao
import com.ai4bharat.karyatts.data.model.karya.TaskRecord
import com.ai4bharat.karyatts.data.model.karya.enums.MicrotaskAssignmentStatus
import com.ai4bharat.karyatts.data.model.karya.enums.ScenarioType
import com.ai4bharat.karyatts.data.model.karya.modelsExtra.TaskStatus
import com.google.gson.JsonParser
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class TaskRepository
@Inject
constructor(
  private val taskDao: TaskDao,
  private val microTaskAssignmentDao: MicroTaskAssignmentDao,
) {
  suspend fun getById(taskId: String): TaskRecord {
    return taskDao.getById(taskId)
  }

  fun getAllTasksFlow(): Flow<List<TaskRecord>> = taskDao.getAllAsFlow()

  suspend fun getTaskStatus(taskId: String): TaskStatus {
    val available =
      microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.ASSIGNED)
    val completed =
      microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.COMPLETED)
    val submitted =
      microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.SUBMITTED)
    val verified =
      microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.VERIFIED)
    val skipped = microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.SKIPPED)
    val expired = microTaskAssignmentDao.getCountForTask(taskId, MicrotaskAssignmentStatus.EXPIRED)
    var pp = microTaskAssignmentDao.getDurationForCompletedTask(taskId,MicrotaskAssignmentStatus.COMPLETED,MicrotaskAssignmentStatus.SUBMITTED,MicrotaskAssignmentStatus.VERIFIED)
    var totalDuration:Float = 0.0F
    if (getById(taskId).scenario_name == ScenarioType.SPEECH_DATA)
    for (i in pp){
      val jp = JsonParser.parseString(i).asJsonObject
      totalDuration += jp.get("data").asJsonObject.get("duration").asFloat
//      Log.e("TADA",jp.get("data").asJsonObject.get("duration").asFloat.toString())
    }
//
    return TaskStatus(available, completed, submitted, verified, skipped, expired,totalDuration)
  }

}
