package com.ai4bharat.kathbath.ui.scenarios.speechVerificationMultiModal

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.MutableLiveData
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.ai4bharat.kathbath.R

class InputPromptAdapter(fragment: Fragment) : FragmentStateAdapter(fragment) {

    private val fragmentList: ArrayList<Fragment> = arrayListOf()

    override fun createFragment(position: Int): Fragment {
        return fragmentList[position]
    }

    fun addFragment(fragment: Fragment) {
        fragmentList.add(fragment)
    }

    override fun getItemCount(): Int {
        // Change this
        return fragmentList.size
    }
}


class InputPromptAudioFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_audio_element, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
//        arguments?.takeIf { it.containsKey(ARG_OBJECT) }?.apply {
//        }
    }
}

class InputPromptTextFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_text_element, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    }
}

class InputPromptImageFragment : Fragment() {

    val test = MutableLiveData<Int>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.verification_input_prompt_image_element, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    }
}
























