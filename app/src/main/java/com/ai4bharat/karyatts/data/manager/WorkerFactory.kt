package com.ai4bharat.karyatts.data.manager

import android.content.Context
import androidx.work.ListenableWorker
import androidx.work.WorkerFactory
import androidx.work.WorkerParameters
import com.ai4bharat.karyatts.data.repo.AssignmentRepository
import com.ai4bharat.karyatts.data.repo.KaryaFileRepository
import com.ai4bharat.karyatts.data.repo.MicroTaskRepository
import com.ai4bharat.karyatts.injection.qualifier.FilesDir
import com.ai4bharat.karyatts.ui.dashboard.DashboardSyncWorker

class WorkerFactory(
  private val assignmentRepository: AssignmentRepository,
  private val karyaFileRepository: KaryaFileRepository,
  private val microTaskRepository: MicroTaskRepository,
  @FilesDir private val fileDirPath: String,
  private val authManager: AuthManager,
) : WorkerFactory() {

  override fun createWorker(
    appContext: Context,
    workerClassName: String,
    workerParameters: WorkerParameters
  ): ListenableWorker? {

    return when (workerClassName) {
      DashboardSyncWorker::class.java.name ->
        DashboardSyncWorker(
          appContext,
          workerParameters,
          assignmentRepository,
          karyaFileRepository,
          microTaskRepository,
          fileDirPath,
          authManager
        )
      else ->
        // Return null, so that the base class can delegate to the default WorkerFactory.
        null
    }

  }
}
