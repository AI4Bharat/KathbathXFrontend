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
import com.ai4bharat.karya.R
import com.ai4bharat.karya.databinding.FragmentCrowdsourceRegistrationBinding
import com.ai4bharat.karya.ui.crowdsource.Education
import com.ai4bharat.karya.ui.crowdsource.Gender
import com.ai4bharat.karya.ui.crowdsource.JobType
import com.ai4bharat.karya.ui.crowdsource.Language
import com.ai4bharat.karya.utils.extensions.viewBinding
import com.google.android.material.chip.Chip
import kotlinx.android.synthetic.main.microtask_speech_verification.phoneNumber
import org.json.JSONObject

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

        val languageList = Language.values().map { it.displayName }
        setSpinner(languageList, binding.crowdsourceRegistrationLanguage)
        val jobTypeList = JobType.values().map { it.displayName }
        setSpinner(jobTypeList, binding.crowdsourceRegistrationJobType)
        val educationList = Education.values().map { it.displayName }
        setSpinner(educationList, binding.crowdsourceRegistrationEducation)
        val stateList: MutableList<String> = populateStateList()
        setSpinner(stateList, binding.crowdsourceRegistrationState)

        binding.crowdsourceRegistrationState.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                    println(p0?.selectedItem)
                    val districtList: MutableList<String> =
                        getDistrictList(p0?.getItemAtPosition(p2).toString())
                    setSpinner(districtList, binding.crowdsourceRegistrationDistrict)
                }

                override fun onNothingSelected(p0: AdapterView<*>?) {
                }
            }

        binding.crowdsourceRegistrationLanguage

        binding.crowdsourceRegistrationButton.setOnClickListener(View.OnClickListener {
            val name = binding.crowdsourceRegistrationNameTextField.text.toString()
            val age = binding.crowdsourceRegistrationAgeTextField.text.toString()
            val phoneNumber = binding.crowdsourceRegistrationNumberTextField.text.toString()
            val gender: Gender? = getGender()
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
            val education: Education =
                Education.values()
                    .filter { education: Education -> education.displayName == binding.crowdsourceRegistrationEducation.selectedItem.toString() }[0]
            val occupation = binding.crowdsourceRegistrationOccupationTextField.text.toString()

            viewModel.setData(
                name,
                age,
                phoneNumber,
                gender,
                state,
                district,
                jobType,
                education,
                occupation,
                language
            )
        })
    }


    private fun populateStateList(): MutableList<String> {
        val inputStream =
            requireContext().assets.open("location.json").bufferedReader().use { it.readText() }
        val jsonObj = JSONObject(inputStream)

        //District
        //Getting the district keys
        val stateKeys = jsonObj.names()
        val stateNames: MutableList<String> = mutableListOf()
        if (stateKeys != null) {
            for (key in 0 until stateKeys.length()) {
                stateNames.add(
                    jsonObj.getJSONObject(stateKeys[key].toString()).get("name").toString()
                )
            }
        } else {
            print("District keys are empty")
        }
        return stateNames
    }

    private fun getDistrictList(state: String): MutableList<String> {
        val stateKey = state.replace(" ", "_").lowercase()
        println(stateKey)
        val inputStream =
            requireContext().assets.open("location.json").bufferedReader().use { it.readText() }
        val jsonObj = JSONObject(inputStream)
        val districtDetails = jsonObj.getJSONObject(stateKey).getJSONObject("district")
        val districtNames: MutableList<String> = mutableListOf()
        if (districtDetails.names() != null) {
            for (key in 0 until districtDetails.names().length()) {
                val districtKey: String = districtDetails.names()[key].toString()
                val districtName: String =
                    districtDetails.getJSONObject(districtKey.toString()).getString("name")
                districtNames.add(districtName)
                println(districtDetails.getJSONObject(districtKey.toString()))
            }
        }
//        val districtNames: MutableList<String> = mutableListOf()
//        println("The district names are $districtKeys")
        return districtNames

    }

    private fun setSpinner(values: List<String>, spinner: Spinner) {
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, values)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = adapter
    }

    private fun getGender(): Gender? {
        val selectedChipId = binding.crowdsourceRegistrationgenderChipGroup.checkedChipId
        if (selectedChipId != -1) {
            val chip: Chip =
                binding.crowdsourceRegistrationgenderChipGroup.findViewById(selectedChipId)
            return Gender.valueOf(chip.text.toString().lowercase())
        }
        return null
    }

    private fun updateViewModel() {
        viewModel
    }

}





















