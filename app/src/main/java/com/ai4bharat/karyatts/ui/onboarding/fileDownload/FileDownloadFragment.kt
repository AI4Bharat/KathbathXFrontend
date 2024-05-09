package com.ai4bharat.karyatts.ui.onboarding.fileDownload

import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karyatts.R
import com.ai4bharat.karyatts.data.manager.AuthManager
import com.ai4bharat.karyatts.data.manager.ResourceManager
import com.ai4bharat.karyatts.ui.onboarding.accesscode.AccessCodeViewModel
import com.ai4bharat.karyatts.utils.Result
import com.ai4bharat.karyatts.utils.extensions.viewLifecycle
import com.ai4bharat.karyatts.utils.extensions.viewLifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import javax.inject.Inject
import com.ai4bharat.karyatts.utils.extensions.observe


@AndroidEntryPoint
class FileDownloadFragment : Fragment(R.layout.fragment_file_download) {

  val viewModel by viewModels<AccessCodeViewModel>()

  @Inject
  lateinit var resourceManager: ResourceManager

  @Inject
  lateinit var authManager: AuthManager

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    downloadResourceFiles()
  }

  private fun downloadResourceFiles() {
    viewLifecycleScope.launch {
      val worker = authManager.getLoggedInWorker()

      val fileDownloadFlow =
        resourceManager.downloadLanguageResources(worker.accessCode, "EN")//worker.language)

      fileDownloadFlow.observe(viewLifecycle, viewLifecycleScope) { result ->
        when (result) {
          is Result.Success<*> -> navigateToRegistration()
          is Result.Error -> {
            // Toast.makeText(requireContext(), "Could not download resources", Toast.LENGTH_LONG).show()
            navigateToRegistration()
          }
          Result.Loading -> {
          }
        }
      }
    }
  }

  private fun navigateToRegistration() {
    findNavController().navigate(R.id.action_fileDownloadFragment_to_consentFormFragment)
  }
}
