package com.ai4bharat.karya.data.repo

import android.util.Log
import com.ai4bharat.karya.BuildConfig
import com.ai4bharat.karya.data.exceptions.*
import com.ai4bharat.karya.data.local.daos.WorkerDao
import com.ai4bharat.karya.data.model.karya.WorkerRecord
import com.ai4bharat.karya.data.remote.request.RegisterOrUpdateWorkerRequest
import com.ai4bharat.karya.data.service.WorkerAPI
import com.ai4bharat.karya.ui.crowdsource.login.Status
import com.ai4bharat.karya.ui.crowdsource.registration.CrowdSourceUser
import com.ai4bharat.karya.ui.crowdsource.registration.RegistrationStatus
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext
import javax.inject.Inject

class WorkerRepository @Inject constructor(
    private val workerAPI: WorkerAPI,
    private val workerDao: WorkerDao
) {

    fun getOTP(
        accessCode: String,
        phoneNumber: String,
    ) = flow {
        println("Here get otp")
        val response = workerAPI.generateOTP(accessCode, phoneNumber)
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            throw when (response.code()) {
                401 -> InvalidAccessCodeException()
                403 -> AccessCodeAlreadyUsedException()
                503 -> UnableToGenerateOTPException()
                else -> KaryaException()
            }
        }

        if (workerRecord == null) {
            error("Request failed, response body was null")
        }

        // emit unit at the end to indicate success
        // TODO: think if we should use suspend fun instead of a flow
        emit(Unit)
    }

    fun resendOTP(
        accessCode: String,
        phoneNumber: String,
    ) = flow {
        val response = workerAPI.resendOTP(accessCode, phoneNumber)
        val workerRecord = response.body()
        if (!response.isSuccessful) {
            throw when (response.code()) {
                403 -> AccessCodeAlreadyUsedException()
                401 -> InvalidAccessCodeException()
                503 -> UnableToGenerateOTPException()
                else -> KaryaException()
            }
        }

        if (workerRecord == null) {
            error("Request failed, response body was null")
        }

        emit(Unit)
    }

    fun verifyOTP(
        accessCode: String,
        phoneNumber: String,
        otp: String,
    ) = flow {
        println("Here verify otp")
        val response = workerAPI.verifyOTP(accessCode, phoneNumber, otp)
        print("inside verifyOTP ${response.body()}")
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            throw when (response.code()) {
                403 -> AccessCodeAlreadyUsedException()
                401 -> InvalidOTPException()
                else -> KaryaException()
            }
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }

    fun verifyAccessCode(accessCode: String) = flow {
        val response = workerAPI.getWorkerUsingAccessCode(accessCode)
        val responseBody = response.body()
        println("Details are $responseBody")

        if (!response.isSuccessful) {
            error("Request failed, response code: ${response.code()}")
        }

        if (responseBody != null) {
            emit(responseBody)
        } else {
            error("Request failed, response body was null")
        }
    }

    fun createNewWorker(worker: CrowdSourceUser) = flow {
        println("Registration started inside create new worker")
        val response = workerAPI.createNewWorker(worker)

        var msg = ""
        var status = Status.INITIAL
        println("createNewWorker: ${response.body()?.accessCode}")
        if (!response.isSuccessful) {
            status = Status.FAILED
            println("The response is $response")
            msg = when (response.code()) {
                409 -> {
                    "Account with same number and language already exist"
                }

                422 -> {
                    "Invalid entry"
                }

                else -> {
                    "Registration failed"
                }
            }
        } else {
            msg = response.body()?.accessCode.toString()
            status = Status.SUCCESS
        }
        emit(RegistrationStatus(status, msg))
    }

    fun getWorkerUsingIdToken(
        idToken: String,
    ) = flow {
        val response = workerAPI.getWorkerUsingIdToken(idToken)
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            error("Request failed, response code: ${response.code()}")
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }

    fun getWorkerFromBox(
        access_code: String,
    ) = flow {
        val response = workerAPI.getWorkerUsingAccessCode(access_code)
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            error("Request failed, response code: ${response.code()}")
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }


    fun updateWorker(
        idToken: String,
        accessCode: String,
        registerOrUpdateWorkerRequest: RegisterOrUpdateWorkerRequest,
    ) = flow {
        val response = workerAPI.updateWorker(idToken, registerOrUpdateWorkerRequest, "update")
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            throw when (response.code()) {
                401 -> InvalidAccessCodeException()
                else -> KaryaException()
            }
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }

    fun disableWorker(
        idToken: String,
        accessCode: String,
        registerOrUpdateWorkerRequest: RegisterOrUpdateWorkerRequest,
    ) = flow {
        val response = workerAPI.updateWorker(idToken, registerOrUpdateWorkerRequest, "disable")
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            throw when (response.code()) {
                401 -> InvalidAccessCodeException()
                else -> KaryaException()
            }
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }

    fun updateWorker(
        idToken: String,
        action: String,
        worker: WorkerRecord,
    ) = flow {
        val response = workerAPI.updateWorker(idToken, action, worker)
        val workerRecord = response.body()

        if (!response.isSuccessful) {
            throw when (response.code()) {
                401 -> InvalidAccessCodeException()
                else -> KaryaException()
            }
        }

        if (workerRecord != null) {
            emit(workerRecord)
        } else {
            error("Request failed, response body was null")
        }
    }

    suspend fun getAllWorkers() =
        withContext(Dispatchers.IO) {
            return@withContext workerDao.getAll()
        }

    suspend fun getWorkerById(id: String) =
        withContext(Dispatchers.IO) {
            return@withContext workerDao.getById(id)
        }

    suspend fun getWorkerByAccessCode(accessCode: String) =
        withContext(Dispatchers.IO) {
            return@withContext workerDao.getByAccessCode(accessCode)
        }

    suspend fun upsertWorker(worker: WorkerRecord) =
        withContext(Dispatchers.IO) { workerDao.upsert(worker) }

    suspend fun updateLanguage(id: String, lang: String) =
        withContext(Dispatchers.IO) {
            workerDao.updateLanguage(id, lang)
        }


}
