import 'package:kathbath_lite/models/registration_items.dart';

class LoginErrorItem {
  String? phoneNumber;
  String? language;
}

class LoginItem {
  String? phoneNumber = "8593071949";
  Language? language = Language.malayalam;

  void setLanguage(String? value) {
    if (value == null) {
      language = null;
    }
    language = Language.values.firstWhere((l) => l.toString() == value!);
  }
}

const Map<Language, int> languageCode = {
  Language.punjabi: 18,
  Language.urdu: 21,
  Language.sindhi: 20,
  Language.manipuri: 23,
  Language.dogri: 4,
  Language.bodo: 13,
  Language.maithili: 3,
  Language.sanskrit: 8,
  Language.kashmiri: 7,
  Language.nepali: 14,
  Language.telugu: 16,
  Language.assamese: 9,
  Language.bengali: 5,
  Language.odia: 6,
  Language.gujarati: 12,
  Language.marathi: 2,
  Language.kannada: 22,
  Language.konkani: 15,
  Language.hindi: 19,
  Language.malayalam: 10,
  Language.santali: 17,
  Language.tamil: 11
};
