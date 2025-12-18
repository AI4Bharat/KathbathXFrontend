import 'package:flutter/foundation.dart';
import 'package:kathbath_lite/enums/audio_player_status.dart';

class AudioPlayerController extends ChangeNotifier {
  AudioPlayerStatus audioPlayerStatus = AudioPlayerStatus.NOT_OPEN;

  AsyncCallback? actionCallback;
  AsyncCallback? resetPlayerCallback;

  Future<void>? action() => actionCallback?.call();
  Future<void>? resetPlayer() => resetPlayerCallback?.call();

  void updateAudioPlayerStatus(AudioPlayerStatus status) {
    audioPlayerStatus = status;
    notifyListeners();
  }
}
