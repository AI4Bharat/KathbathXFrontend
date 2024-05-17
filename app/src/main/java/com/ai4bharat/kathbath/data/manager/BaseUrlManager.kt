package com.ai4bharat.kathbath.data.manager

import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.ai4bharat.kathbath.utils.PreferenceKeys
import com.ai4bharat.kathbath.utils.extensions.dataStore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class BaseUrlManager(val applicationContext: Context) {

    private var baseUrl: String = "https://dmubox-lite.centralindia.cloudapp.azure.com/box"

    suspend fun updateBaseUrl(url: String) {
        check(url.isNotEmpty()) { "URL cannot be null" }
        baseUrl = url
        setUpdatedBaseUrl(url)
    }

    private suspend fun setUpdatedBaseUrl(url: String) = withContext(Dispatchers.IO) {
        val baseUrlKey = stringPreferencesKey(PreferenceKeys.BASE_URL)
        applicationContext.dataStore.edit { prefs -> prefs[baseUrlKey] = url }
    }

    suspend fun getBaseUrl(): String {
//    if (!this::baseUrl.isInitialized) {
//      val baseUrlKey = stringPreferencesKey(PreferenceKeys.BASE_URL)
//      val data = applicationContext.dataStore.data.first()
//      baseUrl = data[baseUrlKey] ?: throw Exception("No URL Found")
//    }
        return baseUrl
    }

}
