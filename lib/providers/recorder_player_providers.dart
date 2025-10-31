import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';

class RecorderPlayerInfoProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _fileExist = false;
  final String filePath;
  Duration _totalDuration = Duration.zero;
  Duration _currentProgress = Duration.zero;

  RecorderPlayerInfoProvider({required this.filePath});

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get fileExist => _fileExist;

  Duration get totalDuration => _totalDuration;
  Duration get currentProgress => _currentProgress;

  int get totalDurationInSeconds => _totalDuration.inSeconds;
  String get totalDurationInString => convertDurationToString(_totalDuration);

  int get currentProgressInSeconds => _currentProgress.inSeconds;
  String get currentProgressInString =>
      convertDurationToString(_currentProgress);

  void updateFileExist(bool fileExist) {
    _fileExist = fileExist;
    notifyListeners();
  }

  void updateTotalDuration(Duration duration) {
    _totalDuration = duration;
    if (duration > Duration.zero) {
      _fileExist = true;
      _currentProgress = Duration.zero;
    }
    notifyListeners();
  }

  void updateCurrentProgress(Duration duration) {
    _currentProgress = duration;
    notifyListeners();
  }

  void updateIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  void updateIsRecording(bool isRecording) {
    _isRecording = isRecording;
    notifyListeners();
  }
}
