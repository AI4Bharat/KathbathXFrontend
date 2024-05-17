package com.ai4bharat.kathbath.injection

import com.ai4bharat.kathbath.data.manager.AuthManager
import com.ai4bharat.kathbath.data.manager.SyncDelegatingWorkerFactory
import com.ai4bharat.kathbath.data.repo.AssignmentRepository
import com.ai4bharat.kathbath.data.repo.KaryaFileRepository
import com.ai4bharat.kathbath.data.repo.MicroTaskRepository
import com.ai4bharat.kathbath.injection.qualifier.FilesDir
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
class WorkerFactoryModule {

  @Provides
  @Singleton
  fun providesNgWorkerFactory(
    assignmentRepository: AssignmentRepository,
    karyaFileRepository: KaryaFileRepository,
    microTaskRepository: MicroTaskRepository,
    @FilesDir fileDirPath: String,
    authManager: AuthManager,
  ): SyncDelegatingWorkerFactory {
    val workerFactory = SyncDelegatingWorkerFactory(
      assignmentRepository,
      karyaFileRepository,
      microTaskRepository,
      fileDirPath,
      authManager
    )

    return workerFactory
  }
}
