import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/models/assignment_status_enum.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/utils/save_input.dart';
import 'package:kathbath_lite/widgets/editbox_widget.dart';
import 'package:kathbath_lite/widgets/image_display_widget.dart';
import 'package:kathbath_lite/widgets/instruction_widget.dart';
import 'package:path_provider/path_provider.dart';

class ImageTranscriptionScreen extends StatefulWidget {
  final KaryaDatabase db;
  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  const ImageTranscriptionScreen(
      {super.key,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<ImageTranscriptionScreen> createState() =>
      _ImageTranscriptionScreenState();
}

class _ImageTranscriptionScreenState extends State<ImageTranscriptionScreen> {
  String? imagePath;
  String? _fileName;
  String? assignmentId;
  var microNum = 0;
  late final MicroTaskAssignmentDao _microTaskAssignmentDao;

  late Dio dio;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    _microTaskAssignmentDao = widget.db.microTaskAssignmentDao;
    _initializeImage();
  }

  void _initializeImage() async {
    await _updateImage();
  }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<void> _updateImage() async {
    if (widget.microtasks.isNotEmpty && microNum < widget.microtasks.length) {
      String input = widget.microtasks[microNum].input ?? '{}';
      try {
        Map<String, dynamic> inputJson = jsonDecode(input);
        setState(() {
          _fileName = inputJson['files']['image'] ?? 'No file found';
        });

        List<MicroTaskAssignmentRecord> relevantAssignments = widget
            .microtaskAssignments
            .where((assignment) =>
                assignment.microtaskId == widget.microtasks[microNum].id)
            .toList();

        setState(() {
          assignmentId = relevantAssignments[0].id;
        });

        Map<String, String>? inputPaths = await saveAssignmentFilesCheckExists(
            widget.microtasks[microNum].id, assignmentId!,
            imageFilename: _fileName!);
        if (inputPaths == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "One or more required input files are missing. Please report this assignmentID to admin")),
          );
          return;
        }
        final directory = await getApplicationDocumentsDirectory();
        imagePath = '${directory.path}${inputPaths['image_path']}';
        setState(() {});
      } catch (e) {
        log('Error decoding JSON: $e');
      }
    }
  }

//The below code is replaced by a single code common to all assignment types in save_input
  // Future<String> saveAssignmentImages(
  //     String microtaskId, String assignmentId, String fileName) async {
  //   dio = Dio();
  //   apiService = ApiService(dio);
  //   final MicroTaskAssignmentService microApiService =
  //       MicroTaskAssignmentService(apiService);
  //   var imageData = await microApiService.getInputFile(assignmentId);
  //   //Unzipping
  //   final GZipDecoder gzipDecoder = GZipDecoder();
  //   final tarBytes = gzipDecoder.decodeBytes(imageData);
  //   Uint8List? imageBytes;
  //   final TarDecoder tarDecoder = TarDecoder();
  //   tarDecoder.decodeBytes(tarBytes);
  //   for (final file in tarDecoder.files) {
  //     if (file.filename == fileName) {
  //       imageBytes = file.content as Uint8List;
  //       break;
  //     }
  //   }

  //   if (imageBytes == null) {
  //     throw Exception('File with name $fileName not found in the archive.');
  //   }
  //   final directory = await getApplicationDocumentsDirectory();
  //   final folderPath = Directory('${directory.path}/$microtaskId');
  //   if (!(await folderPath.exists())) {
  //     await folderPath.create(recursive: true);
  //   }
  //   final filePath = '${directory.path}/$microtaskId/$fileName';
  //   final file = File(filePath);
  //   await file.writeAsBytes(imageBytes);
  //   //log("file saved at filepath: $filePath");
  //   return filePath;
  // }

  Future<bool> updateDbIfCompleted(String text) async {
    if (text != '') {
      _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
          assignmentId!, MicrotaskAssignmentStatus.COMPLETED);
      String fileJson = '{"data":{"transcription":"$text"},"files":{}}';
      _microTaskAssignmentDao.updateMicrotaskAssignmentOutputFile(
          assignmentId!, fileJson);
      return true;
    }
    return false;
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
                    _updateImage();
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
          title: const Text("Image Transcription Microtask"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const InstructionWidget(
                  sentence: "Type what you see in the image below"),
              const SizedBox(height: 16.0),
              imagePath == null
                  ? const CircularProgressIndicator()
                  : ImageDisplayWidget(imagePath: imagePath!, isAbsolute: true),
              const SizedBox(height: 16.0),
              EditBoxWidget(
                  onTextSubmitted: (text) async {
                    bool updateDone = await updateDbIfCompleted(text);
                    if (microNum < widget.microtasks.length - 1) {
                      if (updateDone) {
                        setState(() {
                          microNum++;
                          _updateImage();
                        });
                      } else {
                        showSkipDialog(true);
                      }
                    } else {
                      if (!updateDone) {
                        showSkipDialog(false);
                      } else {
                        callToast('No more tasks');
                        setState(() {
                          ++microNum;
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  buttonType: 'next')
            ],
          ),
        ));
  }
}
