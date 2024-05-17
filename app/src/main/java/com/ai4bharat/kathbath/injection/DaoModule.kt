package com.ai4bharat.kathbath.injection

import com.ai4bharat.kathbath.data.local.daos.*
import com.ai4bharat.kathbath.data.local.daosExtra.MicrotaskAssignmentDaoExtra
import com.ai4bharat.kathbath.data.local.daosExtra.MicrotaskDaoExtra
import com.ai4bharat.kathbath.data.manager.KaryaDatabase
import dagger.Module
import dagger.Provides
import dagger.Reusable
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
class DaoModule {

  @Provides
  @Reusable
  fun provideWorkerDao(karyaDatabase: KaryaDatabase): WorkerDao {
    return karyaDatabase.workerDao()
  }

  @Provides
  @Reusable
  fun provideTaskDao(karyaDatabase: KaryaDatabase): TaskDao {
    return karyaDatabase.taskDao()
  }

  @Provides
  @Reusable
  fun provideMicroTaskDao(karyaDatabase: KaryaDatabase): MicroTaskDao {
    return karyaDatabase.microTaskDao()
  }

  @Provides
  @Reusable
  fun provideMicroTaskAssignmentDao(karyaDatabase: KaryaDatabase): MicroTaskAssignmentDao {
    return karyaDatabase.microtaskAssignmentDao()
  }

  @Provides
  @Reusable
  fun provideKaryaFileDao(karyaDatabase: KaryaDatabase): KaryaFileDao {
    return karyaDatabase.karyaFileDao()
  }

  @Provides
  @Reusable
  fun provideMicroTaskAssignmentDaoExtra(karyaDatabase: KaryaDatabase): MicrotaskAssignmentDaoExtra {
    return karyaDatabase.microtaskAssignmentDaoExtra()
  }

  @Provides
  @Reusable
  fun provideMicroTaskDaoExtra(karyaDatabase: KaryaDatabase): MicrotaskDaoExtra {
    return karyaDatabase.microtaskDaoExtra()
  }
}
