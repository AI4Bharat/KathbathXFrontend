package com.ai4bharat.karya.ui.onboarding.consentForm

import android.os.Build
import android.os.Bundle
import android.text.Html
import android.text.Spanned
import android.text.method.ScrollingMovementMethod
import android.util.Log
import android.view.View
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.data.manager.ResourceManager
import com.ai4bharat.karya.data.model.karya.enums.AssistantAudio
import com.ai4bharat.karya.databinding.FragmentConsentFormBinding
import com.ai4bharat.karya.ui.base.BaseFragment
import com.ai4bharat.karya.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@AndroidEntryPoint
class ConsentFormFragment : BaseFragment(R.layout.fragment_consent_form) {

  private val binding by viewBinding(FragmentConsentFormBinding::bind)
  private val viewModel by viewModels<ConsentFormViewModel>()

  @Inject
  lateinit var resourceManager: ResourceManager

  @Inject
  lateinit var authManager: AuthManager

  // TODO: add assistant
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    setupViews()
    observeUi()
    observeEffects()
  }

  override fun onResume() {
    super.onResume()
    assistant.playAssistantAudio(AssistantAudio.CONSENT_FORM_SUMMARY)
  }

  private fun text2html(text: String): Spanned {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
      return Html.fromHtml(text, Html.FROM_HTML_MODE_COMPACT)
    } else {
      return Html.fromHtml(text)
    }
  }

  private fun setupViews() {

//    val consentFormText = getString(R.string.consent_form_text_english2)
//
//    val spannedText =
//      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//        Html.fromHtml(consentFormText, Html.FROM_HTML_MODE_COMPACT)
//      } else {
//        Html.fromHtml(consentFormText)
//      }

    with(binding) {
      appTb.setAssistantClickListener { assistant.playAssistantAudio(AssistantAudio.CONSENT_FORM_SUMMARY) }
      CoroutineScope(Dispatchers.IO).launch {
        try {
          val worker = authManager.getLoggedInWorker()
//          val language = worker.
          val languageCode = worker.language
          Log.e("WORKER LANGUAGE: ",languageCode)

          if (languageCode.equals("ks",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_kashmiri))
          }
          else if (languageCode.equals("doi",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_english))
          }
          else if (languageCode.equals("mni",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_manipuri))
          }
          else if (languageCode.equals("as",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_assamese))
          }
          else if (languageCode.equals("brx",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_bodo))
          }
          else if (languageCode.equals("ne",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_nepali))
          }
          else if (languageCode.equals("mai",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_maithili))
          }
          else if (languageCode.equals("sa",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_english))
          }
          else if (languageCode.equals("bn",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_bengali))
          }
          else if (languageCode.equals("or",true)){
            consentFormTv.text = text2html(getString(R.string.consent_form_text_bengali))
          }
          else{
            consentFormTv.text = text2html(getString(R.string.consent_form_text_english))
          }
        } catch (e: Throwable) {
          // No logged in worker. Ignore
        }
      }

//      consentFormTv.text = spannedText
      consentFormTv.movementMethod = ScrollingMovementMethod()

      agreeBtn.setOnClickListener { viewModel.updateConsentFormStatus(true) }

      disagreeBtn.setOnClickListener { requireActivity().finish() }
    }
  }

  private fun observeUi() {
    viewModel.consentFormUiState.observe(viewLifecycle, viewLifecycleScope) { state ->
      when (state) {
        is ConsentFormUiState.Error -> showErrorUi()
        ConsentFormUiState.Initial -> showInitialUi()
        ConsentFormUiState.Loading -> showLoadingUi()
        ConsentFormUiState.Success -> showSuccessUi()
      }
    }
  }

  private fun observeEffects() {
    viewModel.consentFormEffects.observe(viewLifecycle, viewLifecycleScope) { effect ->
      when (effect) {
        ConsentFormEffects.Navigate -> navigateToLoginFlow()
      }
    }
  }

  private fun showInitialUi() {
    with(binding) {
      agreeBtn.isClickable = true
      disagreeBtn.isClickable = true

      agreeBtn.enable()
      disagreeBtn.enable()
    }
  }

  private fun showLoadingUi() {
    with(binding) {
      agreeBtn.isClickable = false
      disagreeBtn.isClickable = false

      agreeBtn.disable()
      disagreeBtn.disable()
    }
  }

  private fun showSuccessUi() {
    with(binding) {
      agreeBtn.isClickable = true
      disagreeBtn.isClickable = true

      agreeBtn.enable()
      disagreeBtn.enable()
    }
  }

  private fun showErrorUi() {
    with(binding) {
      agreeBtn.isClickable = true
      disagreeBtn.isClickable = true

      agreeBtn.enable()
      disagreeBtn.enable()
    }
  }

  private fun navigateToLoginFlow() {
    findNavController().navigate(R.id.action_consentFormFragment_to_loginFlow)
  }
}
