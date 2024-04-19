package com.ai4bharat.karya.ui.base

import android.app.ActivityManager
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import com.ai4bharat.karya.R
import com.ai4bharat.karya.data.manager.AUTH_STATUS
import com.ai4bharat.karya.data.manager.AuthManager
import com.ai4bharat.karya.utils.extensions.dataStore
import com.ai4bharat.karya.utils.extensions.viewLifecycle
import javax.inject.Inject

abstract class SessionFragment : BaseFragment {
    constructor() : super()
    constructor(@LayoutRes contentLayoutId: Int) : super(contentLayoutId)

    @Inject
    lateinit var authManager: AuthManager

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        authManager.currAuthStatus.observe(viewLifecycleOwner, Observer { authStatus ->
            println("The auth status is ${authStatus.name}")
        })
//        authManager.currAuthStatus.observe(viewLifecycleOwner, { authStatus ->
//            if (authStatus == AUTH_STATUS.UNAUTHENTICATED) {
//                println("The user has been logged out")
////        onSessionExpired()
//            }
//        })
        return super.onCreateView(inflater, container, savedInstanceState)
    }

//  protected open fun onSessionExpired() {
////    findNavController().navigate(R.id.action_global_loginFlow)
//    Runtime.getRuntime().exec("pm clear com.ai4bharat.karya");
//  }
}
