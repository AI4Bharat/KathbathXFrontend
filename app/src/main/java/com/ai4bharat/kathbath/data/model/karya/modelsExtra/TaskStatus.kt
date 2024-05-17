package com.ai4bharat.kathbath.data.model.karya.modelsExtra

data class TaskStatus(
  val assignedMicrotasks: Int,
  val completedMicrotasks: Int,
  val submittedMicrotasks: Int,
  val verifiedMicrotasks: Int,
  val skippedMicrotasks: Int,
  val expiredMicrotasks: Int,
  val totalDuration: Float
)
