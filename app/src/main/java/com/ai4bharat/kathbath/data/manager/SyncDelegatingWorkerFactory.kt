package com.ai4bharat.kathbath.data.manager

import androidx.work.DelegatingWorkerFactory
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.KaryaFileRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import javax.inject.Inject

class SyncDelegatingWorkerFactory @Inject
constructor(
  assignmentRepository: AssignmentRepository,
  karyaFileRepository: KaryaFileRepository,
  microTaskRepository: MicroTaskRepository,
  @FilesDir private val fileDirPath: String,
  authManager: AuthManager,
) : DelegatingWorkerFactory() {
  init {
    addFactory(
      WorkerFactory(
        assignmentRepository,
        karyaFileRepository,
        microTaskRepository,
        fileDirPath,
        authManager
      )
    )
    // Add here other factories that you may need in your application
  }
}
