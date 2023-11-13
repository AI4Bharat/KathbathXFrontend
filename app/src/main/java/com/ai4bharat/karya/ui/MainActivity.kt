package com.ai4bharat.karya.ui

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.content.res.Resources
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.databinding.ActivityMainBinding
import com.ai4bharat.karya.utils.extensions.viewBinding
import com.google.android.material.snackbar.Snackbar
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject

const val FLEXIABLE_UPADTE: Int = 101
const val FORCE_UPDATE: Int = 102
const val APP_UPDATE_CODE: Int = 500

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {
  private val binding by viewBinding(ActivityMainBinding::inflate)

  @Inject
  lateinit var authManager: AuthManager

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    updateApp(FORCE_UPDATE)
    setContentView(binding.root)
  }

  private fun updateApp(statusCode: Int) {
    val appUpdateManager = AppUpdateManagerFactory.create(this@MainActivity)

    val appUpdateInfoTask = appUpdateManager?.appUpdateInfo
    Log.d("APPUPDATE",appUpdateInfoTask.toString())
    appUpdateInfoTask?.addOnSuccessListener {
      appUpdateInfo ->
      if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE) {
        if ((statusCode == FORCE_UPDATE))
          appUpdateManager?.startUpdateFlowForResult(
        appUpdateInfo, AppUpdateType.IMMEDIATE, this, APP_UPDATE_CODE
        )
        else if (statusCode == FLEXIABLE_UPADTE)
          appUpdateManager?.startUpdateFlowForResult(
        appUpdateInfo, AppUpdateType.FLEXIBLE, this, FLEXIABLE_UPADTE
        )
      }
    }
  }

//  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent? ) {
//
//    try {
//      if (requestCode == APP_UPDATE_CODE && resultCode == Activity.RESULT_OK) {
//        if (resultCode != RESULT_OK) {
//          appUpdateCompleted()
//        }
//      }
//    } catch (e: java.lang.Exception) {
//
//    }
//  }
//
//  private fun appUpdateCompleted() {
//    Toast.makeText(
//      this,
//      "Application Updated Successfully, Please clear the data in case the app is unable to open",
//      Toast.LENGTH_LONG
//    )
//  }

  fun setActivityLocale(languageCode: String) {
    val locale = Locale(languageCode)
    Locale.setDefault(locale)
    val resources: Resources = resources
    val config: Configuration = resources.configuration
    config.setLocale(locale)
    config.setLayoutDirection(locale)
    resources.updateConfiguration(config, resources.displayMetrics)
  }

  /**
   * Set locale on resume
   */
  override fun onResume() {
    super.onResume()
    updateApp(FORCE_UPDATE)
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val worker = authManager.getLoggedInWorker()
        val languageCode = worker.language
        setActivityLocale("EN")//languageCode)
      } catch (e: Throwable) {
        // No logged in worker. Ignore
      }
    }

  }
}
