package com.ai4bharat.kathbath.ui.scenarios.imageTextData

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.ai4bharat.kathbath.utils.extensions.observe
import com.ai4bharat.kathbath.utils.extensions.requestSoftKeyFocus
import com.ai4bharat.kathbath.utils.extensions.viewLifecycleScope
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_image_text_data.imageTextInstructionTv
import kotlinx.android.synthetic.main.microtask_image_text_data.imageTextNextBtn
import kotlinx.android.synthetic.main.microtask_image_text_data.imageTextSourceWordIv
import kotlinx.android.synthetic.main.microtask_image_text_data.imageTextTranscriptionEv
import java.io.File

@AndroidEntryPoint
class ImageTextDataFragment : BaseMTRendererFragment(R.layout.microtask_image_text_data) {

    override val viewModel: ImageTextDataViewModel by viewModels()
    val args: ImageTextDataFragmentArgs by navArgs()


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
        imageTextInstructionTv.text = instruction

        // Set next button click handler
        imageTextNextBtn.setOnClickListener { handleNextClick() }

        // Get keyboard focus
        requestSoftKeyFocus(imageTextTranscriptionEv)
    }

    private fun handleNextClick() {
        val transcription = imageTextTranscriptionEv.text.toString()
        viewModel.completeTranscription(transcription)
        imageTextTranscriptionEv.setText("")
        requestSoftKeyFocus(imageTextTranscriptionEv)
    }

    private fun setupObservers() {
        viewModel.imageFilePath.observe(
            viewLifecycleOwner.lifecycle,
            viewLifecycleScope
        ) { path ->
            if (path.isNotEmpty()) {
                val image: Bitmap = BitmapFactory.decodeFile(path)
                imageTextSourceWordIv.setImageBitmap(image)
            } else {
                imageTextSourceWordIv.setImageResource(0)
            }
        }
    }

}