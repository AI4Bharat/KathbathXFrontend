import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';

class AudioRecorderModel {
  final String filePath;
  FlutterSoundRecorder? soundRecorder;
  bool isRecording = false;
  String statusText = 'Idle';
  int recordingMinutes = 0;
  int recordingSeconds = 0;
  int recordingCentiseconds = 0;
  double duration = 0;

  AudioRecorderModel(this.filePath) : soundRecorder = FlutterSoundRecorder();

  Future<bool> init() async {
    try {
      if (soundRecorder == null) {
        return false;
      }
      await soundRecorder!.openRecorder();
      await soundRecorder!
          .setSubscriptionDuration(const Duration(milliseconds: 100));
      return true;
    } catch (error) {
      print("Error occured while initializing the recorder");
      return true;
    }
  }

  Future<bool> startRecording() async {
    try {
      if (soundRecorder == null) {
        return false;
      }
      await soundRecorder!
          .startRecorder(toFile: filePath, codec: Codec.pcm16WAV, sampleRate: 44100);
      isRecording = true;
      return true;
    } catch (_) {
      isRecording = false;
      return false;
    }
  }

  Future<void> stopRecording() async {
    isRecording = false;
    if (soundRecorder == null) {
      return;
    }
    final fileLocation = await soundRecorder!.stopRecorder();
    print("\n\n the finale path location is ${fileLocation}");
  }

  Future<void> closeRecorder() async {
    isRecording = false;
    if (soundRecorder != null) {
      await soundRecorder!.closeRecorder();
    }
  }
}
