// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

package com.ai4bharat.karyatts.data.model.karya.modelsExtra

import com.ai4bharat.karyatts.data.model.karya.enums.ScenarioType

data class TaskInfo(
  val taskID: String,
  val taskName: String,
  val taskInstruction: String?,
  val scenarioName: ScenarioType,
  val taskStatus: TaskStatus,
  val isGradeCard: Boolean,
  // Hack
  val speechDataReport: SpeechDataReport?
)
