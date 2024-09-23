package com.ai4bharat.kathbath.ui.crowdsource.login

import android.content.Context
import androidx.fragment.app.viewModels
import android.os.Bundle
import android.preference.PreferenceManager
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.AutoCompleteTextView
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.Observer
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.modelsExtra.ReferralInfo
import com.ai4bharat.kathbath.databinding.FragmentCrowdsourceLoginBinding
import com.ai4bharat.kathbath.ui.crowdsource.registration.Language
import com.ai4bharat.kathbath.utils.extensions.viewBinding
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener
import com.android.installreferrer.api.ReferrerDetails
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

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
        getReferralCode()
    }

    private fun getReferralCode() {

        val referrerClient: InstallReferrerClient =
            InstallReferrerClient.newBuilder(context).build()
        referrerClient.startConnection(object : InstallReferrerStateListener {

            override fun onInstallReferrerServiceDisconnected() {
            }

            override fun onInstallReferrerSetupFinished(responseCode: Int) {
                when (responseCode) {
                    InstallReferrerClient.InstallReferrerResponse.OK -> {
                        val response: ReferrerDetails = referrerClient.installReferrer
                        val referrerUrl: String = response.installReferrer
                        val referrerClickTime: Long = response.referrerClickTimestampSeconds
                        val appInstallTime: Long = response.installBeginTimestampServerSeconds
                        val instantExperiencedLaunched: Boolean = response.googlePlayInstantParam

                        println(
                            "The referral info is $referrerUrl $referrerClickTime $appInstallTime" +
                                    "$instantExperiencedLaunched"
                        )

                        if (!getReferralSharedPref()) {
                            viewModel.sendReferralDownloadInfo(referrerUrl)
                        }

                        referrerClient.endConnection()
                    }

                    InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED -> {
                    }

                    InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE -> {
                    }

                }
            }


        })
    }

    private fun getReferralSharedPref(): Boolean {
        val sharedPref = activity?.getPreferences(Context.MODE_PRIVATE)
        if (sharedPref != null) {
            println(
                "Referral shared pref ${
                    sharedPref.getBoolean(
                        getString(R.string.downloadReferralSendStatus),
                        false
                    )
                }"
            )
            return sharedPref.getBoolean(getString(R.string.downloadReferralSendStatus), false)
        }
        return false
    }

    private fun updateReferralSharedPref(status: Boolean) {
        val sharedPref = activity?.getPreferences(Context.MODE_PRIVATE) ?: return
        with(sharedPref.edit()) {
            println("Referral update shared pref $status")
            putBoolean(getString(R.string.downloadReferralSendStatus), status)
            commit()
        }
    }

    private fun setupUIVariables() {
        viewModel.updateReferralDownloadInfo.observe(viewLifecycleOwner) {
            updateReferralSharedPref(it)
        }
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
            val phoneNumber = binding.crowdsourceLoginPhoneNumber.text.toString().trim()
            val selectedLanguage =
                binding.crowdsourceLoginLanguage.text.toString().lowercase().trim()
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