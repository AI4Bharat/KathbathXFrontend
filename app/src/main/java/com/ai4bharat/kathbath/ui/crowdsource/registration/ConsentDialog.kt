package com.ai4bharat.kathbath.ui.crowdsource.registration

import android.app.AlertDialog
import android.content.Context
import android.text.Html
import android.text.Spanned
import android.text.method.LinkMovementMethod
import android.widget.TextView
import com.ai4bharat.kathbath.R

object ConsentDialog {

    fun showConsentForm(
        context: Context,
        actionFunction: (input: Boolean) -> Unit,
        language: String = "english"
    ) {
        val builder = AlertDialog.Builder(context)

        builder.setTitle("Consent Form")
        val consentText = getConsentFormText(language, context)
        println("The consent text for the language $language is $consentText")
        builder.setMessage(text2html(getConsentFormText(language, context)))

        builder.setPositiveButton("Agree") { dialog, a ->
            println("Agree to consent")
            actionFunction(true)
        }

        builder.setNegativeButton("Disagree") { dialog, a ->
            println("Disagree to consent")
            actionFunction(false)
        }

        val dialog = builder.create()
        dialog.show()

        val textView: TextView? = dialog.findViewById(android.R.id.message)
        if (textView != null) {
            println("The text view is not null")
            textView.movementMethod = LinkMovementMethod.getInstance()
        } else {
            println("The text view is null")
        }

    }

    private fun text2html(text: String): Spanned {
        return Html.fromHtml(text, Html.FROM_HTML_MODE_LEGACY)
    }

    private fun getConsentFormText(language: String, context: Context): String {
        val consent: String;
        when (language) {
            "assamese" -> {
                consent = context.getString(R.string.consent_form_text_assamese)
            }

            "bengali" -> {
                consent = context.getString(R.string.consent_form_text_bengali)
            }

            "urdu" -> {
                consent = context.getString(R.string.consent_form_text_urdu)
            }

            "telugu" -> {
                consent = context.getString(R.string.consent_form_text_telugu)
            }

            "tamil" -> {
                consent = context.getString(R.string.consent_form_text_tamil)
            }

            "marathi" -> {
                consent = context.getString(R.string.consent_form_text_marathi)
            }

            "kannada" -> {
                consent = context.getString(R.string.consent_form_text_kannada)
            }

            "hindi" -> {
                consent = context.getString(R.string.consent_form_text_hindi)
            }

            "gujarati" -> {
                consent = context.getString(R.string.consent_form_text_gujarati)
            }

            "odia" -> {
                consent = context.getString(R.string.consent_form_text_odia)
            }

            "maithili" -> {
                consent = context.getString(R.string.consent_form_text_maithili)
            }

            "bodo" -> {
                consent = context.getString(R.string.consent_form_text_bodo)
            }

            "nepali" -> {
                consent = context.getString(R.string.consent_form_text_nepali)
            }

            "kashmiri" -> {
                consent = context.getString(R.string.consent_form_text_kashmiri)
            }

            "manipuri" -> {
                consent = context.getString(R.string.consent_form_text_manipuri)
            }

            else -> {
                consent = context.getString(R.string.consent_form_text_english)
            }
        }
        val extraConsentText: String =
            "<h5>Read more about our privacy policy here <a href='https://ai4bharat.iitm.ac.in/kathbath-lite/'>link</a></h5>"
        return "$consent $extraConsentText"

    }

}