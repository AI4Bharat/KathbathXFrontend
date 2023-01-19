package com.ai4bharat.karya.ui

import android.content.res.Configuration
import android.content.res.Resources
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.databinding.ActivityMainBinding
import com.ai4bharat.karya.utils.extensions.viewBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {
  private val binding by viewBinding(ActivityMainBinding::inflate)

  @Inject
  lateinit var authManager: AuthManager

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(binding.root)
  }

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
