package com.ai4bharat.karyatts

import android.app.Application
import androidx.work.Configuration
import com.ai4bharat.karyatts.data.manager.SyncDelegatingWorkerFactory
import dagger.hilt.android.HiltAndroidApp
import javax.inject.Inject

@HiltAndroidApp
class KaryaApp : Application(), Configuration.Provider {

  @Inject
  lateinit var workerFactory: SyncDelegatingWorkerFactory

  override fun getWorkManagerConfiguration(): Configuration =
    Configuration.Builder()
      .setMinimumLoggingLevel(android.util.Log.DEBUG)
      .setWorkerFactory(workerFactory)
      .build()
}
