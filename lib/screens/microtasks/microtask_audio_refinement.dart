import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/providers/recorder_player_providers.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/utils/audio_player_model.dart';
import 'package:karya_flutter/utils/save_input.dart';
import 'package:karya_flutter/widgets/audio_controls_widget.dart';
import 'package:karya_flutter/widgets/instruction_widget.dart';
import 'package:karya_flutter/widgets/player_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SpeechAudioScreen extends StatefulWidget {
  final KaryaDatabase db;

  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  const SpeechAudioScreen(
      {super.key,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<SpeechAudioScreen> createState() => _SpeechAudioScreenState();
}

class _SpeechAudioScreenState extends State<SpeechAudioScreen> {
  String? inputAudioPromptFilename;
  String? inputAudioPromptPath;
  String? inputAudioResponseFilename;
  String? inputAudioResponsePath;
  double? recordingDuration = 0;

  String? assignmentId;
  String? filePath;
  String? recordFilePath;

  bool isAudioPromptInputPresent = false;
  bool isAudioResponseInputPresent = false;
  bool isSentenceOutputPresent = false;

  var microNum = 0;

  late Dio dio;
  late ApiService apiService;

  late final MicroTaskAssignmentDao _microTaskAssignmentDao;
  @override
  void initState() {
    super.initState();
    _microTaskAssignmentDao = widget.db.microTaskAssignmentDao;
    _initializeInputs();
  }

  void _initializeInputs() async {
    await _updateAudio();
  }

  Future<bool> updateDbIfCompleted() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$assignmentId.wav';
    File file = File(filePath);
    bool fileExists = await file.exists();
    if (fileExists) {
      final recorderPlayerProvider =
          Provider.of<RecorderPlayerProvider>(context, listen: false);
      final duration = recorderPlayerProvider.duration / 1000;
      _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
          assignmentId!, MicrotaskAssignmentStatus.COMPLETED);
      String fileJson =
          '{"data":{"duration":$duration},"files":{"recording":"$assignmentId.wav"}}';
      _microTaskAssignmentDao.updateMicrotaskAssignmentOutputFile(
          assignmentId!, fileJson);
    } else {
      log('File does not exist at $filePath');
    }
    return fileExists;
  }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<void> _updateAudio() async {
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          isAudioPromptInputPresent = inputJson['files'] != null &&
              inputJson['files']['audio_prompt'] != null;
          isAudioResponseInputPresent = inputJson['files'] != null &&
              inputJson['files']['audio_response'] != null;

          inputAudioPromptFilename = inputJson['files']['audio_prompt'];
          inputAudioResponseFilename = inputJson['files']['audio_response'];
          //log("Filename: $inputAudioResponseFilename");
        });

        List<MicroTaskAssignmentRecord> relevantAssignments = widget
            .microtaskAssignments
            .where((assignment) =>
                assignment.microtaskId == widget.microtasks[microNum].id)
            .toList();
        setState(() {
          assignmentId = relevantAssignments[0].id;
          recordFilePath = '/$assignmentId.wav';
        });

        Map<String, String>? inputPaths = await saveAssignmentFilesCheckExists(
            widget.microtasks[microNum].id, assignmentId!,
            audioFilename: inputAudioPromptFilename,
            recordingFilename: inputAudioResponseFilename);
        if (inputPaths == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "One or more required input files are missing. Please report this assignmentID to admin")),
          );
          return;
        }
        setState(() {
          inputAudioPromptPath = inputPaths['audio_prompt_path'];
          inputAudioResponsePath = inputPaths['recording_path'];
        });
      } catch (e) {
        log('Error decoding Json: $e');
      }
    }
  }

  void callToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  void showSkipDialog(bool moreTask) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Skip Assignment'),
          content: const Text('Are you sure you want to skip this assignment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  updateSkippedAssignment();
                  callToast('Skipped');
                  if (moreTask) {
                    ++microNum;
                    _updateAudio();
                  } else {
                    callToast('No more tasks');
                    setState(() {
                      ++microNum;
                    });
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Audio Refinement Microtask"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const InstructionWidget(
                  sentence: "Listen to both the audios and respond"),
              const SizedBox(height: 8.0),

              // Audio Prompt Input
              isAudioPromptInputPresent
                  ? (inputAudioPromptPath == null
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex:
                                      2, // Use a ratio for how much space this should take
                                  child: Text(
                                    'Instruction audio:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2, // Limit the lines to 2
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: PlayerWidget(
                                    filePath: inputAudioPromptPath!,
                                    duration: 4,
                                    lPBar: true,
                                    playerModel:
                                        AudioPlayerModel(inputAudioPromptPath!),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 10.0), // Space between Row and Divider
                            const Divider(
                              thickness: 1.0,
                              color: Colors.grey,
                              height: 10.0,
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ))
                  : const SizedBox.shrink(),

              // Recording Output
              isAudioResponseInputPresent
                  ? (inputAudioResponsePath == null
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex:
                                  2, // Use a ratio for how much space this should take
                              child: Text(
                                'Test Audio: ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: PlayerWidget(
                                filePath: inputAudioResponsePath!,
                                duration: recordingDuration,
                                playerModel:
                                    AudioPlayerModel(inputAudioResponsePath!),
                              ),
                            ),
                          ],
                        ))
                  : const SizedBox.shrink(),

              const SizedBox(height: 10),

              const Text(
                'Recorder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 1.0,
                color: Colors.grey,
                height: 10.0,
              ),

              AudioControlsWidget(
                  filePath: recordFilePath ?? '',
                  progress: 40.0,
                  onBackPressed: () {
                    if (microNum > 0) {
                      setState(() {
                        microNum--;
                        _updateAudio();
                      });
                    } else {
                      callToast('No previous task');
                    }
                  },
                  onNextPressed: () async {
                    bool recordDone = await updateDbIfCompleted();
                    print("Recording done?: $recordDone");
                    // sendOutputFile(assignmentId!);
                    if (microNum < widget.microtasks.length - 1) {
                      if (recordDone) {
                        setState(() {
                          ++microNum;
                          _updateAudio();
                        });
                      } else {
                        showSkipDialog(true);
                      }
                    } else {
                      if (!recordDone) {
                        showSkipDialog(false);
                      } else {
                        callToast('No more tasks');
                        setState(() {
                          ++microNum;
                        });
                        Navigator.pop(context);
                      }
                    }
                  })
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
