package com.ai4bharat.karyatts.data.model.karya.modelsExtra

data class TaskStatus(
  val assignedMicrotasks: Int,
  val completedMicrotasks: Int,
  val submittedMicrotasks: Int,
  val verifiedMicrotasks: Int,
  val skippedMicrotasks: Int,
  val expiredMicrotasks: Int,
  val totalDuration: Float
)
