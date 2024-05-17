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
            openWebPage()
        })

    }

    private fun createReferralCode(): String? {
        if (workerRecord != null) {
            val name = workerRecord.fullName
            val phoneNumber = workerRecord.accessCode
            return name?.subSequence(0, 2).toString() + phoneNumber.subSequence(8, 11).toString()
        }
        return null
    }

    private fun openWebPage() {
        val referralCode: String? = createReferralCode()
        if (referralCode != null) {
            val encodedUrl =
                "https://api.whatsapp.com/send/?text=${
                    URLEncoder.encode(
                        "This is a test message. Use the referral code $referralCode",
                        "UTF-8"
                    )
                }"
            val webpage: Uri = Uri.parse(encodedUrl)
            val intent = Intent(Intent.ACTION_VIEW, webpage)
            context.startActivity(intent)
        }
        println("The data was clicked $referralCode")

    }
}