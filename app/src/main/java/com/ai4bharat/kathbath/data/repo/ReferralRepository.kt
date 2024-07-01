package com.ai4bharat.kathbath.data.repo

import com.ai4bharat.kathbath.data.model.karya.modelsExtra.ReferralInfo
import com.ai4bharat.kathbath.data.service.ReferralAPI
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

class ReferralRepository
@Inject
constructor(private val referralAPI: ReferralAPI) {

    fun submitReferralInfo(referralInfo: ReferralInfo) = flow {
        println("Referral response ${referralInfo}")
        val response = referralAPI.submitReferral(referralInfo)

        println("Referral response ${response.body()}")
        val referralResponse = response.body()
        if (!response.isSuccessful) {
            emit(false)
            error("Failed to submit referral info")
        }

        if (referralResponse != null) {
            emit(referralResponse)
        } else {
            emit(false)
        }
    }

}