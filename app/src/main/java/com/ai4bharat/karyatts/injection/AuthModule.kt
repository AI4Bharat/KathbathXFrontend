package com.ai4bharat.karyatts.injection

import android.content.Context
import com.ai4bharat.karyatts.data.manager.AuthManager
import com.ai4bharat.karyatts.data.repo.AuthRepository
import com.ai4bharat.karyatts.injection.qualifier.IoDispatcher
import dagger.Module
import dagger.Provides
import dagger.Reusable
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
class AuthModule {

  @Provides
  @Reusable
  @IoDispatcher
  fun providesAndroidIODispatcher(): CoroutineDispatcher {
    return Dispatchers.IO
  }

  @Provides
  @Singleton
  fun providesAuthManager(
    @ApplicationContext context: Context,
    @IoDispatcher dispatcher: CoroutineDispatcher,
    authRepository: AuthRepository,
  ): AuthManager {
    return AuthManager(context, authRepository, dispatcher)
  }
}
