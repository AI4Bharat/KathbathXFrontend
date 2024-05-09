package com.ai4bharat.karyatts.data.repo

import com.ai4bharat.karyatts.data.service.LanguageAPI
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

class LanguageRepository
@Inject
constructor(
  private val languageAPI: LanguageAPI,
) {

  fun getLanguageAssets(accessCode: String, languageCode: String) = flow {
    val response = languageAPI.getLanguageAssets(accessCode, languageCode)

    if (!response.isSuccessful) {
      error("Failed to get file")
    }

    emit(response)
  }
}
