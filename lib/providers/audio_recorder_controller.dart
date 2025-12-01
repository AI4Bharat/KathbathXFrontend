import 'package:flutter/material.dart';
import 'package:kathbath_lite/enums/audio_recorder_status.dart';

class AudioRecorderController extends ChangeNotifier {
  AudioRecorderStatus audidRecorderStatus = AudioRecorderStatus.NOT_OPEN;
  VoidCallback? actionCallback;

  void action() => actionCallback?.call();

  void updateAudioRecorderStatus(AudioRecorderStatus status) {
    audidRecorderStatus = status;
    notifyListeners();
  }
}
