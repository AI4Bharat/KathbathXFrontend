import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/utils/audio_recorder_model.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:path_provider/path_provider.dart';

class SpeechDataProvider extends ChangeNotifier {
  FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();
  String? audioFilePath;
  bool _loading = true;
  bool _fileExist = false;
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  get currentDuration => _currentDuration;
  get totalDuration => _totalDuration;
  get loading => _loading;
  get fileExist => _fileExist;

  Future<void> init(int microtaskAssignmentId) async {
    updateLoading(true);
    try {
      audioRecorder = await initAudioRecorder(audioRecorder);
      audioRecorder.onProgress!.listen((event) {
				updateTotalDuration(event.duration);
      });
    } catch (e) {
      updateLoading(false);
      rethrow;
    }
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioFile =
          File("${directory.path}/${microtaskAssignmentId.toString()}.wav");
      audioFilePath = audioFile.path;
      final fileExist = await audioFile.exists();
      if (fileExist) {
        final duration =
            await getAudioDurationFromFilePath(audioFilePath!, 44100, 1, 2);
        updateTotalDuration(Duration(seconds: duration.toInt()));
      }
      updateFileExist(fileExist);
      updateLoading(false);
    } catch (e) {
      updateLoading(false);
      rethrow;
    }
  }

  void updateFileExist(bool status) {
    _fileExist = status;
    notifyListeners();
  }

  void updateLoading(bool status) {
    _loading = status;
    notifyListeners();
  }

  void updateCurrentDuraion(Duration duration) {
    _currentDuration = duration;
    notifyListeners();
  }

  void updateTotalDuration(Duration duration) {
    _totalDuration = duration;
    notifyListeners();
  }

  void reset() async {
    await audioPlayer.closePlayer();
    await audioRecorder.closeRecorder();
    _currentDuration = Duration.zero;
    _totalDuration = Duration.zero;
    _fileExist = false;
    _loading = true;
    notifyListeners();
  }

  Future<bool> startRecording() async {
    if (audioFilePath == null) {
      throw Exception("Output file is not specified");
    }
    try {
      bool didRecordingStart =
          await startAudioRecorderRecording(audioRecorder, audioFilePath!);
      notifyListeners();
      return didRecordingStart;
    } catch (_) {}
    return false;
  }

  Future<void> stopRecording() async {
    if (!audioRecorder.isRecording) {
      return;
    }
    try {
      await stopAudioRecorderRecording(audioRecorder);
      notifyListeners();
      updateFileExist(true);
    } catch (_) {
      updateFileExist(false);
    }
  }
}
