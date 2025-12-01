import 'package:flutter/material.dart';
import 'package:kathbath_lite/enums/audio_player_status.dart';

class AudioPlayerController extends ChangeNotifier {
  AudioPlayerStatus audioPlayerStatus = AudioPlayerStatus.NOT_OPEN;

  VoidCallback? actionCallback;

  void action() => actionCallback?.call();

  void updateAudioPlayerStatus(AudioPlayerStatus status) {
		print("2. Update audio player status called with $status");
    audioPlayerStatus = status;
    notifyListeners();
  }
}
