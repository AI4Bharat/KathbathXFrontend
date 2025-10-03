import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/utils/audio_player_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PlayerWidget extends StatefulWidget {
  final double? duration;
  final String? filePath;
  final bool lPBar;
  final AudioPlayerModel playerModel;

  const PlayerWidget(
      {super.key,
      required this.filePath,
      this.duration,
      this.lPBar = true,
      required this.playerModel});

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  Duration? position;
  Duration? duration;

  onPlayPressed(rPProvider) async {
    rPProvider.stopAllRecorders();
    widget.playerModel.player.stop();

    final directory = await getApplicationDocumentsDirectory();
    String actualFilePath = '${directory.path}${widget.filePath}';
    final file = File(actualFilePath);

    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nothing to play'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ));
      return;
    }
    if (widget.playerModel.isPlaying) {
      rPProvider.stopPlaying(widget.playerModel);
    } else {
      widget.playerModel.duration = widget.duration!;
      rPProvider.playAudio(widget.playerModel, widget.filePath);
    }
  }

  @override
  void didUpdateWidget(covariant PlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.filePath != oldWidget.filePath) {
      // File path changed: reset player
      debugPrint('PlayerWidget: filePath changed -> reloading audio');

      // Stop and reset old player
      widget.playerModel.player.stop();
      widget.playerModel.playbackPosition = 0;
      widget.playerModel.isPlaying = false;

      // Optionally, pre-load or seek if you want smoother transitions
      // You can trigger a playerModel load if needed
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final recorderPlayerProvider = Provider.of<RecorderPlayerProvider>(context);
    recorderPlayerProvider.alreadyPlayed = false;
    if (!recorderPlayerProvider.alreadyPlayed) {
      widget.playerModel.playbackPosition = 0;
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.lPBar && widget.playerModel.duration != null)
                Expanded(
                  child: Consumer<RecorderPlayerProvider>(
                    builder: (context, playerModel, child) {
                      return StreamBuilder<Duration>(
                        stream: widget.playerModel.player.positionStream,
                        builder: (context, snapshot) {
                          position = snapshot.data ?? Duration.zero;
                          duration = Duration(
                              milliseconds:
                                  widget.playerModel.duration!.toInt());
                          return Column(
                            children: [
                              Slider(
                                min: 0.0,
                                max: duration!.inMilliseconds.toDouble(),
                                value: position!.inMilliseconds
                                    .toDouble()
                                    .clamp(0.0,
                                        duration!.inMilliseconds.toDouble()),
                                onChanged: (value) {
                                  widget.playerModel.player.seek(
                                      Duration(milliseconds: value.toInt()));
                                  widget.playerModel.isPlaying = true;
                                },
                              ),
                              Text(
                                '${position?.inMinutes}:${(position!.inSeconds % 60).toString().padLeft(2, '0')} / ${duration?.inMinutes}:${(duration!.inSeconds % 60).toString().padLeft(2, '0')}',
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(width: 2.0),
              ElevatedButton(
                onPressed: () {
                  if (recorderPlayerProvider.alreadyPlayed) {
                    widget.playerModel.player
                        .seek(const Duration(milliseconds: 0));
                    setState(() {
                      widget.playerModel.isPlaying = true;
                    });
                    recorderPlayerProvider.stopAllPlayers();
                    widget.playerModel.player.play();
                  } else {
                    onPlayPressed(recorderPlayerProvider);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 6.0,
                  padding: EdgeInsets.zero,
                ),
                child: Image.asset(
                  widget.playerModel.isPlaying
                      ? 'assets/icons/ic_speaker_active.png'
                      : 'assets/icons/ic_speaker_disabled.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.playerModel.player.dispose();
    super.dispose();
  }
}
