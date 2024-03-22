package com.ai4bharat.karya.ui.dashboard

import com.ai4bharat.karya.data.model.karya.modelsExtra.TaskInfo

sealed class DashboardUiState {
  data class Success(val data: DashboardStateSuccess) : DashboardUiState()
  data class Error(val throwable: Throwable) : DashboardUiState()
  object Loading : DashboardUiState()
}

//data class DashboardStateSuccess(val taskInfoData: List<TaskInfo>, val totalCreditsEarned: Float)
data class DashboardStateSuccess(val taskInfoData: List<TaskInfo>, val totalRecordedDuration: Pair<Float,Float>)
