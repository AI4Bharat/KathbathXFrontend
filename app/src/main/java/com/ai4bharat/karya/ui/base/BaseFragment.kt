package com.ai4bharat.karya.ui.base

import android.content.pm.PackageManager
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.exceptions.KaryaException
import com.ai4bharat.karya.ui.assistant.Assistant
import com.ai4bharat.karya.ui.assistant.AssistantFactory
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.model.karya.enums.LanguageType
import com.ai4bharat.karya.data.repo.WorkerRepository
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.ui.views.KaryaToolbar
import com.ai4bharat.karya.utils.extensions.finish
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

abstract class BaseFragment : Fragment {

  constructor() : super()
  constructor(@LayoutRes contentLayoutId: Int) : super(contentLayoutId)

  @Inject
  lateinit var authManagerBase: AuthManager

  @Inject
  lateinit var workerRepositoryBase: WorkerRepository

  @Inject
  lateinit var assistantFactory: AssistantFactory
  lateinit var assistant: Assistant

  companion object {
    /** Code to request necessary permissions */
    private const val REQUEST_PERMISSIONS = 202

    // Flag to indicate if app has all permissions
    private var hasAllPermissions: Boolean = true
  }

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {
    assistant = assistantFactory.create(viewLifecycleOwner)
    return super.onCreateView(inflater, container, savedInstanceState)
  }

  open fun requiredPermissions(): Array<String> {
    return arrayOf()
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    val permissions = requiredPermissions()
    if (permissions.isNotEmpty()) {
      for (permission in permissions) {
        if (ContextCompat.checkSelfPermission(
            requireContext(),
            permission
          ) != PackageManager.PERMISSION_GRANTED
        ) {
          hasAllPermissions = false
          requestPermissions(permissions, REQUEST_PERMISSIONS)
          break
        }
      }
    }

    if (hasAllPermissions) {
      val toolbar = this.view?.findViewById<KaryaToolbar>(R.id.appTb)
      toolbar?.setLanguageUpdater { l -> updateUserLanguage(l) }
      runBlocking {
        toolbar?.setTitle(authManagerBase.getLoggedInWorker().accessCode)
      }

    }
  }

  /**
   * Get message corresponding to an exception. If it is a Karya exception, then it will have a
   * resource ID that we can use to the get the appropriate message.
   */
  fun getErrorMessage(throwable: Throwable): String {
    val context = requireContext()
    return when (throwable) {
      is KaryaException -> throwable.getMessage(context)
      else -> throwable.message ?: context.getString(R.string.unknown_error)
    }
  }

  private fun updateUserLanguage(lang: LanguageType) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val worker = authManagerBase.getLoggedInWorker()
        workerRepositoryBase.updateLanguage(worker.id, lang.toString())
        CoroutineScope(Dispatchers.Main).launch {
          val intent = activity?.intent
          if (intent != null) {
            finish()
            startActivity(intent)
          }
        }
      } catch (e: Exception) {
        // Ignore exceptions
      }
    }
  }
}
