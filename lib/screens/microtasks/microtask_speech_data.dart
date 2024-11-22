import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/providers/recorder_player_providers.dart';
import 'package:karya_flutter/widgets/audio_controls_widget.dart';
import 'package:karya_flutter/widgets/display_screen_widget.dart';
import 'package:karya_flutter/widgets/instruction_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SpeechRecordingScreen extends StatefulWidget {
  final KaryaDatabase db;
  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  const SpeechRecordingScreen(
      {super.key,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<SpeechRecordingScreen> createState() => _SpeechRecordingScreenState();
}

class _SpeechRecordingScreenState extends State<SpeechRecordingScreen> {
  String? _sentence;
  String? assignmentId;
  String? filePath;
  var microNum = 0;

  late final MicroTaskAssignmentDao _microTaskAssignmentDao;
  @override
  void initState() {
    super.initState();
    _microTaskAssignmentDao = widget.db.microTaskAssignmentDao;
    _initializeValues();
  }

  void _initializeValues() async {
    _updateSentence();
  }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<bool> updateDbIfCompleted() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$assignmentId.wav';
    File file = File(filePath);
    bool fileExists = await file.exists();
    if (fileExists) {
      final recorderPlayerProvider =
          Provider.of<RecorderPlayerProvider>(context, listen: false);
      final duration = recorderPlayerProvider.duration;
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

  Future<void> _updateSentence() async {
    // log("Microtask length= ${widget.microtasks.length} and current microtask: $microNum");
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          _sentence = inputJson['data']['sentence'] ?? 'No sentence found';
        });

        List<MicroTaskAssignmentRecord> relevantAssignments = widget
            .microtaskAssignments
            .where((assignment) =>
                assignment.microtaskId == widget.microtasks[microNum].id)
            .toList();
        setState(() {
          assignmentId = relevantAssignments[0].id;
          filePath = '/$assignmentId.wav';
        });
      } catch (e) {
        log('Error decoding JSON: $e');
        setState(() {
          _sentence = 'Error decoding JSON';
        });
      }
    }
  }

  void callToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 500),
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
                    _updateSentence();
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
          title: const Text("Speech Recording Microtask"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //////////////////////////////////////Recording Instruction/////////////////////////////////////////////

              const InstructionWidget(sentence: "Record the sentence below"),

              const SizedBox(height: 16.0),
              LinearProgressIndicator(
                value: (widget.microtasks.isNotEmpty
                    ? microNum / widget.microtasks.length
                    : 0.0),
                minHeight: 8.0,
                backgroundColor: Colors.grey[200],
                color: Colors.orange,
              ),
              const SizedBox(height: 16.0),
              //////////////////////////////////Sentence to record box////////////////////////////////////////////
              SentenceDisplayWidget(sentence: _sentence ?? ''),

              ///////////////////////Audio Controls Widget///////////////////////////////
              AudioControlsWidget(
                  filePath: filePath ?? '',
                  progress: 40.0,
                  onBackPressed: () {
                    if (microNum > 0) {
                      setState(() {
                        microNum--;
                        _updateSentence();
                      });
                    } else {
                      callToast('No previous task');
                    }
                  },
                  onNextPressed: () async {
                    bool recordDone = await updateDbIfCompleted();
                    if (microNum < widget.microtasks.length - 1) {
                      if (recordDone) {
                        setState(() {
                          ++microNum;
                          _updateSentence();
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
