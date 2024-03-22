package com.ai4bharat.karya.injection

import com.ai4bharat.karya.data.local.daos.KaryaFileDao
import com.ai4bharat.karya.data.local.daos.MicroTaskDao
import com.ai4bharat.karya.data.local.daos.WorkerDao
import com.ai4bharat.karya.data.local.daosExtra.MicrotaskDaoExtra
import com.ai4bharat.karya.data.repo.*
import com.ai4bharat.karya.data.service.LanguageAPI
import com.ai4bharat.karya.data.service.WorkerAPI
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
class RepositoryModule {

  @Provides
  @Singleton
  fun provideLanguageRepository(languageAPI: LanguageAPI): LanguageRepository {
    return LanguageRepository(languageAPI)
  }

  @Provides
  @Singleton
  fun provideMicroTaskRepository(
    microTaskDao: MicroTaskDao,
    microtaskDaoExtra: MicrotaskDaoExtra
  ): MicroTaskRepository {
    return MicroTaskRepository(microTaskDao, microtaskDaoExtra)
  }

  @Provides
  @Singleton
  fun provideWorkerRepository(workerAPI: WorkerAPI, workerDao: WorkerDao): WorkerRepository {
    return WorkerRepository(workerAPI, workerDao)
  }

  @Provides
  @Singleton
  fun provideKaryaFileRepository(karyaFileDao: KaryaFileDao): KaryaFileRepository {
    return KaryaFileRepository(karyaFileDao)
  }

  @Provides
  @Singleton
  fun provideAuthRepository(workerDao: WorkerDao): AuthRepository {
    return AuthRepository(workerDao)
  }
}
