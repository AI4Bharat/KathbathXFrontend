import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/providers/checkbox_provider.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/utils/audio_player_model.dart';
import 'package:karya_flutter/utils/save_input.dart';
import 'package:karya_flutter/widgets/checkbox_list_widget.dart';
import 'package:karya_flutter/widgets/display_screen_widget.dart';
import 'package:karya_flutter/widgets/image_display_widget.dart';
import 'package:karya_flutter/widgets/instruction_widget.dart';
import 'package:karya_flutter/widgets/next_n_back_button._widget.dart';
import 'package:karya_flutter/widgets/player_widget.dart';
import 'package:provider/provider.dart';

class SpeechVerificationScreen extends StatefulWidget {
  final KaryaDatabase db;

  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  final dynamic taskName;

  const SpeechVerificationScreen(
      {super.key,
      required this.taskName,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<SpeechVerificationScreen> createState() =>
      _SpeechVerificationScreenState();
}

class _SpeechVerificationScreenState extends State<SpeechVerificationScreen> {
  AudioPlayerModel? inputAudioPlayerModel;
  AudioPlayerModel? recordingAudioPlayerModel;

  String? inputImageFilename;
  String? inputImagePath;
  String? inputAudioFilename;
  String? inputAudioPath;
  String? inputRecordingFilename;
  String? inputRecordingPath;
  double? recordingDuration = 0;

  String? _sentence;
  String? assignmentId;
  String? filePath;
  bool inputPresent = true;

  bool isSentenceInputPresent = false;
  bool isImageInputPresent = false;
  bool isAudioPromptInputPresent = false;
  bool isRecordingOutputPresent = false;
  bool isSentenceOutputPresent = false;
  bool isDecisionMade = false;
  final TextEditingController _commentController = TextEditingController();
  bool isValueFromDb = false;

  final Map<String, dynamic> evaluationMap = {"decision": null, "comments": ""};

  List<String> checkboxCommonOptions = [
    "low volume",
    "noise intermittent",
    "chatter intermittent",
    "noise persistent",
    "chatter persistent",
    "unclear audio",
    "off topic",
    "repeating content",
    "long pauses",
    "mispronunciation",
    "stretching",
    "objectionable content",
    "skipping words",
    "incorrect text prompt",
    "factual inaccuracy",
    "wrong language",
    "echo present",
    "wrong gender",
    "wrong age group",
    "duplicate speaker"
  ];
  List<String> extemporeOptions = [
    "reading prompt",
    "book read",
    "bad extempore quality",
  ];
  List<String> conversationsOptions = [
    "sst",
  ];

  List<String> displayOptions = [];

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
    _updateSentence();
    _updateImageAudio();
    _updateCheckboxValues();
    if (isAudioPromptInputPresent && inputAudioPath != null) {
      inputAudioPlayerModel = AudioPlayerModel(inputAudioPath!);
    }
    if (isRecordingOutputPresent && inputRecordingPath != null) {
      recordingAudioPlayerModel = AudioPlayerModel(inputRecordingPath!);
    }
  }

  Future<bool> updateDbIfCompleted() async {
    if (evaluationMap['decision'] == null) {
      return false;
    } else {
      _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
          assignmentId!, MicrotaskAssignmentStatus.COMPLETED);
      String fileJson = '{"data":${jsonEncode(evaluationMap)},"files":{}}';
      int updateStatus = await _microTaskAssignmentDao
          .updateMicrotaskAssignmentOutputFile(assignmentId!, fileJson);
      return (updateStatus == 1);
    }
  }

  Future<String?> getDecisionInDb() async {
    MicroTaskAssignmentRecord? currentAssignment =
        await _microTaskAssignmentDao.getMicroTaskAssignmentById(assignmentId!);
    if (currentAssignment!.output != null) {
      // log("Output file: ${currentAssignment.output}");
      var decodedJson = jsonDecode(currentAssignment.output!);
      var existingDecision = decodedJson['data']?['decision'];

      if (existingDecision != null) {
        isValueFromDb = true;
      } else {
        isValueFromDb = false;
      }
      log("Is value present in the db: ${isValueFromDb} and existinG DECISION IS $existingDecision");
      return existingDecision;
    } else {
      return null;
    }
  }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<void> _updateImageAudio() async {
    setState(() {
      inputAudioPlayerModel = null;
      recordingAudioPlayerModel = null;
      inputImagePath = null;
      inputAudioPath = null;
      inputRecordingPath = null;
      isAudioPromptInputPresent = false;
      isRecordingOutputPresent = false;
    });
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          isImageInputPresent =
              inputJson['files'] != null && inputJson['files']['image'] != null;
          isAudioPromptInputPresent = inputJson['files'] != null &&
              inputJson['files']['audio_prompt'] != null;
          isRecordingOutputPresent = inputJson['files'] != null &&
              inputJson['files']['recording'] != null;

          // recordingDuration = inputJson['data']['duration'];
          recordingDuration =
              (inputJson['data']['duration'] as num?)?.toDouble();
          inputImageFilename = inputJson['files']['image'];
          inputAudioFilename = inputJson['files']['audio_prompt'];
          inputRecordingFilename = inputJson['files']['recording'];
        });

        List<MicroTaskAssignmentRecord> relevantAssignments = widget
            .microtaskAssignments
            .where((assignment) =>
                assignment.microtaskId == widget.microtasks[microNum].id)
            .toList();
        setState(() {
          assignmentId = relevantAssignments[0].id;
        });

        String? currentDecision = await getDecisionInDb();

        Map<String, String>? inputPaths = await saveAssignmentFilesCheckExists(
            widget.microtasks[microNum].id, assignmentId!,
            imageFilename: inputImageFilename,
            audioFilename: inputAudioFilename,
            recordingFilename: inputRecordingFilename);
        if (inputPaths == null ||
            widget.microtasks[microNum].inputFileId == null) {
          setState(() {
            inputPresent = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "One or more required input files are missing. Please report this assignmentID to admin")),
          );

          return;
        } else {
          setState(() {
            inputPresent = true;
          });
        }
        setState(() {
          evaluationMap['decision'] = currentDecision;
          inputImagePath = inputPaths['image_path'];
          inputAudioPath = inputPaths['audio_prompt_path'];
          inputRecordingPath = inputPaths['recording_path'];
          log("paths: $inputImagePath , $inputAudioPath, $inputRecordingPath");
          if (isAudioPromptInputPresent && inputAudioPath != null) {
            inputAudioPlayerModel = AudioPlayerModel(inputAudioPath!);
          }
          if (isRecordingOutputPresent && inputRecordingPath != null) {
            recordingAudioPlayerModel = AudioPlayerModel(inputRecordingPath!);
          }
        });
      } catch (e) {
        log('Error decoding Json: $e');
        setState(() {
          inputImagePath = null;
          inputAudioPath = null;
          inputRecordingPath = null;
          log("paths: $inputImagePath , $inputAudioPath, $inputRecordingPath");
        });
      }
    }
  }

  Future<void> _updateSentence() async {
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          isSentenceInputPresent = inputJson['data'] != null &&
              inputJson['data']['sentence'] != null;
          _sentence = inputJson['data']['sentence'];
        });
        // List<MicroTaskAssignmentRecord> relevantAssignments =
        //     await _microTaskAssignmentDao.getMicroTaskAssignmentByMicrotaskId(
        //         widget.microtasks[microNum].id);
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

  Future<void> _updateCheckboxValues() async {
    setState(() {
      displayOptions = displayOptions = List.from(checkboxCommonOptions);
      if (widget.taskName.toLowerCase().contains('extempore')) {
        displayOptions.addAll(extemporeOptions);
        log("Disaply Options: $displayOptions");
      } else if (widget.taskName.toLowerCase().contains('[conversation')) {
        displayOptions.addAll(conversationsOptions);
      }
    });
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
                    _updateSentence();
                    _updateImageAudio();
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

  Future<bool?> showOverwriteWarning() {
    return (showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Overwrite Decision'),
          content: const Text(
              'You have already made a decision. Do you want to overwrite it?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User declines
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User consents
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    )); // Return false if the dialog is dismissed without a response
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckboxProvider>(
        create: (context) => CheckboxProvider(displayOptions),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Speech Verification Microtask"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const InstructionWidget(sentence: "Verify the task below"),
                  const SizedBox(height: 8.0),
                  Text(
                    "Task ID: $assignmentId", // Replace with your actual assignment ID variable
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  //Sentence Input
                  isSentenceInputPresent
                      ? (() {
                          // print("Rendering sentence: $_sentence");
                          return SentenceDisplayWOExpandedWidget(
                              sentence: _sentence!);
                        })()
                      : const SizedBox.shrink(),

                  //Image Input
                  isImageInputPresent
                      ? (inputImagePath == null
                          ? const CircularProgressIndicator()
                          : ImageDisplayWidget(
                              imagePath: inputImagePath!,
                            ))
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8.0),

                  // Audio Prompt Input
                  isAudioPromptInputPresent
                      ? (inputAudioPath == null
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Instruction audio: ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: PlayerWidget(
                                    key: ValueKey(inputAudioPath),
                                    filePath: inputAudioPath!,
                                    duration: 4,
                                    playerModel: inputAudioPlayerModel!,
                                  ),
                                ),
                              ],
                            ))
                      : const SizedBox.shrink(),

                  // Recording Output
                  isRecordingOutputPresent
                      ? (recordingAudioPlayerModel == null
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Test Audio: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex:
                                      5, // Use a ratio for how much space this should take
                                  child: PlayerWidget(
                                    key: ValueKey(inputRecordingPath),
                                    filePath: inputRecordingPath!,
                                    duration: recordingDuration,
                                    playerModel: recordingAudioPlayerModel!,
                                  ),
                                ),
                              ],
                            ))
                      : const SizedBox.shrink(),

                  // Sentence Output
                  isSentenceOutputPresent
                      ? const Text(
                          'This is the output sentence.',
                          style: TextStyle(fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                  Visibility(
                      visible: inputPresent,
                      child: Builder(builder: (context) {
                        // print(
                        //     "inputPresent in build: $inputPresent");
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (evaluationMap['decision'] != null) {
                                    bool? shouldProceed =
                                        await showOverwriteWarning();
                                    if (!shouldProceed!) return;
                                  }
                                  setState(() {
                                    isValueFromDb = false;
                                    isDecisionMade = true;
                                    evaluationMap['decision'] = 'reject';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      evaluationMap['decision'] == 'reject'
                                          ? Colors.green
                                          : Colors.deepOrangeAccent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0),
                                    ),
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  elevation: 6.0,
                                ),
                                child: const Text(
                                  'REJECT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (evaluationMap['decision'] != null) {
                                    bool? shouldProceed =
                                        await showOverwriteWarning();
                                    if (!shouldProceed!) return;
                                  }
                                  setState(() {
                                    isValueFromDb = false;
                                    isDecisionMade = true;
                                    evaluationMap['decision'] = 'accept';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      evaluationMap['decision'] == 'accept'
                                          ? Colors.green
                                          : Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  elevation: 6.0,
                                ),
                                child: const Text(
                                  'ACCEPT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (evaluationMap['decision'] != null) {
                                    bool? shouldProceed =
                                        await showOverwriteWarning();
                                    if (!shouldProceed!) return;
                                  }
                                  setState(() {
                                    isValueFromDb = false;
                                    isDecisionMade = false;
                                    evaluationMap['decision'] = 'excellent';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      evaluationMap['decision'] == 'excellent'
                                          ? Colors.green
                                          : Colors.orangeAccent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                    ),
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  elevation: 6.0,
                                ),
                                child: const Text(
                                  'EXCELLENT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })),
                  if (isDecisionMade)
                    Column(
                      children: [
                        const SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const SizedBox(
                            height: 200.0,
                            child: CheckboxListWidget(),
                          ),
                        ),
                      ],
                    ),
                  TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Comments',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                  ),

                  NextBackWidget(onBackPressed: () {
                    inputAudioPlayerModel?.stop();
                    recordingAudioPlayerModel?.stop();
                    _commentController.clear();
                    final checkboxProvider =
                        Provider.of<CheckboxProvider>(context, listen: false);
                    if (microNum > 0) {
                      setState(() {
                        isDecisionMade = false;
                        microNum--;
                        _updateSentence();
                        _updateImageAudio();
                        checkboxProvider.resetAll();
                        evaluationMap['decision'] = null;
                      });
                    } else {
                      callToast('No previous task');
                    }
                  }, onNextPressed: () async {
                    inputAudioPlayerModel?.stop();
                    recordingAudioPlayerModel?.stop();
                    bool recordDone;
                    final checkboxProvider =
                        Provider.of<CheckboxProvider>(context, listen: false);
                    if (!isValueFromDb) {
                      evaluationMap["comments"] =
                          (_commentController.text == "")
                              ? "false"
                              : _commentController.text;
                      _commentController.clear();
                      final checkedItemsMap =
                          checkboxProvider.items.asMap().map((index, item) {
                        final modifiedItemName =
                            item.itemName.replaceAll(' ', '_');
                        return MapEntry(modifiedItemName, item.isChecked);
                      });
                      evaluationMap.addAll(checkedItemsMap);
                      if (widget.taskName.toLowerCase().contains('extempore')) {
                        evaluationMap.addAll({
                          for (var item in conversationsOptions) item: false
                        });
                      } else if (widget.taskName
                          .toLowerCase()
                          .contains('[convesation')) {
                        evaluationMap.addAll(
                            {for (var item in extemporeOptions) item: false});
                      } else {
                        evaluationMap.addAll({
                          for (var item in [
                            ...conversationsOptions,
                            ...extemporeOptions
                          ])
                            item: false
                        });
                      }
                      log("Evaluation map values : $evaluationMap");

                      recordDone = await updateDbIfCompleted();
                    } else {
                      recordDone = true;
                    }
                    if (microNum < widget.microtasks.length - 1) {
                      if (recordDone) {
                        setState(() {
                          ++microNum;
                          _updateSentence();
                          _updateImageAudio();
                          if (isAudioPromptInputPresent) {
                            inputAudioPlayerModel =
                                AudioPlayerModel(inputAudioPath!);
                          }
                          if (isRecordingOutputPresent) {
                            recordingAudioPlayerModel =
                                AudioPlayerModel(inputRecordingPath!);
                          }
                          checkboxProvider.resetAll();
                          evaluationMap['decision'] = null;
                          isDecisionMade = false;
                        });
                      } else {
                        showSkipDialog(true);
                      }
                    } else {
                      if (!recordDone) {
                        showSkipDialog(false);
                      } else {
                        callToast('No more tasks here');
                        setState(() {
                          ++microNum;
                        });
                        Navigator.pop(context);
                      }
                    }
                  }),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    inputAudioPlayerModel?.stop();
    recordingAudioPlayerModel?.stop();
    super.dispose();
  }
}
