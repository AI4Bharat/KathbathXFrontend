import 'dart:async';

import 'package:flutter_sound/public/flutter_sound_player.dart';

Future<FlutterSoundPlayer> initAudioPlayer(FlutterSoundPlayer player) async {
  FlutterSoundPlayer? audioPlayer;
  try {
    audioPlayer = await player.openPlayer();
  } catch (_) {
    throw "Failed to open audio player";
  }
  try {
    await audioPlayer!
        .setSubscriptionDuration(const Duration(milliseconds: 100));
  } catch (e) {
    throw "Failed to add subscription to audioplayer $e";
  }

  return audioPlayer;
}

Future<bool> startAudioPlayerPlaying(FlutterSoundPlayer audioPlayer,
    String filePath, Function updateProvider) async {
  try {
    assert(audioPlayer.isOpen(), "Audio player is not open");
    await audioPlayer.startPlayer(
      fromURI: filePath,
      sampleRate: 44100,
    );
    return true;
  } catch (e) {
    throw "Error occured while starting the player $e";
  }
}

Future<bool> stopAudioPlayerPlaying(FlutterSoundPlayer audioPlayer) async {
  try {
    if (!audioPlayer.isPlaying) {
      return true;
    }
    await audioPlayer.stopPlayer();
    return true;
  } catch (e) {
    throw "Error occured while stoping the player $e";
  }
}

Future<bool> pauseAudioPlayerPlaying(FlutterSoundPlayer audioPlayer) async {
  try {
    if (!audioPlayer.isPlaying) {
      return true;
    }
    await audioPlayer.pausePlayer();
    return true;
  } catch (e) {
    throw "Error occured while stoping the player $e";
  }
}

Future<bool> resumeAudioPlayerPlaying(FlutterSoundPlayer audioPlayer) async {
  try {
    if (!audioPlayer.isPaused) {
      return true;
    }
    await audioPlayer.resumePlayer();
    return true;
  } catch (e) {
    throw "Error occured while stoping the player $e";
  }
}
