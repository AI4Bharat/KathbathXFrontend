import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/enums/audio_player_status.dart';
import 'package:kathbath_lite/providers/audio_player_controller.dart';
import 'package:kathbath_lite/utils/audio_utils.dart';

int SAMPLE_RATE = 44100;
int CHANNEL_COUNT = 1;

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final AudioPlayerController audioPlayerController;

  const AudioPlayerWidget(
      {super.key, required this.filePath, required this.audioPlayerController});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool loading = false;
  FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  Duration currentPlayerPosition = Duration.zero;
  Duration totalAudioDuration = Duration.zero;
  StreamSubscription? _streamSubscription;

  Future<void> _loadAudioFileDetails(String filePath) async {
    try {
      final audioFile = File(filePath);
      final fileExist = await audioFile.exists();
      if (fileExist) {
        final duration = await getAudioDurationFromFilePath(
            filePath, SAMPLE_RATE, CHANNEL_COUNT, 2);
        setState(() {
          totalAudioDuration =
              Duration(milliseconds: (duration * 1000).toInt());
        });
      }
    } catch (_) {
      updateLoading(false);
      rethrow;
    }
  }

  Future<void> initAudioPlayer() async {
    updateLoading(true);
    print("Init audio player called");
    try {
      final tmpAudioPlayer = await audioPlayer.openPlayer();
      updateAudioPlayerState(AudioPlayerStatus.OPEN);
      audioPlayer = tmpAudioPlayer!;
    } catch (_) {
      updateLoading(false);
      rethrow;
    }

    try {
      await audioPlayer
          .setSubscriptionDuration(const Duration(milliseconds: 100));
      _streamSubscription = audioPlayer.onProgress!.listen((event) {
        if (widget.audioPlayerController.audioPlayerStatus ==
            AudioPlayerStatus.PLAYING) {
          updateCurrentPosition(event.position);
        }
      });
    } catch (_) {
      updateLoading(false);
      rethrow;
    }

    try {
      _loadAudioFileDetails(widget.filePath);
    } catch (e) {
      updateLoading(false);
      rethrow;
    }
    updateLoading(false);
  }

  Future<void> startAudioPlayerPlaying() async {
		//TODO: If the audio file doesn't exist handle it properly
    if (!audioPlayer.isOpen()) {
      await initAudioPlayer();
    }
    try {
      await audioPlayer.startPlayer(
          fromURI: widget.filePath,
          sampleRate: SAMPLE_RATE,
          whenFinished: () {
            currentPlayerPosition = totalAudioDuration;
            updateAudioPlayerState(AudioPlayerStatus.STOPPED);
          });
      updateAudioPlayerState(AudioPlayerStatus.PLAYING);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> stopAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPlaying) {
        return true;
      }
      await audioPlayer.stopPlayer();
      updateAudioPlayerState(AudioPlayerStatus.STOPPED);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  Future<bool> pauseAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPlaying) {
        return true;
      }
      await audioPlayer.pausePlayer();
      updateAudioPlayerState(AudioPlayerStatus.PAUSED);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  Future<bool> resumeAudioPlayerPlaying() async {
    try {
      if (!audioPlayer.isPaused) {
        return true;
      }
      await audioPlayer.resumePlayer();
      updateAudioPlayerState(AudioPlayerStatus.PLAYING);
      return true;
    } catch (e) {
      throw "Error occured while stoping the player $e";
    }
  }

  Future<void> resetPlayer() async {
    try {
      await audioPlayer.closePlayer();
    } catch (e) {
      throw "While reseting player error occured while stoping the player $e";
    }
    updateCurrentPosition(Duration.zero);
    cancelAudioSubscription();
  }

  void cancelAudioSubscription() {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
      _streamSubscription = null;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.audioPlayerController.actionCallback = onClick;
    widget.audioPlayerController.resetPlayerCallback = resetPlayer;
    initAudioPlayer();
  }

  @override
  void dispose() {
    cancelAudioSubscription();
    audioPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return loading ? const CircularProgressIndicator() : _audioPlayer();
  }

  void updateLoading(bool status) {
    setState(() {
      loading = status;
    });
  }

  void updateCurrentPosition(Duration duration) {
    setState(() {
      currentPlayerPosition = duration;
    });
  }

  void updateAudioPlayerState(AudioPlayerStatus status) {
    print("1. Update audio player status called with $status");
    widget.audioPlayerController.updateAudioPlayerStatus(status);
  }

  Future<void> pausePlayerBeforeSeeking() async {
    if (audioPlayer.isStopped) {
      await startAudioPlayerPlaying();
    } else if (audioPlayer.isPaused) {
      await resumeAudioPlayerPlaying();
    }
    await pauseAudioPlayerPlaying();
  }

  Future<void> seekPlayer(Duration duration) async {
    if (!audioPlayer.isOpen()) {
      return;
    }
    if (audioPlayer.isPlaying) {
      await pauseAudioPlayerPlaying();
    }
    updateCurrentPosition(duration);
    await audioPlayer.seekToPlayer(duration);
    assert(
        audioPlayer.isPaused, "The audio player is not paused in seekPlayer()");
    resumeAudioPlayerPlaying();
  }

  Future<void> onClick() async {
    try {
      if (audioPlayer.isPlaying) {
        await pauseAudioPlayerPlaying();
      } else if (audioPlayer.isPaused) {
        await resumeAudioPlayerPlaying();
      } else if (audioPlayer.isStopped || audioPlayer.isOpen()) {
        startAudioPlayerPlaying();
      }
    } catch (e) {
      print("Exception occured while playing the audio $e");
      rethrow;
    }
  }

  Widget _audioPlayer() {
    TextStyle textStyle = const TextStyle(fontSize: 24);
    return Column(
      children: [
        Slider(
          value: currentPlayerPosition.inMilliseconds.toDouble(),
          min: 0,
          max: totalAudioDuration.inMilliseconds.toDouble(),
          onChangeStart: (double value) {
            pausePlayerBeforeSeeking();
          },
          onChanged: (double value) {
            updateCurrentPosition(Duration(milliseconds: value.toInt()));
          },
          onChangeEnd: (double value) {
            seekPlayer(Duration(milliseconds: value.toInt()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                style: textStyle,
                convertDurationToString(currentPlayerPosition)),
            Text(" / ", style: textStyle),
            Text(style: textStyle, convertDurationToString(totalAudioDuration)),
          ],
        )
      ],
    );
  }
}
