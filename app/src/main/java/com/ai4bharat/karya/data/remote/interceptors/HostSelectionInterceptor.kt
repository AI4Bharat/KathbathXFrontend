package com.ai4bharat.karya.data.remote.interceptors

import android.util.Log
import com.ai4bharat.karya.data.manager.BaseUrlManager
import kotlinx.coroutines.runBlocking
import okhttp3.Interceptor
import okhttp3.Response

class HostSelectionInterceptor(val baseUrlManager: BaseUrlManager): Interceptor {

  override fun intercept(chain: Interceptor.Chain): Response {
    val request = chain.request()
    val newRequestBuilder = request.newBuilder()
    val newRequest = runBlocking {
      val baseUrl = baseUrlManager.getBaseUrl()
      val newUrl = request.url.toString().replace("http://__url__", baseUrl)
//      Log.e("URLURL", "$request><><$newUrl")
      newRequestBuilder
        .url(newUrl)
        .build()
    }
    Log.e("URLURL2", "$newRequest")

    return chain.proceed(newRequest)
  }
}
