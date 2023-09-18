package com.ai4bharat.karya.ui.webRegistration

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import com.ai4bharat.karya.R
import com.ai4bharat.karya.ui.MainActivity

class ExternalForm : AppCompatActivity() {
    private lateinit var webView: WebView
    private var filePathCallback: ValueCallback<Array<Uri>>? = null
    private val FILE_UPLOAD_REQUEST_CODE = 1
    private fun isConnectedToInternet(): Boolean {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val networkInfo: NetworkInfo? = connectivityManager.activeNetworkInfo
        return networkInfo != null && networkInfo.isConnectedOrConnecting
    }
    private fun goToMainActivity() {
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (isConnectedToInternet()) {
            setContentView(R.layout.activity_external_form)
            webView = findViewById(R.id.webView)
            val webSettings: WebSettings = webView.settings

            // enable Javascript and prevent caching
            webSettings.javaScriptEnabled = true
            webSettings.cacheMode = WebSettings.LOAD_NO_CACHE

            /*
                webView.addJavascriptInterface(MyJavaScriptInterface(this), "AndroidBridge")
                To fire an action when a Javascript event (successful user registration) occurs
             */
            webView.webViewClient = WebViewClient()
            webView.webChromeClient = object : WebChromeClient() {
                override fun onShowFileChooser(
                    webView: WebView?,
                    filePathCallback: ValueCallback<Array<Uri>>?,
                    fileChooserParams: FileChooserParams?
                ): Boolean {
                    this@ExternalForm.filePathCallback = filePathCallback
                    val intent = Intent(Intent.ACTION_GET_CONTENT)
                    intent.type = "*/*" // Specify the MIME type you want to allow
                    startActivityForResult(intent, FILE_UPLOAD_REQUEST_CODE)
                    return true
                }
            }
            webView.loadUrl(getString(R.string.coordinator_training_form))
        } else {
            setContentView(R.layout.no_internet)
            val loginBtn = findViewById<Button>(R.id.loginBtn)
            loginBtn.setOnClickListener {
                goToMainActivity()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == FILE_UPLOAD_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                val selectedFileUri = data?.data
                if (selectedFileUri != null) {
                    val selectedFileArray = arrayOf(selectedFileUri)
                    filePathCallback?.onReceiveValue(selectedFileArray)
                    filePathCallback = null
                }
            } else {
                // Handle canceled file selection or other errors
                filePathCallback?.onReceiveValue(null)
                filePathCallback = null
            }
        }
    }
}