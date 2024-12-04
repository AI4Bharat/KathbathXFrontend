// ignore_for_file: constant_identifier_names

enum ScenarioType {
  SPEECH_DATA,
  SPEECH_VERIFICATION,
  TEXT_TRANSLATION,
  SIGN_LANGUAGE_VIDEO,
  SGN_LANG_VIDEO_VERIFICATION,
  XLITERATION_DATA,
  IMAGE_TRANSCRIPTION,
  IMAGE_LABELLING,
  QUIZ,
  IMAGE_DATA,
  SENTENCE_VALIDATION,
  SPEECH_TRANSCRIPTION,
  IMAGE_ANNOTATION,
  SENTENCE_CORPUS
}

extension ScenarioTypeExtension on ScenarioType {
  static const Map<ScenarioType, String> _values = {
    ScenarioType.SPEECH_DATA: "SPEECH DATA",
    ScenarioType.SPEECH_VERIFICATION: "SPEECH VERIFICATION",
    ScenarioType.TEXT_TRANSLATION: "TEXT TRANSLATION",
    ScenarioType.SIGN_LANGUAGE_VIDEO: "SIGN LANGUAGE_VIDEO",
    ScenarioType.SGN_LANG_VIDEO_VERIFICATION: "SIGN VIDEO VERIFICATION",
    ScenarioType.XLITERATION_DATA: "TRANSLITERATION DATA",
    ScenarioType.IMAGE_TRANSCRIPTION: "IMAGE TRANSCRIPTION",
    ScenarioType.IMAGE_LABELLING: "IMAGE LABELLING",
    ScenarioType.QUIZ: "QUIZ",
    ScenarioType.IMAGE_DATA: "IMAGE_DATA",
    ScenarioType.SENTENCE_VALIDATION: "SENTENCE_VALIDATION",
    ScenarioType.SPEECH_TRANSCRIPTION: "SPEECH_TRANSCRIPTION",
    ScenarioType.IMAGE_ANNOTATION: "IMAGE_ANNOTATION",
    ScenarioType.SENTENCE_CORPUS: "SENTENCE_CORPUS",
  };

  String get value => _values[this]!;

  String asString() => value;

  static ScenarioType fromString(String str) {
    return _values.entries
        .firstWhere((entry) => entry.value == str,
            orElse: () => throw ArgumentError('Invalid value: $str'))
        .key;
  }
}
