import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/enums/audio_recorder_status.dart';
import 'package:kathbath_lite/providers/audio_recorder_controller.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';
import 'package:kathbath_lite/widgets/buttons/icon_with_text_button.dart';

// ignore: must_be_immutable
class AudioRecorderWidget extends StatefulWidget {
  final String filePath;
  final AudioRecorderController audioRecorderController;

  AudioRecorderWidget(
      {required this.filePath, required this.audioRecorderController});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidget();
}

class _AudioRecorderWidget extends State<AudioRecorderWidget> {
  bool loading = false;
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();
  StreamSubscription? _streamSubscription;
  Duration recordedDuration = Duration.zero;
  AudioRecorderStatus audioRecorderStatus = AudioRecorderStatus.NOT_OPEN;

  @override
  void initState() {
    super.initState();
    initAudioRecorder();
    widget.audioRecorderController.actionCallback = onClick;
  }

  Future<void> initAudioRecorder() async {
    updateLoadingStatus(true);
    try {
      final tmpAudioRecorder = await audioRecorder.openRecorder();
      updateAudioRecorderStatus(AudioRecorderStatus.OPEN);
      audioRecorder = tmpAudioRecorder!;
      await audioRecorder
          .setSubscriptionDuration(const Duration(milliseconds: 100));
    } catch (error) {
      updateLoadingStatus(false);
      throw Exception("Error occured while initializing audio recorder $error");
    }

    try {
      audioRecorder.onProgress!.listen((event) {
        updateRecordingDuration(event.duration);
      });
    } catch (e) {
      updateLoadingStatus(false);
      throw Exception(
          "Error occurded while setting progress listener in audio recorder $e");
    }
    updateLoadingStatus(false);
  }

  Future<void> startAudioRecording() async {
    print("Start recorder called");
    try {
      updateRecordingDuration(Duration.zero);
      await audioRecorder.startRecorder(
          toFile: widget.filePath, codec: Codec.pcm16WAV, sampleRate: 44100);
      updateAudioRecorderStatus(AudioRecorderStatus.RECORDING);
    } catch (e) {
      updateLoadingStatus(false);
      throw Exception("Error occured while starting the recorder $e");
    }
  }

  Future<void> stopAudioRecoding() async {
    try {
      await audioRecorder.stopRecorder();
      updateAudioRecorderStatus(AudioRecorderStatus.STOPPED);
    } catch (e) {
      updateLoadingStatus(false);
      throw Exception("Error occured while stopping the recorder $e");
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return loading ? const CircularProgressIndicator() : _recorderWidget();
  }

  @override
  void dispose() {
    audioRecorder.closeRecorder();
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
    updateAudioRecorderStatus(AudioRecorderStatus.NOT_OPEN);

    super.dispose();
  }

  void updateLoadingStatus(bool status) {
    setState(() {
      loading = status;
    });
  }

  void updateRecordingDuration(Duration duration) {
    setState(() {
      recordedDuration = duration;
    });
  }

  void updateAudioRecorderStatus(AudioRecorderStatus status) {
    widget.audioRecorderController.updateAudioRecorderStatus(status);
    setState(() {
      audioRecorderStatus = status;
    });
  }

  void onClick() {
    if (audioRecorderStatus == AudioRecorderStatus.RECORDING) {
      stopAudioRecoding();
    } else if (audioRecorderStatus == AudioRecorderStatus.OPEN ||
        audioRecorderStatus == AudioRecorderStatus.STOPPED) {
      startAudioRecording();
    }
  }

  Widget _recorderWidget() {
    return Text(
        style: const TextStyle(fontSize: 36),
        convertDurationToString(recordedDuration));
  }
}
