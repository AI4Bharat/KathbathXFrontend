package com.ai4bharat.karya.ui.dashboard

import android.app.AlertDialog
import android.app.Dialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.Window
import android.widget.Button
import com.ai4bharat.karya.R


class ReferralDialog(context: Context) : Dialog(context, R.style.ReferralDialogStyle) {
    init {
        setCancelable(true)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.referral_dialog)

        val referralButton: Button = findViewById(R.id.referralButton)

        referralButton.setOnClickListener(View.OnClickListener {
            openWebPage("https://wa.me/?text=This%20is%20a%20test%20message.%20Check%20out%20the%20url%20https%3A%2F%2Fhttps://ai4bharat.iitm.ac.in%2F")
            this.dismiss()
        })

    }


    private fun openWebPage(url: String) {
        println("The data was clicked")
        val webpage: Uri = Uri.parse(url)
        val intent = Intent(Intent.ACTION_VIEW, webpage)
        context.startActivity(intent)
    }
}