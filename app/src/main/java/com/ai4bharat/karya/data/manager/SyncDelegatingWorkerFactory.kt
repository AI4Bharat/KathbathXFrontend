package com.ai4bharat.karya.data.manager

import androidx.work.DelegatingWorkerFactory
import com.ai4bharat.karya.data.repo.AssignmentRepository
import com.ai4bharat.karya.data.repo.KaryaFileRepository
import com.ai4bharat.karya.data.repo.MicroTaskRepository
import com.ai4bharat.karya.injection.qualifier.FilesDir
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
