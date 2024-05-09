// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

package com.ai4bharat.karyatts.data.manager

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.ai4bharat.karyatts.data.local.Converters
import com.ai4bharat.karyatts.data.local.daos.*
import com.ai4bharat.karyatts.data.local.daosExtra.MicrotaskAssignmentDaoExtra
import com.ai4bharat.karyatts.data.local.daosExtra.MicrotaskDaoExtra
import com.ai4bharat.karyatts.data.model.karya.*

@Database(
  entities =
  [
    WorkerRecord::class,
    KaryaFileRecord::class,
    TaskRecord::class,
    MicroTaskRecord::class,
    MicroTaskAssignmentRecord::class,
  ],
  version = 1,
  //  autoMigrations = [
  //    AutoMigration (from = 1, to = 2)
  //  ]
)
@TypeConverters(Converters::class)
abstract class KaryaDatabase : RoomDatabase() {
  abstract fun microTaskDao(): MicroTaskDao
  abstract fun taskDao(): TaskDao
  abstract fun workerDao(): WorkerDao
  abstract fun microtaskAssignmentDao(): MicroTaskAssignmentDao

  abstract fun microtaskAssignmentDaoExtra(): MicrotaskAssignmentDaoExtra
  abstract fun microtaskDaoExtra(): MicrotaskDaoExtra
  abstract fun karyaFileDao(): KaryaFileDao

  companion object {
    private var INSTANCE: KaryaDatabase? = null

    fun getInstance(context: Context): KaryaDatabase? {
      if (INSTANCE == null) {
        synchronized(KaryaDatabase::class) {
          INSTANCE =
            Room.databaseBuilder(context.applicationContext, KaryaDatabase::class.java, "karyatts.db")
              .build()
        }
      }
      return INSTANCE
    }
  }
}
