package com.ai4bharat.karya.ui.crowdsource.registration

import androidx.fragment.app.viewModels
import android.os.Bundle
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
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceRegistrationBinding
import com.ai4bharat.karya.ui.crowdsource.login.Status
import com.ai4bharat.karya.ui.crowdsource.registration.ConsentDialog.showConsentForm
import com.ai4bharat.karya.utils.extensions.viewBinding
import com.google.android.material.chip.Chip
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import org.json.JSONObject

@AndroidEntryPoint
class CrowdsourceRegistration : Fragment() {

    companion object {
        fun newInstance() = CrowdsourceRegistration()
    }

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
        setUpVariables()
    }

    private fun setUpVariables() {

        val locationString = requireContext().assets.open("location.json")
            .bufferedReader().use { it.readText() }
        val jsonObject = JSONObject(locationString)
        viewModel.initializeLocation(jsonObject)

        viewModel.location.observe(viewLifecycleOwner, Observer { locationInfo ->
            if (locationInfo.size > 0) {
                val stateList = locationInfo.map { state: State ->
                    state.name
                }
                setSpinner(stateList, binding.crowdsourceRegistrationState)
            }
        })

        viewModel.registrationStatus.observe(viewLifecycleOwner, Observer { registrationStatus ->
            when (registrationStatus.status) {
                Status.SUCCESS -> {
                    binding.crowdsourceRegistrationProgressbar.visibility = View.INVISIBLE
                    findNavController().navigate(R.id.action_crowdsourceRegistration_to_crowdsourceLogin)
                }

                Status.LOADING -> {
                    binding.crowdsourceRegistrationProgressbar.visibility = View.VISIBLE
                }

                else -> {
                    binding.crowdsourceRegistrationProgressbar.visibility = View.INVISIBLE
                    binding.textViewcrowdsourceRegistrationStatus.text = registrationStatus.message
                }
            }
        })

        viewModel.user.observe(viewLifecycleOwner, Observer {
            binding.crowdsourceRegistrationConsent.isChecked = it.acceptConsent
        })

        viewModel.userError.observe(viewLifecycleOwner, Observer { userErrors ->
            if (userErrors.name.status) {
                binding.crowdsourceRegistrationName.error =
                    userErrors.name.message
            }
            if (userErrors.phoneNumber.status) binding.crowdsourceRegistrationNumber.error =
                userErrors.phoneNumber.message
            if (userErrors.age.status) binding.crowdsourceRegistrationAge.error =
                userErrors.age.message
            if (userErrors.occupation.status) binding.crowdsourceRegistrationOccupation.error =
                userErrors.occupation.message
            if (userErrors.language.status)
                binding.crowdsourceRegistrationLanguage.error = userErrors.language.message
            if (userErrors.jobType.status)
                binding.crowdsourceRegistrationJobType.error = userErrors.jobType.message
            if (userErrors.state.status) {
                binding.crowdsourceRegistrationState.error = userErrors.state.message
            }
            if (userErrors.mostTimeSpend.status) {
                binding.crowdsourceRegistrationMostTimeSpend.error =
                    userErrors.mostTimeSpend.message
            }
            if (userErrors.district.status) {
                binding.crowdsourceRegistrationDistrict.error = userErrors.district.message
            }
            if (userErrors.education.status)
                binding.crowdsourceRegistrationEducation.error = userErrors.education.message
            if (userErrors.gender.status)
                binding.crowdsourceRegistrationGenderError.text = userErrors.gender.message
            if (userErrors.acceptConsent.status) {
                binding.crowdsourceRegistrationConsentFormError.text =
                    userErrors.acceptConsent.message
            } else {
                binding.crowdsourceRegistrationConsentFormError.text = ""
            }
            if (userErrors.referralCode.status)
                binding.crowdsourceRegistrationReferralCode.error = userErrors.referralCode.message

            if (userErrors.errorExist()) {
                binding.textViewcrowdsourceRegistrationStatus.text =
                    "Please ensure all the inputs are valid"
            } else {
                binding.textViewcrowdsourceRegistrationStatus.text = ""
            }
        })
    }

    private fun setUpUIElement() {

        val languageList = Language.values().map { it.displayName }
        setSpinner(languageList, binding.crowdsourceRegistrationLanguage)
        val jobTypeList = JobType.values().map { it.displayName }
        setSpinner(jobTypeList, binding.crowdsourceRegistrationJobType)
        val educationList = HighestQualification.values().map { it.displayName }
        setSpinner(educationList, binding.crowdsourceRegistrationEducation)
        val mostTimeSpendList = MostTimeSpend.values().map { it.displayName }
        setSpinner(mostTimeSpendList, binding.crowdsourceRegistrationMostTimeSpend)

        binding.crowdsourceRegistrationState.setOnItemClickListener { adapterView, view, i, l ->
            val state = adapterView?.getItemAtPosition(i).toString()
            val stateInfo: List<State> =
                viewModel.location.value!!.filter { it -> it.name == state }
            if (stateInfo.size == 1) {
                val selectedState: State = stateInfo[0]
                val districtList: List<String> =
                    selectedState.district.map { district -> district.name }
                setSpinner(districtList, binding.crowdsourceRegistrationDistrict)
            }
        }

        binding.crowdsourceRegistrationLanguage.setOnItemClickListener { adapterView, view, i, l ->
            val language = adapterView?.getItemAtPosition(i).toString().lowercase()
            viewModel.setData(language = language)
        }

        binding.crowdsourceRegistrationButton.setOnClickListener(View.OnClickListener {
            val name = binding.crowdsourceRegistrationName.text.toString().trim()
            val age = binding.crowdsourceRegistrationAge.text.toString().trim()
            val phoneNumber = binding.crowdsourceRegistrationNumber.text.toString().trim()
            val gender = getGender()
            val language =
                binding.crowdsourceRegistrationLanguage.text.toString().lowercase().trim()
            val state: String = binding.crowdsourceRegistrationState.text.toString().trim()
            val district: String = binding.crowdsourceRegistrationDistrict.text.toString().trim()
            val jobType =
                binding.crowdsourceRegistrationJobType.text.toString().trim().replace(" ", "_")
                    .lowercase().trim()
            val highestQualification = getKeyFromEnum(
                binding.crowdsourceRegistrationEducation.text.toString(),
                HighestQualification.values().associateBy({ it.name }, { it.displayName })
            )
            val occupation = binding.crowdsourceRegistrationOccupation.text.toString().trim()
            val consentFormAccept: Boolean = binding.crowdsourceRegistrationConsent.isChecked
            val referralCode = binding.crowdsourceRegistrationReferralCode.text.toString().trim()
            val mostTimeSpend: String =
                binding.crowdsourceRegistrationMostTimeSpend.text.toString().trim().lowercase()
                    .replace(" ", "_")
            println("The consent form is $mostTimeSpend")

            viewModel.setData(
                name,
                age,
                phoneNumber,
                gender,
                state,
                district,
                jobType,
                highestQualification,
                occupation,
                language,
                consentFormAccept,
                referralCode,
                mostTimeSpend
            )
            lifecycleScope.launch {
                viewModel.submitRegistrationData()
            }
        })
        binding.crowdsourceRegistrationConsent.isActivated = false
        binding.crowdsourceRegistrationConsentLayout.setOnClickListener(View.OnClickListener {
            showConsentForm()
        })
    }

    private fun getKeyFromEnum(value: String, map: Map<String, String>): String {
        println("INSIDE $value $map")
        val result = map.filter { t ->
            t.value.lowercase().replace(" ", "_") == value.trim().lowercase().replace(" ", "_")
        }
        if (result.isNotEmpty()) {
            return result.keys.toList()[0]
        }
        return ""
    }

    private fun showConsentForm() {
        val selectedLanguage =
            binding.crowdsourceRegistrationLanguage.text.toString().lowercase().trim()
        showConsentForm(
            requireContext(),
            ::changeConsentFormStatus,
            selectedLanguage
        )

    }

    private fun changeConsentFormStatus(status: Boolean) {
        viewModel.setData(acceptConsent = status)
    }

    private fun setSpinner(values: List<String>, textLayout: AutoCompleteTextView) {
        val arrayAdapter = ArrayAdapter(requireContext(), R.layout.custom_spinner_item, values)
        textLayout.setAdapter(arrayAdapter)
        textLayout.doOnTextChanged { text, start, count, after ->
            textLayout.error = null
        }
    }

    private fun getGender(): String {
        val selectedChipId = binding.crowdsourceRegistrationgenderChipGroup.checkedChipId
        val chip: Chip =
            binding.crowdsourceRegistrationgenderChipGroup.findViewById(selectedChipId)
        return chip.text.toString().lowercase()
    }
}




