package com.ai4bharat.karya.ui.scenarios.imageTranscription

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.karya.R
import com.ai4bharat.karya.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.karya.utils.extensions.observe
import com.ai4bharat.karya.utils.extensions.requestSoftKeyFocus
import com.ai4bharat.karya.utils.extensions.viewLifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_image_transcription.*

@AndroidEntryPoint
class ImageTranscriptionFragment : BaseMTRendererFragment(R.layout.microtask_image_transcription) {
  override val viewModel: ImageTranscriptionViewModel by viewModels()
  val args: ImageTranscriptionFragmentArgs by navArgs()

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {
    val view = super.onCreateView(inflater, container, savedInstanceState)
    viewModel.setupViewModel(args.taskId, args.completed, args.total)
    return view
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)
    setupObservers()

    // Set microtask instruction
    val instruction = try {
      viewModel.task.params.asJsonObject.get("instruction").asString
    } catch (e: Exception) {
      getString(R.string.image_transcription_instruction)
    }
    instructionTv.text = instruction

    // Set next button click handler
    nextBtn.setOnClickListener { handleNextClick() }

    // Get keyboard focus
    requestSoftKeyFocus(transcriptionEv)
  }

  private fun handleNextClick() {
    val transcription = transcriptionEv.text.toString()
    viewModel.completeTranscription(transcription)
    transcriptionEv.setText("")
    requestSoftKeyFocus(transcriptionEv)
  }

  private fun setupObservers() {
    viewModel.imageFilePath.observe(viewLifecycleOwner.lifecycle, viewLifecycleScope) { path ->
      if (path.isNotEmpty()) {
        val image: Bitmap = BitmapFactory.decodeFile(path)
        sourceWordIv.setImageBitmap(image)
      } else {
        sourceWordIv.setImageResource(0)
      }
    }
  }
}
