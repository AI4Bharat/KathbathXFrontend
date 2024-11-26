import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:karya_flutter/utils/audio_player_model.dart';
import 'package:karya_flutter/utils/audio_recorder_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';

class RecorderPlayerProvider extends ChangeNotifier {
  final List<AudioPlayerModel> _players = [];
  final List<AudioRecorderModel> _recorders = [];

  bool _isRecording = false;
  bool _isPlaying = false;

  bool alreadyPlayed = false;
  Timer? _timer;

  int pos = 0;
  double _duration = 0.0;

  //getters
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  double get duration => _duration;
  // ignore: unused_field
  StreamSubscription? _recorderSubscription;

  RecorderPlayerProvider() {
    _initialize();
  }

// ignore: camel_case_types
  Future<void> _initialize() async {
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  void addPlayer(AudioPlayerModel player) {
    _players.add(player);
  }

  void removePlayer(AudioPlayerModel player) {
    _players.remove(player);
    notifyListeners();
  }

  void addRecorder(AudioRecorderModel recorder) {
    _recorders.add(recorder);
    notifyListeners();
  }

  void removeRecorder(AudioRecorderModel recorder) {
    _recorders.remove(recorder);
    notifyListeners();
  }

  Future<void> stopAllPlayers() async {
    for (AudioPlayerModel player in _players) {
      if (player.isPlaying) {
        await stopPlaying(player);
        player.isPlaying = false;
      }
    }
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> stopAllRecorders() async {
    for (AudioRecorderModel recorder in _recorders) {
      if (recorder.isRecording) {
        await stopRecording(recorder);
        recorder.isRecording = false;
      }
    }
    _isRecording = false;
    notifyListeners();
  }

  void _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker |
              AVAudioSessionCategoryOptions.mixWithOthers,
    ));
  }

  Future<void> startRecording(
      AudioRecorderModel recorder, String filePath) async {
    _configureAudioSession();
    alreadyPlayed = false;
    addRecorder(recorder);
    await recorder.recorder.openRecorder();
    final directory = await getApplicationDocumentsDirectory();
    recorder.filePath = '${directory.path}$filePath';
    log("RECORDING FILEPATH: ${recorder.filePath} ");

    await recorder.recorder.startRecorder(
      toFile: recorder.filePath,
      codec: Codec.pcm16WAV,
    );
    await recorder.recorder.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
    _recorderSubscription = recorder.recorder.onProgress!.listen((event) {
      final recDuration = event.duration;
      recorder.recordingMinutes = recDuration.inMinutes;
      recorder.recordingSeconds = recDuration.inSeconds % 60;
      _duration = recDuration.inMilliseconds.toDouble();
      notifyListeners();
    });
    recorder.isRecording = true;
    _isRecording = true;
    recorder.statusText = 'Recording...';
    notifyListeners();
  }
  //////////////////////Recorder timer////////////////////////////////////

  Future<void> stopRecording(AudioRecorderModel recorder) async {
    if (recorder.isRecording) {
      await recorder.recorder.stopRecorder();
      recorder.isRecording = false;

      _isRecording = false;
      recorder.statusText = 'Recording Stopped';
      recorder.duration = (recorder.recordingSeconds.toDouble() +
          recorder.recordingCentiseconds / 100.0);
      notifyListeners();
    }
  }

  Future<void> playAudio(AudioPlayerModel player, String? filePath) async {
    alreadyPlayed = true;
    await stopAllPlayers();
    addPlayer(player);
    if (filePath != null) {
      final directory = await getApplicationDocumentsDirectory();
      player.filePath = '${directory.path}$filePath';
      log("player filepath : ${player.filePath}");
      File file = File(player.filePath);
      if (await file.exists()) {
        player.playbackPosition = 0;
        notifyListeners();
        if (!player.isPlaying) {
          player.player.setAudioSource(AudioSource.file(player.filePath));
          await player.loadAudioDuration();
          _duration = player.duration!;
          notifyListeners();
          player.isPlaying = true;
          player.player.play();
          player.player.positionStream.listen((position) {
            player.playbackPosition = position.inMilliseconds.toDouble();
            notifyListeners();
          });

          player.player.playerStateStream.listen((state) {
            if (state.processingState == ProcessingState.completed) {
              // alreadyPlayed = true;
              player.playbackPosition = 0;
              // player.isPlaying = false;
              notifyListeners();
            }
          });
        }
      }
    }
  }

  Future<void> stopPlaying(AudioPlayerModel player) async {
    await player.player.stop();
    player.isPlaying = false;
    player.playbackPosition = 0; // Reset the playback position if needed
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var player in _players) {
      player.player.stop();
      player.player.dispose();
    }
    for (var recorder in _recorders) {
      recorder.recorder.closeRecorder();
    }
    super.dispose();
  }
}
