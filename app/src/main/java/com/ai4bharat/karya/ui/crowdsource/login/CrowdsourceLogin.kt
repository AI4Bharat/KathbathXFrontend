package com.ai4bharat.karya.ui.crowdsource.login

import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import android.widget.Spinner
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceLoginBinding
import com.ai4bharat.karya.ui.crowdsource.registration.Language
import com.ai4bharat.karya.utils.extensions.viewBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import kotlin.math.log

@AndroidEntryPoint
class CrowdsourceLogin : Fragment() {

    companion object {
        fun newInstance() = CrowdsourceLogin()
    }

    private val viewModel by viewModels<CrowdsourceLoginViewModel>()
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
            if (loginUserError.languageError.status) {
                binding.crowdsourceLoginLanguage.error = loginUserError.languageError.message
            }
        })

        viewModel.loginStatus.observe(viewLifecycleOwner, Observer { loginStatus ->
            when (loginStatus.status) {
                Status.SUCCESS -> {
                    findNavController().navigate(R.id.action_crowdsourceLogin_to_dashboardActivity)
                    binding.crowdsourceLoginStatus.text = loginStatus.message
                    binding.crowdsourceLoginProgressbar.visibility = View.INVISIBLE
                }

                Status.LOADING -> {
                    binding.crowdsourceLoginProgressbar.visibility = View.VISIBLE
                    binding.crowdsourceLoginStatus.text = loginStatus.message
                }

                Status.FAILED -> {
                    binding.crowdsourceLoginProgressbar.visibility = View.INVISIBLE
                    binding.crowdsourceLoginStatus.text = loginStatus.message
                }

                else -> {
                    binding.crowdsourceLoginProgressbar.visibility = View.INVISIBLE
                    binding.crowdsourceLoginStatus.text = loginStatus.message
                }
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
            val selectedLanguage = binding.crowdsourceLoginLanguage.text.toString().lowercase()
            println("The language is $selectedLanguage")

            viewModel.setData(phoneNumber, selectedLanguage)

            lifecycleScope.launch {
                viewModel.login()
            }
        })
    }

    private fun setSpinner(values: List<String>, textLayout: AutoCompleteTextView) {
        val arrayAdapter = ArrayAdapter(requireContext(), R.layout.custom_spinner_item, values)
        textLayout.setAdapter(arrayAdapter)
        textLayout.doOnTextChanged { text, start, count, after ->
            textLayout.error = null
        }
    }


}