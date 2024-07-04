package com.ai4bharat.kathbath.ui.dashboard

import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.Button
import com.ai4bharat.kathbath.R
import com.ai4bharat.kathbath.data.model.karya.WorkerRecord
import java.net.URLEncoder


class ReferralDialog(context: Context, private val workerRecord: WorkerRecord?) :
    Dialog(context, R.style.ReferralDialogStyle) {

    init {
        setCancelable(true)
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.referral_dialog)

        val referralButton: Button = findViewById(R.id.referralButton)

        referralButton.setOnClickListener(View.OnClickListener {
//            openWebPage()
            val referralType = getReferralType()
            println("RDKT $referralType")
//            handleDifferentReferralType(referralType)
            handleDifferentReferralType("T2")

        })
    }


    private fun handleDifferentReferralType(referralType: String) {

        when (referralType) {
            "T1" -> openMultipleUser()
            "T2",
            "C" -> openWebPage()

            else -> {

            }
        }

    }

    private fun createReferralCode(): String? {
        if (workerRecord != null) {
            val karyaId: String? = workerRecord.id
            return karyaId
        }
        return null
    }

    private fun openMultipleUser() {
        val referralCode: String? = createReferralCode()
        if (referralCode != null) {
            val encodedUrl =
                "https://wa.me/?text=${
                    URLEncoder.encode(
                        "AI4Bharat has just launched an Android app to help collect audio data for Indian languages.\n" +
                                "\n" +
                                "Download the app from the Play Store, record your voice, and contribute to preserving our linguistic heritage. Your participation will make a huge difference! \n" +
                                "\n" +
                                "https://play.google.com/store/apps/details?id=com.ai4bharat.kathbath.lite&hl=en&gl=US&rutm_content=$referralCode",
                        "UTF-8"
                    )
                }"
            val webpage: Uri = Uri.parse(encodedUrl)
            val intent = Intent(Intent.ACTION_VIEW, webpage)
            this.cancel()
            context.startActivity(intent)
        }
        println("The data was clicked $referralCode")
    }


    private fun getReferralType(): String {
        return workerRecord?.profile?.asJsonObject?.get("referral_type").toString().trim('"')
    }

    private fun openWebPage() {
        val referralCode: String? = createReferralCode()
        if (referralCode != null) {
            val encodedUrl =
                "https://api.whatsapp.com/send/?phone=15550990252&text=${
                    URLEncoder.encode(
                        "Hi, send this message to start interacting with AI4Bharat.",
                        "UTF-8"
                    )
                }"
            val webpage: Uri = Uri.parse(encodedUrl)
            val intent = Intent(Intent.ACTION_VIEW, webpage)

            this.cancel()
            context.startActivity(intent)
        }
        println("The data was clicked $referralCode")
    }
}