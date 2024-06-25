package com.ai4bharat.kathbath.ui.scenarios.speechVerificationMultiModal

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TableLayout
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.navArgs
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.ui.scenarios.common.BaseMTRendererFragment
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.android.synthetic.main.microtask_speech_verification_multi_modal.inputPromptViewPager


@AndroidEntryPoint
class SpeechVerificationMultiModalFragment :
    BaseMTRendererFragment(R.layout.microtask_speech_verification_multi_modal) {

    override val viewModel: SpeechVerificationMultiModalViewModel by viewModels()
    val args: SpeechVerificationMultiModalFragmentArgs by navArgs()
    private lateinit var verificationInputPromptAdapter: InputPromptAdapter


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
        setupInputPrompts(view.findViewById(R.id.inputPromptTabLayout))


    }

    private fun setupInputPrompts(tablayout: TabLayout) {
        verificationInputPromptAdapter = InputPromptAdapter(requireParentFragment())

        val audioPromptFragment = InputPromptAudioFragment()
        val imagePromptFragment = InputPromptImageFragment()


        verificationInputPromptAdapter.addFragment(audioPromptFragment)
        verificationInputPromptAdapter.addFragment(imagePromptFragment)
//        verificationInputPromptAdapter.addFragment(InputPromptTextFragment())

        inputPromptViewPager.adapter = verificationInputPromptAdapter

        TabLayoutMediator(tablayout, inputPromptViewPager) { tab, postion ->
            tab.text = when (postion) {
                0 -> "Audio"
                else -> "Image"
            }
        }.attach()
    }

}
























