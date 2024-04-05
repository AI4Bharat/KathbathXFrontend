package com.ai4bharat.karya.ui.crowdsource.registration

import android.app.AlertDialog
import android.content.Context
import android.text.Html
import android.text.Spanned
import com.ai4bharat.karya.R

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
    }

    private fun text2html(text: String): Spanned {
        return Html.fromHtml(text, Html.FROM_HTML_MODE_COMPACT)
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
        return consent

    }

}