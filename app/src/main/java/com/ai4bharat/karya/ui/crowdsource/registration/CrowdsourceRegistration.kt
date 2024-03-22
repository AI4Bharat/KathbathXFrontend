package com.ai4bharat.karya.ui.crowdsource.registration

import android.annotation.SuppressLint
import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.lifecycle.Observer
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceRegistrationBinding
import com.ai4bharat.karya.utils.extensions.viewBinding
import com.ai4bharat.karya.utils.extensions.viewLifecycle
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup

class CrowdsourceRegistration : Fragment() {

    companion object {
        fun newInstance() = CrowdsourceRegistration()
    }

    //    private val viewModel: CrowdsourceRegistrationViewModel by viewModels()
    private val viewModel by viewModels<CrowdsourceRegistrationViewModel>()
    private val binding by viewBinding(FragmentCrowdsourceRegistrationBinding::bind)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_crowdsource_registration, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setUpUIElement()
    }

    private fun setUpUIElement() {

//        binding.crowdsourceRegistrationgenderChipGroup.setOnCheckedChangeListener { group, checkedId ->
//            val selectedChip: Chip? = group.findViewById(checkedId)
//            selectedChip?.isChecked = true
//            val gender = selectedChip?.text.toString()
//        }

        binding.crowdsourceRegistrationButton.setOnClickListener(View.OnClickListener {
            val userName = binding.crowdsourceRegistrationNameTextField.text.toString()
            val age = binding.crowdsourceRegistrationAgeTextField.text.toString()
            val gender = getGender()
            viewModel.setData(userName, age, gender, "", "")
        })
    }

    private fun getGender(): String {
        val selectedChipId = binding.crowdsourceRegistrationgenderChipGroup.checkedChipId
        if (selectedChipId != -1) {
            val chip: Chip =
                binding.crowdsourceRegistrationgenderChipGroup.findViewById(selectedChipId)
            return chip.text.toString()
        }
        return ""
    }

    private fun updateViewModel() {
        viewModel
    }

}





















