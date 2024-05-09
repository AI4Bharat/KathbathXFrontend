package com.ai4bharat.karyatts.data.remote.interceptors

import okhttp3.Interceptor
import okhttp3.Response

class VersionInterceptor() : Interceptor {
  override fun intercept(chain: Interceptor.Chain): Response {
    return chain.proceed(
      chain.request()
        .newBuilder()
        .addHeader("client-version-number", "5")
        .build()
    )
  }
}
