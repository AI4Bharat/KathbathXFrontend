package com.ai4bharat.karyatts.injection

import android.content.Context
import androidx.room.Room
import com.ai4bharat.karyatts.data.manager.KaryaDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
class DatabaseModule {

  @Provides
  @Singleton
  fun providesKaryaDatabase(@ApplicationContext context: Context): KaryaDatabase {
    return Room.databaseBuilder(context, KaryaDatabase::class.java, "karyatts.db").build()
  }
}
