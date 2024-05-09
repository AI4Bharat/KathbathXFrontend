package com.ai4bharat.karyatts.ui.onboarding.login.otp

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karyatts.R
import com.ai4bharat.karyatts.data.model.karya.enums.AssistantAudio
import com.ai4bharat.karyatts.databinding.FragmentOtpBinding
import com.ai4bharat.karyatts.ui.Destination
import com.ai4bharat.karyatts.ui.base.BaseFragment
import com.ai4bharat.karyatts.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint


private const val OTP_LENGTH = 6

@AndroidEntryPoint
class OTPFragment : BaseFragment(R.layout.fragment_otp) {

  private val binding by viewBinding(FragmentOtpBinding::bind)
  private val viewModel by viewModels<OTPViewModel>()

  private val requestPermissionLauncher = registerForActivityResult(ActivityResultContracts.RequestPermission()){ isGranted: Boolean ->
    if (isGranted) {
      Log.i("Permission: ", "Granted")
    } else {
      Log.i("Permission: ", "Denied")
    }
  }

//  private lateinit var captureUri: Uri

//  private var resultLauncherUpload = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
//    if (result.resultCode == Activity.RESULT_OK) {
//      val uri = result.data?.data!!
//      val photo = BitmapFactory.decodeStream(context?.contentResolver?.openInputStream(uri))
//
//      val immagex: Bitmap = photo
//      val baos = ByteArrayOutputStream()
//      immagex.compress(Bitmap.CompressFormat.JPEG, 80, baos)
//      val b: ByteArray = baos.toByteArray()
//      val imageEncoded = Base64.encodeToString(b, Base64.DEFAULT)
//
//      viewModel.consent_form = imageEncoded
//      immagex.compress(Bitmap.CompressFormat.JPEG, 5, baos)
//      binding.consentFormView.setImageBitmap(immagex)
//
//    }
//
//    }

//  private var resultLauncherCapture = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
//    if (result.resultCode == Activity.RESULT_OK) {
//      val photo = BitmapFactory.decodeStream(context?.contentResolver?.openInputStream(captureUri))
//
//      val immagex: Bitmap = photo
//      val baos = ByteArrayOutputStream()
//      immagex.compress(Bitmap.CompressFormat.JPEG, 80, baos)
//      val b: ByteArray = baos.toByteArray()
//      val imageEncoded = Base64.encodeToString(b, Base64.DEFAULT)
//
//      viewModel.consent_form = imageEncoded
//
//      immagex.compress(Bitmap.CompressFormat.JPEG, 5, baos)
//      binding.consentFormView.setImageBitmap(immagex)
//    }
//
//  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    setupView()
    observeUi()
    observeEffects()


  }

  override fun onResume() {
    super.onResume()
    assistant.playAssistantAudio(AssistantAudio.OTP_PROMPT)
  }


  //Check for camera permissions
  private fun checkCameraPermission() {
    when {
      ContextCompat.checkSelfPermission(
        requireContext(),
        Manifest.permission.CAMERA
      ) == PackageManager.PERMISSION_GRANTED -> {

      }

      ActivityCompat.shouldShowRequestPermissionRationale(
        requireActivity(),
        Manifest.permission.CAMERA
      ) -> {
        requestPermissionLauncher.launch(
          Manifest.permission.CAMERA
        )
      }

      else -> {
        requestPermissionLauncher.launch(
          Manifest.permission.CAMERA
        )

      }
    }
  }

  private fun setupView() {
    viewModel.retrievePhoneNumber()
    binding.appTb.setAssistantClickListener { assistant.playAssistantAudio(AssistantAudio.OTP_PROMPT) }

//    binding.consentFormUploadBtn.setOnClickListener {
//      val intent = Intent()
//      intent.type = "image/*"
//      intent.action = Intent.ACTION_GET_CONTENT
//      /** Sets the path in path variable **/
//      resultLauncherUpload.launch(Intent.createChooser(intent,"Select Consent Image "))
//    }
//
//    binding.consentFormCaptureBtn.setOnClickListener {
//      checkCameraPermission()
//      var values = ContentValues()
//      captureUri = requireContext().contentResolver.insert(
//        MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values
//      )!!
//      val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
//      intent.putExtra(MediaStore.EXTRA_OUTPUT, captureUri)
//      resultLauncherCapture.launch(Intent.createChooser(intent,"Select Consent Image "))
//    }
//    binding.resendOTPBtn.setOnClickListener {
//      binding.resendOTPBtn.gone()
//      viewModel.resendOTP()
//    }

    // To change phone number, just go back
    // TODO: this may not always be true.
    binding.changePhoneNumberBtn.setOnClickListener {
      requireActivity().onBackPressed()
    }


    binding.otpEt.doAfterTextChanged { otp ->
      hideError()

//      if (otp?.length == OTP_LENGTH && viewModel.consent_form.isNotEmpty()) {
//        enableNextButton()
//      } else if (otp?.length == OTP_LENGTH){
//        Toast.makeText(requireContext(), "Please make sure you have uploaded the consent form", Toast.LENGTH_SHORT).show()
//        disableNextButton()
//      }else{
//        disableNextButton()
//      }
      if (otp?.length == OTP_LENGTH) {
        enableNextButton()
      } else{
        disableNextButton()
      }

    }

    binding.numPad.setOnDoneListener { viewModel.verifyOTP(binding.otpEt.text.toString()) }
  }

  private fun observeUi() {
    viewModel.otpUiState.observe(viewLifecycle, viewLifecycleScope) { state ->
      when (state) {
        is OTPUiState.Success -> showSuccessUi()
        // TODO: Change this to a correct mapping
        is OTPUiState.Error -> showErrorUi(getErrorMessage(state.throwable))
        OTPUiState.Initial -> showInitialUi()
        OTPUiState.Loading -> showLoadingUi()
      }
    }

    viewModel.phoneNumber.observe(viewLifecycle, viewLifecycleScope) { phoneNumber ->
      binding.otpPromptTv.text = "Enter Password"//getString(R.string.otp_prompt).replace("0000000000", phoneNumber)
    }
  }

  private fun observeEffects() {
    viewModel.otpEffects.observe(viewLifecycle, viewLifecycleScope) { effect ->
      when (effect) {
        is OTPEffects.Navigate -> navigate(effect.destination)
      }
    }
  }

  private fun showInitialUi() {
    binding.otpEt.text.clear()
    hideError()
    hideLoading()
    disableNextButton()
  }

  private fun showLoadingUi() {
    hideError()
    showLoading()
    disableNextButton()
  }

  private fun showSuccessUi() {
    hideError()
    hideLoading()
    enableNextButton()
  }

  private fun showErrorUi(message: String) {
    showError(message)
    hideLoading()
    enableNextButton()
  }

  private fun navigate(destination: Destination) {
    when (destination) {
      Destination.Dashboard -> navigateToDashBoard()
      else -> {
      }
    }
  }

  private fun navigateToDashBoard() {
    findNavController().navigate(R.id.action_global_dashboardActivity)
  }

  private fun enableNextButton() {
    binding.numPad.enableDoneButton()
  }

  private fun disableNextButton() {
    binding.numPad.disableDoneButton()
  }

  private fun showLoading() {
    with(binding) {
      loadingPb.visible()
      otpEt.disable()
    }
  }

  private fun hideLoading() {
    with(binding) {
      loadingPb.gone()
      otpEt.enable()
    }
  }

  private fun showError(message: String) {
    with(binding) {
      invalidOTPTv.text = message
      invalidOTPTv.visible()
    }
  }

  private fun hideError() {
    binding.invalidOTPTv.gone()
  }
}
