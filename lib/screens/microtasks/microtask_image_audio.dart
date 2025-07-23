import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:karya_flutter/utils/save_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/providers/recorder_player_providers.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/utils/audio_player_model.dart';
import 'package:karya_flutter/widgets/audio_controls_widget.dart';
import 'package:karya_flutter/widgets/image_display_widget.dart';
import 'package:karya_flutter/widgets/instruction_widget.dart';
import 'package:karya_flutter/widgets/player_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ImageAudioScreen extends StatefulWidget {
  final KaryaDatabase db;
  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  const ImageAudioScreen(
      {super.key,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<ImageAudioScreen> createState() => _ImageAudioScreenState();
}

class _ImageAudioScreenState extends State<ImageAudioScreen> {
  String? inputImageFilename;
  String? inputAudioFilename;
  String? inputImagePath;
  String? inputAudioPath;
  String? outputAudioPath;
  String? assignmentId;
  var microNum = 0;
  late final MicroTaskAssignmentDao _microTaskAssignmentDao;

  late Dio dio;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    _microTaskAssignmentDao = widget.db.microTaskAssignmentDao;
    _initializeInputs();
  }

  void _initializeInputs() async {
    await _updateImageAudio();
  }

//The below code is replaced by a single code common to all assignment types in save_input
  // Future<List<String>> saveAssignmentFiles(String microtaskId,
  //     String assignmentId, String imageFilename, String audioFilename) async {
  //   dio = Dio();
  //   apiService = ApiService(dio);
  //   final MicroTaskAssignmentService microApiService =
  //       MicroTaskAssignmentService(apiService);
  //   var tgzFile = await microApiService.getInputFile((assignmentId));
  //   final GZipDecoder gzipDecoder = GZipDecoder();
  //   final tarBytes = gzipDecoder.decodeBytes(tgzFile);
  //   Uint8List? imageBytes;
  //   Uint8List? audioBytes;
  //   final TarDecoder tarDecoder = TarDecoder();
  //   tarDecoder.decodeBytes(tarBytes);
  //   for (final file in tarDecoder.files) {
  //     if (file.filename == imageFilename) {
  //       imageBytes = file.content as Uint8List;
  //     } else if (file.filename == audioFilename) {
  //       audioBytes = file.content as Uint8List;
  //     }
  //   }

  //   if (imageBytes == null) {
  //     throw Exception(
  //         'File with name $imageFilename not found in the archive.');
  //   } else if (audioBytes == null) {
  //     throw Exception(
  //         'File with name $audioFilename not found in the archive.');
  //   }
  //   final directory = await getApplicationDocumentsDirectory();
  //   final folderPath = Directory('${directory.path}/$microtaskId');
  //   if (!(await folderPath.exists())) {
  //     await folderPath.create(recursive: true);
  //   }
  //   final imageFilePath = '${directory.path}/$microtaskId/$imageFilename';
  //   final audioFilePath = '${directory.path}/$microtaskId/$audioFilename';
  //   final imageFile = File(imageFilePath);
  //   final audioFile = File(audioFilePath);
  //   await imageFile.writeAsBytes(imageBytes);
  //   await audioFile.writeAsBytes(audioBytes);
  //   // log(
  //   //     "image file saved at filepath: $imageFilePath and audio file saved in path : $audioFilePath");
  //   final List<String> filePaths = [imageFilePath, audioFilePath];
  //   return filePaths;
  // }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<void> _updateImageAudio() async {
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          inputImageFilename = inputJson['files']['image'] ?? 'No file found';
          inputAudioFilename =
              inputJson['files']['audio_prompt'] ?? 'No file found';
        });

        List<MicroTaskAssignmentRecord> relevantAssignments = widget
            .microtaskAssignments
            .where((assignment) =>
                assignment.microtaskId == widget.microtasks[microNum].id)
            .toList();
        setState(() {
          assignmentId = relevantAssignments[0].id;
          outputAudioPath = '/$assignmentId.wav';
        });

        // List<String> inputPaths = await saveAssignmentFiles(
        //     widget.microtasks[microNum].id,
        //     assignmentId!,
        //     inputImageFilename!,
        //     inputAudioFilename!);
        Map<String, String>? inputPaths = await saveAssignmentFilesCheckExists(
            widget.microtasks[microNum].id, assignmentId!,
            imageFilename: inputImageFilename,
            audioFilename: inputAudioFilename);
        if (inputPaths == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "One or more required input files are missing. Please report this assignmentID to admin")),
          );
          return;
        }
        final directory = await getApplicationDocumentsDirectory();
        setState(() {
          inputImagePath = inputPaths['image_path'];
          inputImagePath = '${directory.path}$inputImagePath';
          inputAudioPath = inputPaths['audio_prompt_path'];
        });
      } catch (e) {
        log('Error decoding Json: $e');
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Audio Microtask"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const InstructionWidget(
                  sentence: "Type what you see in the image below"),
              const SizedBox(height: 16.0),
              inputImagePath == null
                  ? const CircularProgressIndicator()
                  : ImageDisplayWidget(
                      imagePath: inputImagePath!, isAbsolute: true),
              const SizedBox(height: 5.0),
              inputAudioPath == null
                  ? const CircularProgressIndicator()
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Expanded(
                        flex:
                            1, // Use a ratio for how much space this should take
                        child: Text(
                          'Prompt: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: PlayerWidget(
                          key: ValueKey(inputAudioPath),
                          filePath: inputAudioPath!,
                          duration: 10,
                          playerModel: AudioPlayerModel(inputAudioPath!),
                        ),
                      )
                    ]),
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
                  filePath: outputAudioPath ?? '',
                  progress: 40.0,
                  onBackPressed: () {
                    if (microNum > 0) {
                      setState(() {
                        microNum--;
                        _updateImageAudio();
                      });
                    } else {
                      callToast('No previous task');
                    }
                  },
                  onNextPressed: () async {
                    bool recordDone = await updateDbIfCompleted();
                    // sendOutputFile(assignmentId!);
                    if (microNum < widget.microtasks.length - 1) {
                      if (recordDone) {
                        setState(() {
                          ++microNum;
                          _updateImageAudio();
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
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
