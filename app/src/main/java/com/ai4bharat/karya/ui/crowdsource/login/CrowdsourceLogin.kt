package com.ai4bharat.karya.ui.crowdsource.login

import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceLoginBinding
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
        viewModel.loginStatus.observe(viewLifecycleOwner, Observer { loginStatus ->
            if (loginStatus) {
                binding.crowdsourceLoginStatus.visibility = View.GONE
                println("Login is successful")
            } else {
                println("Login failed")
                binding.crowdsourceLoginStatus.visibility = View.VISIBLE
                binding.crowdsourceLoginStatus.setText("Login failed")
            }
        })
    }

    private fun setupUIElements() {
        viewModel.accessCodeError.observe(viewLifecycleOwner, Observer { errorMsg ->
            println(errorMsg)
            binding.crowdsourceLoginAccessCode.setError(errorMsg)
        })

        binding.crowdsourceRegistration.setOnClickListener(View.OnClickListener {
            findNavController().navigate(R.id.action_crowdsourceLogin_to_crowdsourceRegistration)
        })

        binding.crowdsourceLoginButton.setOnClickListener(View.OnClickListener {
            val accessCode = binding.crowdsourceLoginAccessCode.text.toString()
            viewModel.setData(accessCode)
            viewModel.login()
        })
    }


}