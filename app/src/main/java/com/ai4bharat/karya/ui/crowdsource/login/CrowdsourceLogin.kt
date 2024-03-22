package com.ai4bharat.karya.ui.crowdsource.login

import androidx.fragment.app.viewModels
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.ai4bharat.karya.R

class CrowdsourceLogin : Fragment() {

    companion object {
        fun newInstance() = CrowdsourceLogin()
    }

    private val viewModel: CrowdsourceLoginViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // TODO: Use the ViewModel
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_crowdsource_login, container, false)
    }
}