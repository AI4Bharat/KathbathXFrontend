package com.ai4bharat.karyatts.utils

sealed class Result {
  class Success<T>(val value: T) : Result()
  class Error(val exception: Throwable) : Result()
  object Loading : Result()
}
