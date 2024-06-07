package com.ai4bharat.kathbath.data.manager

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences


class SharedPreferenceManager(val context: Context) {

    private val SHARED_PREFERENCE_NAME = "KathbathSharedPref"
    private val sharedPreferences: SharedPreferences =
        context.getSharedPreferences(SHARED_PREFERENCE_NAME, MODE_PRIVATE)


    fun setBooleanValue(key: String, value: Boolean) {
        val sharedPreferencesEditor = this.sharedPreferences.edit()
        sharedPreferencesEditor.putBoolean(key, value)
        sharedPreferencesEditor.apply()
    }

    fun getBooleanValue(key: String): Boolean {
        return this.sharedPreferences.getBoolean(key, false)
    }

    fun clearAllValue() {
        val sharedPreferencesEditor = this.sharedPreferences.edit()
        sharedPreferencesEditor.clear()
        sharedPreferencesEditor.apply()
    }


}