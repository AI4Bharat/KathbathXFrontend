package com.ai4bharat.karya.ui.webRegistration

import android.content.Context
import android.content.Intent
import com.ai4bharat.karya.ui.MainActivity

class MyJavaScriptInterface(private val context: Context) {
    @android.webkit.JavascriptInterface
    fun goToMainActivity() {
        val intent = Intent(context, MainActivity::class.java)
        context.startActivity(intent)
    }
}