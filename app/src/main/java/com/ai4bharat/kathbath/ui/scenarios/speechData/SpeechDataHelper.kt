package com.ai4bharat.kathbath.ui.scenarios.speechData


fun getInstructionSentence(language: String): String {
    when (language) {
        "Bodo" -> return "बिथोनः अन्नानै ब 'ड' रावाव रायज्लाय। / Please speak in $language"
        "Assamese" -> return "নিৰ্দেশ: অনুগ্ৰহ কৰি অসমীয়াত কওক / Please speak in $language"
        "Bengali" -> return "নির্দেশ: দয়া করে বাংলায় কথা বলুন | / Please speak in $language"
        "Dogri" -> return "निर्देशः कृपा करियै डोगरी च बोल्लो ।/ Please speak in $language"
        "Gujarati" -> return "સૂચનાઓઃ મહેરબાની કરીને ગુજરાતીમાં બોલો / Please speak in $language"
        "Hindi" -> return "निर्देशः कृपया हिंदी में बात करें। / Please speak in $language"
        "Kannada" -> return "ಸೂಚನೆಗಳು: ದಯವಿಟ್ಟು ಕನ್ನಡದಲ್ಲಿ ಮಾತನಾಡಿ / Please speak in $language"
        "Kashmiri" -> return " مہربٲنۍ کٔرِتھ کٔرِو کٲشِر پٲٹھۍ کَتھ۔"
        "Konkani" -> return "सुचोवणीः उपकार करून कोंकणी भाशेंत उलय. / Please speak in $language"
        "Maithili" -> return "निर्देश: कृपया मैथिली मे गप करू। / Please speak in $language"
        "Malayalam" -> return "നിർദ്ദേശം: ദയവായി മലയാളത്തിൽ സംസാരിക്കുക / Please speak in $language"
        "Manipuri" -> return "ꯏꯟꯁꯇ꯭ꯔꯛꯁꯟꯁꯤꯡ: ꯆꯥꯟꯕꯤꯗꯨꯅ ꯃꯥꯅꯤꯄꯨꯔꯤꯗ ꯋꯥ ꯉꯥꯡꯕꯤꯌꯨ / Please speak in $language"
        "Marathi" -> return "सूचनाः कृपया मराठीमध्ये बोला. / Please speak in $language"
        "Nepali" -> return "निर्देशनः कृपया नेपालीमा बोल्नुहोस् / Please speak in $language"
        "Odia" -> return "ନିର୍ଦ୍ଦେଶ: ଦୟା କରି ଓଡ଼ିଆରେ କଥା ହୁଅନ୍ତୁ / Please speak in $language"
        "Punjabi" -> return "ਨਿਰਦੇਸ਼ਃ ਕ੍ਰਿਪਾ ਕਰਕੇ ਪੰਜਾਬੀ ਵਿੱਚ ਬੋਲੋ। / Please speak in $language"
        "Sanskrit" -> return "निर्देशाः कृपया संस्कृतभाषायां भाषयन्तु। / Please speak in $language"
        "Santali" -> return "ᱢᱮᱱᱛᱮᱭᱟᱜ ᱺ ᱫᱟᱭᱟ ᱠᱟᱛᱮ ᱥᱟᱱᱛᱟᱲᱤᱛᱮ ᱨᱚᱲ ᱢᱮ ᱾ / Please speak in $language"
        "Sindhi" -> return "हिदायत: महिरबानी करे सिंधीअ में ॻाल्हायो। / Please speak in $language"
        "Tamil" -> return "அறிவுறுத்தல் தயவுசெய்து தமிழில் பேசுங்கள் / Please speak in $language"
        "Telugu" -> return "సూచనలుః దయచేసి తెలుగులో మాట్లాడండి. / Please speak in $language"
        "Urdu" -> return "ہدایت: براہ کرم اردو میں بات کریں"
        else -> return "Instruction: Please speak in $language"
    }
}