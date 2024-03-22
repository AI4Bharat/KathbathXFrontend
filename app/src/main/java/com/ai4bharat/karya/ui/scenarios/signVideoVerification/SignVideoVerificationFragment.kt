package com.ai4bharat.karya.ui.scenarios.signVideoVerification

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.addCallback
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.karya.R
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.ui.scenarios.signVideoVerification.SignVideoVerificationViewModel.ButtonState.DISABLED
import com.ai4bharat.karya.ui.scenarios.signVideoVerification.SignVideoVerificationViewModel.ButtonState.ENABLED
import com.ai4bharat.karya.utils.extensions.*
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_sign_video_verification.*
import kotlinx.android.synthetic.main.microtask_common_next_button.view.*
import kotlinx.android.synthetic.main.microtask_common_playback_progress.*
import kotlinx.android.synthetic.main.microtask_sign_video_verification.commonCl1
import kotlinx.android.synthetic.main.microtask_sign_video_verification.instructionTv
import kotlinx.android.synthetic.main.microtask_sign_video_verification.nextBtnCv
import kotlinx.android.synthetic.main.microtask_sign_video_verification.sentenceTv
import kotlinx.android.synthetic.main.microtask_sign_video_verification.view.*
import kotlinx.android.synthetic.main.microtask_sign_video_verification.wrongAgeGroup
import kotlinx.android.synthetic.main.microtask_sign_video_verification.wrongGender
import kotlinx.android.synthetic.main.microtask_speech_verification.*

@AndroidEntryPoint
class SignVideoVerificationFragment :
  BaseMTRendererFragment(R.layout.microtask_sign_video_verification) {
  override val viewModel: SignVideoVerificationViewModel by viewModels()
  val args: SignVideoVerificationFragmentArgs by navArgs()

  private fun setupObservers() {

//    viewModel.oldRemarks.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { remarks ->
//      feedbackEt.setText(remarks)
//    }

    viewModel.nextBtnState.observe(
      viewLifecycleOwner.lifecycle,
      viewLifecycleScope
    ) { state ->
      nextBtnCv.isClickable = state != DISABLED
      nextBtnCv.nextIv.setBackgroundResource(
        when (state) {
          DISABLED -> R.drawable.ic_next_disabled
          ENABLED -> R.drawable.ic_next_enabled
        }
      )
    }

    viewModel.videoPlayerVisibility.observe(
      viewLifecycleOwner.lifecycle,
      viewLifecycleScope
    ) { visible ->
      if (visible) {
        showVideoPlayer()
      } else {
        hideVideoPlayer()
      }
    }

    viewModel.recordingFile.observe(
      viewLifecycleOwner.lifecycle,
      viewLifecycleScope
    ) { filePath ->
      if (filePath.isNotEmpty()) videoPlayer.setSource(filePath)
    }

    viewModel.sentenceTvText.observe(
      viewLifecycleOwner.lifecycle,
      viewLifecycleScope
    ) { text ->
      if (text.isNotEmpty()) sentenceTv.text = text
    }

    viewModel.fileID.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      videofileId.text = text
      duplicateSpeaker.isChecked = false
      wrongGender.isChecked = false
      wrongAgeGroup.isChecked = false
      commonCl1.gone()
    }

    viewModel.videoPhoneNumber.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      videoPhoneNumber.text = text
    }

    viewModel.fileGender.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      videofileGender.text = text
    }

    viewModel.fileAgeGroup.observe(
      viewLifecycleOwner.lifecycle, viewLifecycleScope
    ) { text ->
      videofileAgeGroup.text = text
    }
//
//    viewModel.microtaskID.observe(
//      viewLifecycleOwner.lifecycle, viewLifecycleScope
//    ) { id ->
////      miscTick.isChecked = false
//      duplicateSpeaker.isChecked = false
//      wrongGender.isChecked = false
//      wrongAgeGroup.isChecked = false
//      commonCl1.gone()
//    }
//
//    viewModel.decisionRating.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { value ->
//      when (value) {
//        "accept" -> {
//          decisionGroup.check(videoGoodBtn.id)
//          commonCl1.gone()
//        }
//        "reject" -> {
//          decisionGroup.check(videoPoorBtn.id)
//          commonCl1.visible()
//        }
//        else -> decisionGroup.clearChecked()
//      }
//    }



  }

  private fun showVideoPlayer() {
    videoPlayer.visible()
    videoPlayerPlaceHolder.invisible()
  }

  private fun hideVideoPlayer() {
    videoPlayer.invisible()
    videoPlayerPlaceHolder.visible()
  }

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {
    val view = super.onCreateView(inflater, container, savedInstanceState)
    // TODO: Remove this once we have viewModel Factory
    viewModel.setupViewModel(args.taskId, 0, 0)
    return view
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    /** grade instruction */
    val gradeInstruction =
      viewModel.task.params.asJsonObject.get("instruction").asString
    instructionTv.text = gradeInstruction

    setupObservers()
    /** Set OnBackPressed callback */
    requireActivity().onBackPressedDispatcher.addCallback(viewLifecycleOwner) {
      freeResources()
      viewModel.onBackPressed()
    }

    /** Set on click listeners */
    nextBtnCv.setOnClickListener {
      // If not selected a grade, return
      if (viewModel.score == "undefined") { // TODO: Change this to enum
        Toast.makeText(requireContext(), "Please select the decision first", Toast.LENGTH_LONG).show()
        return@setOnClickListener
      }
      // The decision box is set to either accept or reject
      else if (viewModel.score == "accept"){
        viewModel.wrongGender = false
        viewModel.wrongAgeGroup = false
        viewModel.duplicateWorker = false
        viewModel.remarks = ""

        viewModel.handleNextClick()
        resetUI()
      }
      else if (viewModel.score == "reject"){

        // Get the tickmarkers
        viewModel.wrongGender = wrongGender.isChecked
        viewModel.wrongAgeGroup = wrongAgeGroup.isChecked
        viewModel.duplicateWorker = duplicateSpeaker.isChecked
        viewModel.remarks = feedbackEt.text.toString()

        if (viewModel.wrongGender || viewModel.wrongAgeGroup || viewModel.duplicateWorker || viewModel.remarks.isNotEmpty()){
          viewModel.handleNextClick()
          resetUI()
        }
        else{
          Toast.makeText(requireContext(), "Please select the decision first", Toast.LENGTH_LONG).show()
          return@setOnClickListener
        }

      }


    }

    feedbackEt.addTextChangedListener { editText ->
      viewModel.remarks = editText.toString()
    }

    ratingGroup.addOnButtonCheckedListener { _, checkedId, isChecked ->
      if (isChecked) {
        when (checkedId) {
          R.id.videoPoorBtn -> {
            viewModel.score = "reject"
            commonCl1.visible()
            feedbackEt.visible()

          }
          R.id.videoGoodBtn -> {
            viewModel.score = "accept"
            commonCl1.gone()
            feedbackEt.gone()
          }
          else -> "undefined"
        }
      }
    }
  }

  private fun resetUI() {
    feedbackEt.text.clear()
    ratingGroup.clearChecked()
    hideKeyboard()
  }

  private fun freeResources() {
    videoPlayer.releasePlayer()
  }
}

