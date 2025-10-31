import 'dart:async';
import 'dart:io';

import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';

class AudioPlayerModel {
  late final FlutterSoundPlayer audioPlayer;
  bool fileExist = false;
  String filePath = '';
  Duration duration = Duration.zero;
  bool isPlaying = false;
  double? playbackPosition;
  StreamSubscription? audioPlayerStreamSubscription;

  AudioPlayerModel(this.filePath) : audioPlayer = FlutterSoundPlayer();

  Future<void> init() async {
    try {
      final file = File(filePath);
      fileExist = await file.exists();
      if (fileExist) {
        final fileStats = await file.stat();
        // 44 -> wav header size, 44100 -> sampling rate, 1-> single channel, 2 -> 2 bytes since we are using pcm16WAV
        final fileDuration = (fileStats.size - 44) / (44100 * 1 * 2);
        final durationInSeconds = double.parse(fileDuration.toStringAsFixed(3));
        duration = Duration(milliseconds: (durationInSeconds * 1000).toInt());
      } else {
        duration = Duration.zero;
      }
      await audioPlayer.openPlayer();
      await audioPlayer
          .setSubscriptionDuration(const Duration(milliseconds: 100));
    } catch (_) {
      throw "Failed to open audio player";
    }
  }

  Future<bool> startAndStopPlaying(
      RecorderPlayerInfoProvider recorderPlayerInfo) async {
    try {
      assert(audioPlayer.isOpen(), "Audio player is not open");
      recorderPlayerInfo.updateIsRecording(false);
      if (!fileExist) {
        return false;
      }
      if (audioPlayer.isPlaying) {
        await audioPlayer.stopPlayer();
        if (audioPlayerStreamSubscription != null) {
          audioPlayerStreamSubscription!.cancel();
        }
        isPlaying = false;
      } else {
        audioPlayerStreamSubscription = audioPlayer.onProgress!.listen((event) {
          recorderPlayerInfo.updateCurrentProgress(event.position);
        });
        await audioPlayer.startPlayer(
            fromURI: filePath,
            sampleRate: 44100,
            whenFinished: () {
              audioPlayerStreamSubscription?.cancel();
              recorderPlayerInfo.updateIsPlaying(false);
              isPlaying = false;
            });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> closeAudioPlayer() async {
    print("Called close audio player");
    await audioPlayer.closePlayer();
    filePath = '';
    fileExist = false;
    isPlaying = false;
    duration = Duration.zero;
  }
}
