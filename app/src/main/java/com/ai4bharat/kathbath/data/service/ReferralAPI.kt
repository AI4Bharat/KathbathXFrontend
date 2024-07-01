package com.ai4bharat.kathbath.data.service

import com.ai4bharat.kathbath.data.model.karya.modelsExtra.ReferralInfo
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface ReferralAPI {

    @POST("/referral/submit")
    suspend fun submitReferral(@Body referralInfo: ReferralInfo): Response<Boolean>
}