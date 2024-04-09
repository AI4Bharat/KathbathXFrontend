package com.ai4bharat.karya.ui.crowdsource.registration

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
                    findNavController().navigate(R.id.action_crowdsourceRegistration_to_crowdsourceLogin)
                    binding.crowdsourceRegistrationProgressbar.visibility = View.INVISIBLE
                }

                Status.LOADING -> {
                    binding.crowdsourceRegistrationProgressbar.visibility = View.VISIBLE
                }

                else -> {
                    binding.crowdsourceRegistrationProgressbar.visibility = View.INVISIBLE
                }
            }
            binding.textViewcrowdsourceRegistrationStatus.text = registrationStatus.message
        })

        viewModel.user.observe(viewLifecycleOwner, Observer {
            binding.crowdsourceRegistrationConsent.isChecked = it.acceptConsent
        })

        viewModel.userError.observe(viewLifecycleOwner, Observer { userErrors ->
            if (userErrors.name.status) binding.crowdsourceRegistrationNameTextField.error =
                userErrors.name.message
            if (userErrors.phoneNumber.status) binding.crowdsourceRegistrationNumberTextField.error =
                userErrors.phoneNumber.message
            if (userErrors.age.status) binding.crowdsourceRegistrationAgeTextField.error =
                userErrors.age.message
            if (userErrors.occupation.status) binding.crowdsourceRegistrationOccupationTextField.error =
                userErrors.occupation.message
            binding.crowdsourceRegistrationLanguageError.text = userErrors.language.message
            binding.crowdsourceRegistrationJobTypeError.text = userErrors.jobType.message
            binding.crowdsourceRegistrationStateError.text = userErrors.state.message
            binding.crowdsourceRegistrationDistrictError.text = userErrors.district.message
            binding.crowdsourceRegistrationEducationError.text = userErrors.education.message
            binding.crowdsourceRegistrationGenderError.text = userErrors.gender.message
            binding.crowdsourceRegistrationConsentFormError.text = userErrors.acceptConsent.message
        })
    }

    private fun setUpUIElement() {

        val languageList = Language.values().map { it.displayName }
        setSpinner(languageList, binding.crowdsourceRegistrationLanguage)
        val jobTypeList = JobType.values().map { it.displayName }
        setSpinner(jobTypeList, binding.crowdsourceRegistrationJobType)
        val educationList = HighestQualification.values().map { it.displayName }
        setSpinner(educationList, binding.crowdsourceRegistrationEducation)

        binding.crowdsourceRegistrationState.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {

                    val state = p0?.getItemAtPosition(p2).toString()
                    val stateInfo: List<State> =
                        viewModel.location.value!!.filter { it -> it.name == state }
                    if (stateInfo.size == 1) {
                        val selectedState: State = stateInfo[0]
                        val districtList: List<String> =
                            selectedState.district.map { district -> district.name }
                        setSpinner(districtList, binding.crowdsourceRegistrationDistrict)
                    }
                }

                override fun onNothingSelected(p0: AdapterView<*>?) {
                }
            }

        binding.crowdsourceRegistrationLanguage.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                    val language = p0?.getItemAtPosition(p2).toString()
                    viewModel.setData(language = Language.valueOf(language.lowercase()))
                }

                override fun onNothingSelected(p0: AdapterView<*>?) {
                }
            }

        binding.crowdsourceRegistrationButton.setOnClickListener(View.OnClickListener {
            val name = binding.crowdsourceRegistrationNameTextField.text.toString()
            val age = binding.crowdsourceRegistrationAgeTextField.text.toString()
            val phoneNumber = binding.crowdsourceRegistrationNumberTextField.text.toString()
            val gender: Gender = getGender()
            val language: Language =
                Language.valueOf(
                    binding.crowdsourceRegistrationLanguage.selectedItem.toString().lowercase()
                )
            val state: String = binding.crowdsourceRegistrationState.selectedItem.toString()
            val district: String = binding.crowdsourceRegistrationDistrict.selectedItem.toString()
            val jobType: JobType =
                JobType.valueOf(
                    binding.crowdsourceRegistrationJobType.selectedItem.toString().replace(" ", "_")
                        .lowercase()
                )
            val highest_qualification: HighestQualification =
                HighestQualification.values()
                    .filter { education: HighestQualification -> education.displayName == binding.crowdsourceRegistrationEducation.selectedItem.toString() }[0]
            val occupation = binding.crowdsourceRegistrationOccupationTextField.text.toString()
            val consentFormAccept: Boolean = binding.crowdsourceRegistrationConsent.isChecked

            viewModel.setData(
                name,
                age,
                phoneNumber,
                gender,
                state,
                district,
                jobType,
                highest_qualification,
                occupation,
                language,
                consentFormAccept
            )
            lifecycleScope.launch {
                viewModel.submitRegistrationData()
            }
        })
        binding.crowdsourceRegistrationConsent.isActivated = false
        binding.crowdsourceRegistrationReadConsent.setOnClickListener(View.OnClickListener {
            showConsentForm()
        })
    }


    private fun showConsentForm() {
        showConsentForm(
            requireContext(),
            ::changeConsentFormStatus,
            viewModel.user.value!!.language.displayName.lowercase()
        )
    }

    private fun changeConsentFormStatus(status: Boolean) {
        viewModel.setData(acceptConsent = status)
    }

    private fun setSpinner(values: List<String>, spinner: Spinner) {
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, values)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = adapter
    }

    private fun getGender(): Gender {
        val selectedChipId = binding.crowdsourceRegistrationgenderChipGroup.checkedChipId
        val chip: Chip =
            binding.crowdsourceRegistrationgenderChipGroup.findViewById(selectedChipId)
        return Gender.valueOf(chip.text.toString().lowercase())
    }
}




