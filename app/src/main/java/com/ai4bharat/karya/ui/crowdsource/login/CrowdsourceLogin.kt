package com.ai4bharat.karya.ui.crowdsource.login

import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceLoginBinding
import com.ai4bharat.karya.ui.crowdsource.registration.Language
import com.ai4bharat.karya.utils.extensions.viewBinding

class CrowdsourceLogin : Fragment() {

    companion object {
        fun newInstance() = CrowdsourceLogin()
    }

    private val viewModel: CrowdsourceLoginViewModel by viewModels()
    private val binding by viewBinding(FragmentCrowdsourceLoginBinding::bind)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_crowdsource_login, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupUIElements()
        setupUIVariables()
    }

    private fun setupUIVariables() {
        viewModel.loginUserError.observe(viewLifecycleOwner, Observer { loginUserError ->
            if (loginUserError.phoneNumberError.status) {
                binding.crowdsourceLoginPhoneNumber.error = loginUserError.phoneNumberError.message
            }
        })
    }

    private fun setupUIElements() {
        val languageList = Language.values().map { it.displayName }
        setSpinner(languageList, binding.crowdsourceLoginLanguage)
        binding.crowdsourceRegistration.setOnClickListener(View.OnClickListener {
            findNavController().navigate(R.id.action_crowdsourceLogin_to_crowdsourceRegistration)
        })

        binding.crowdsourceLoginButton.setOnClickListener(View.OnClickListener {
            val phoneNumber = binding.crowdsourceLoginPhoneNumber.text.toString()
            val language: Language = Language.valueOf(
                binding.crowdsourceLoginLanguage.selectedItem.toString().lowercase()
            )
            viewModel.setData(phoneNumber, language)
            viewModel.login()
        })
    }

    private fun setSpinner(values: List<String>, spinner: Spinner) {
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, values)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = adapter
    }


}