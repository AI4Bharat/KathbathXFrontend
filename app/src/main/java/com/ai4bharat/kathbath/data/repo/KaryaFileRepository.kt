package com.ai4bharat.kathbath.data.repo

import com.ai4bharat.kathbath.data.local.daos.KaryaFileDao
import com.ai4bharat.kathbath.data.model.karya.KaryaFileRecord
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import javax.inject.Inject

class KaryaFileRepository
@Inject
constructor(private val karyaFileDao: KaryaFileDao) {
    suspend fun insertKaryaFile(karyaFileRecord: KaryaFileRecord) {
        withContext(Dispatchers.IO) {
            try {
                karyaFileDao.insert(karyaFileRecord)
            } catch (e: Exception) {
                karyaFileDao.upsert(karyaFileRecord)
            }
        }
    }

    fun getKaryaFileData(idToken: String, accessCode: String, fileId: String) {

    }

}
