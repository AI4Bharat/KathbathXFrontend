import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/worker_api.dart';
import 'package:karya_flutter/widgets/video_player_widget.dart';
import 'package:karya_flutter/widgets/video_recorder_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoCollectionScreen extends StatefulWidget {
  final KaryaDatabase db;
  final List<MicroTaskRecord> microtasks;
  final List<MicroTaskAssignmentRecord> microtaskAssignments;

  const VideoCollectionScreen(
      {super.key,
      required this.db,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<VideoCollectionScreen> createState() => _VideoCollectionScreenState();
}

class _VideoCollectionScreenState extends State<VideoCollectionScreen> {
  String? _sentence;
  String? assignmentId;
  String? filePath;
  late Dio dio;
  late ApiService apiService;
  String? ageGroup;
  String? gender;
  bool recordingProcess = true;

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
    await _getDisplayValues();
  }

  Future<void> _getDisplayValues() async {
    dio = Dio();
    apiService = ApiService(dio);
    final WorkerApiService microApiService = WorkerApiService(apiService);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessCode = prefs.getString('accessCode');
    Response<dynamic> response =
        await microApiService.getWorkerDetails(accessCode!);
    var jsonData = response.data as Map<String, dynamic>;
    var profile = jsonData['profile'];
    setState(() {
      ageGroup = profile['age'];
      gender = profile['gender'];
    });
  }

  Future<bool> updateSkippedAssignment() async {
    int skipUpdate =
        await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
            assignmentId!, MicrotaskAssignmentStatus.SKIPPED);
    return (skipUpdate == 1);
  }

  Future<bool> updateDbIfCompleted() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$assignmentId.mp4';
    File file = File(filePath);
    bool fileExists = await file.exists();
    if (fileExists) {
      _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
          assignmentId!, MicrotaskAssignmentStatus.COMPLETED);
      String fileJson = '{"data":{},"files":{"recording":"$assignmentId.mp4"}}';
      _microTaskAssignmentDao.updateMicrotaskAssignmentOutputFile(
          assignmentId!, fileJson);
    } else {
      log('File does not exist at $filePath');
    }
    return fileExists;
  }

  Future<void> _updateSentence() async {
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

  void _updateRecordingStatus(bool recordingOn) {
    setState(() {
      recordingProcess = recordingOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Video Collection Task'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: recordingProcess
              ? VideoRecorderWidget(
                  textToRead: _sentence ?? '',
                  age: ageGroup ?? "0",
                  gender: gender ?? "",
                  assignmentId: assignmentId!,
                  recordingOn: _updateRecordingStatus)
              : VideoPlayerWidget(
                  assignmentId: assignmentId!,
                  submitAction: () async {
                    bool update = await updateDbIfCompleted();
                    if (update) {
                      callToast("Video updated");
                      Navigator.pop(context);
                    } else {
                      callToast("Video update failed. Please try again");
                    }
                  },
                  recordingOn: _updateRecordingStatus),
        ));
  }
}
