import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerModel {
  final AudioPlayer player;
  bool isPlaying = false;
  String filePath = '';
  double? playbackPosition;
  double? duration;

  AudioPlayerModel(this.filePath) : player = AudioPlayer();

  Stream<Duration> get _positionStream =>
      Rx.combineLatest2<Duration, Duration?, Duration>(
        player.positionStream,
        player.durationStream,
        (position, duration) => position,
      );

  Future<void> loadAudioDuration() async {
    try {
      await player.setFilePath(filePath);
      Duration? dur = await player.load();
      if (dur != null) {
        duration = dur.inMilliseconds.toDouble();
      } else {
        player.durationStream.listen((dur) {
          if (dur != null) {
            duration = dur.inMilliseconds.toDouble();
          }
        });
      }
    } catch (e) {
      log('Error loading audio file: $e');
    }
  }

  Future<void> resetPlayer() async {
    await player.seek(Duration.zero);
    playbackPosition = 0.0;
  }

  Future<void> stop() async {
    try {
      await player.stop();
      isPlaying = false;
      playbackPosition = 0.0;
    } catch (e) {
      log('Error stopping audio: $e');
    }
  }
}
