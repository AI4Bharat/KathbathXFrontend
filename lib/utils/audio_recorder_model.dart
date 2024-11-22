import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorderModel {
  final FlutterSoundRecorder recorder;
  bool isRecording = false;
  String filePath = '';
  String statusText = 'Idle';
  int recordingMinutes = 0;
  int recordingSeconds = 0;
  int recordingCentiseconds = 0;
  double duration = 0;

  AudioRecorderModel(this.filePath) : recorder = FlutterSoundRecorder();
}
