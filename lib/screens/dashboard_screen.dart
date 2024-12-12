import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/database/dao/microtask_dao.dart';
import 'package:karya_flutter/data/database/dao/task_dao.dart';
import 'package:karya_flutter/data/database/repo/assignment_repo.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/task_api.dart';
import 'package:karya_flutter/utils/colors.dart';
import 'package:karya_flutter/utils/send_output.dart';
import 'package:karya_flutter/widgets/editbox_widget.dart';
import 'package:karya_flutter/widgets/task_card_widget.dart';
import 'package:karya_flutter/widgets/task_submit_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final KaryaDatabase db;

  const DashboardScreen({super.key, required this.title, required this.db});

  final String title;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TaskDao _taskDao;
  late MicroTaskDao _microTaskDao;
  late MicroTaskAssignmentDao _microTaskAssignmentDao;
  late AssignmentRepository _assignmentRepository;
  late List<TaskRecord> _tasks = [];
  final Map<String, Map<String, int>> _taskStatusCounts = {};
  int uploadedCount = 0;
  int onPhoneCount = 0;
  int total_available = 0;
  bool loggedOut = false;
  bool loadingDone = false;

  String filterLines = "";

  late Dio dio;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);

    _taskDao = widget.db.taskDao;
    _microTaskDao = widget.db.microTaskDao;
    _microTaskAssignmentDao = widget.db.microTaskAssignmentDao;
    _assignmentRepository =
        AssignmentRepository(_taskDao, _microTaskDao, _microTaskAssignmentDao);
    _initialize();
  }

  Future<void> _initialize() async {
    await _populateDb();
    await _loadTasks();
  }

  Future<void> _populateDb() async {
    loadingDone = await _assignmentRepository.loadAndSaveAssignments();
  }

  Future<void> _loadTasks() async {
    log("Loading............................");
    var tasks = await _taskDao.getAllTasks();

    if (filterLines != "") {
      tasks = tasks
          .where((tk) =>
              tk.name!.toLowerCase().contains(filterLines.toLowerCase()))
          .toList();
    }

    _taskStatusCounts.clear();
    uploadedCount = 0;
    onPhoneCount = 0;
    total_available = 0;
    for (var task in tasks) {
      final microtaskAssignments =
          await _microTaskAssignmentDao.getMicroTaskAssignmentByTaskId(task.id);
      final statusCounts = {
        'available': 0,
        'completed': 0,
        'submitted': 0,
        'skipped': 0,
        'verified': 0,
        'expired': 0,
        'totalDuration': -1 //-1 incase its not a recording task
      };

      double totalDuration = 0;
      for (var microtaskAssign in microtaskAssignments) {
        switch (microtaskAssign.status) {
          case 'ASSIGNED':
            statusCounts['available'] = statusCounts['available']! + 1;
          case 'COMPLETED':
            statusCounts['completed'] = statusCounts['completed']! + 1;
            break;
          case 'SUBMITTED':
            statusCounts['submitted'] = statusCounts['submitted']! + 1;
            break;
          case 'SKIPPED':
            statusCounts['skipped'] = statusCounts['skipped']! + 1;
            break;
          case 'VERIFIED':
            statusCounts['verified'] = statusCounts['verified']! + 1;
            break;
          case 'EXPIRED':
            statusCounts['expired'] = statusCounts['expired']! + 1;
            break;
        }

        // log("counts : $uploadedCount, $onPhoneCount");
        if (microtaskAssign.output != null &&
            microtaskAssign.output!.isNotEmpty) {
          try {
            final outputJson = json.decode(microtaskAssign.output!);
            if (outputJson['data'] != null &&
                outputJson['data']['duration'] != null) {
              totalDuration += (outputJson['data']['duration'] ?? 0).toDouble();
            }
          } catch (e) {
            log('Error parsing output for assignment ID ${microtaskAssign.id}: $e');
          }
        }
      }
      uploadedCount += statusCounts['submitted']!;
      onPhoneCount += statusCounts['completed']!;
      total_available += statusCounts['available']! +
          statusCounts['submitted']! +
          statusCounts['skipped']!;
      if (task.name!.toLowerCase().contains("extempore") ||
          task.name!.toLowerCase().contains("read")) {
        statusCounts['totalDuration'] = totalDuration.toInt();
      }
      _taskStatusCounts[task.id] = statusCounts;
    }
    setState(() {
      _tasks = tasks;
      if (total_available == 0 && !loggedOut) {
        showShareDialog(context);
      }
    });
  }

  Future<void> handleSubmitTasks() async {
    List<MicroTaskAssignmentRecord> completedAssignments =
        await _microTaskAssignmentDao.getMicrotaskAssignmentByStatus(
            MicrotaskAssignmentStatus.COMPLETED);
    //Filtering out the unsubmitted assignments based on output_file_id null or size>0 , same as the logic defined in the old app
    List<MicroTaskAssignmentRecord> unsubmittedAssignments =
        completedAssignments.where((assignment) {
      bool isOutputFileIdNull = assignment.outputFileId == null;
      bool hasValidOutputFiles = false;
      if (assignment.output != null) {
        var outputJson = jsonDecode(assignment.output!);
        if (outputJson is Map<String, dynamic> &&
            outputJson.containsKey('files')) {
          hasValidOutputFiles = (outputJson['files']).isNotEmpty;
        }
      }
      return isOutputFileIdNull && hasValidOutputFiles;
    }).toList();
    if (completedAssignments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to submit'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      //sending the output file and updating the value in the local client db
      for (var assignment in unsubmittedAssignments) {
        String? outputFileId = await sendOutputFile(assignment.id, assignment);
        // log("Output file id: $outputFileId");
        await _microTaskAssignmentDao.updateMicrotaskAssignmentOutputFileId(
            assignment.id, outputFileId);
      }
      completedAssignments = await _microTaskAssignmentDao
          .getMicrotaskAssignmentByStatus(MicrotaskAssignmentStatus.COMPLETED);

      //api to update the server db
      final MicroTaskAssignmentService microApiService =
          MicroTaskAssignmentService(apiService);
      Response submitResponse = await microApiService
          .submitCompletedAssignments(completedAssignments);
      if (submitResponse.statusCode == 200 && completedAssignments.isNotEmpty) {
        for (var assignment in completedAssignments) {
          await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
              assignment.id, MicrotaskAssignmentStatus.SUBMITTED);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Submitted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Submission failed. Please try again'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
    await _populateDb();
    await _loadTasks();
  }

  Future<void> _handleTaskCardTap(BuildContext context, TaskRecord task) async {
    // throw Exception("Test Crash by Gree buhahaha 1");
    final taskName = task.name;
    final microtasks =
        await _microTaskDao.getMicroTasksWithPendingAssignments(task.id);
    final toBeDoneAssignments =
        await _microTaskAssignmentDao.getToBeDoneMicrotaskAssignments(task.id);
    if (toBeDoneAssignments.isNotEmpty) {
      switch (task.scenarioName) {
        case 'SPEECH_DATA':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/sd_microtask',
            arguments: {
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          ;
          break;

        case 'IMAGE_DC_TEXT':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/image_transcription_microtask',
            arguments: {
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          break;

        case 'SPEECH_DC_IMGAUD':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/image_audio_microtask',
            arguments: {
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          break;

        case 'SPEECH_DV_MULTI':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/speech_verification_microtask',
            arguments: {
              'taskName': taskName,
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          break;

        case 'SPEECH_DC_AUDREF':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/speech_audio_refinement',
            arguments: {
              'taskName': taskName,
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          break;

        case 'SIGN_LANGUAGE_VIDEO':
          Navigator.pushNamed(
            // ignore: use_build_context_synchronously
            context,
            '/video_collection_task',
            arguments: {
              'microtasks': microtasks,
              'microtaskAssignments': toBeDoneAssignments,
            },
          ).then((_) {
            setState(() {
              _loadTasks();
            });
          });
          break;

        default:
          break;
      }
    }
  }

  List<Widget> _buildTaskCards(BuildContext context) {
    return _tasks.map((task) {
      final counts = _taskStatusCounts[task.id] ??
          {
            'available': 0,
            'completed': 0,
            'submitted': 0,
            'skipped': 0,
            'verified': 0,
            'expired': 0,
            'totalDuration': -1
          };

      return TaskCard(
        taskName: task.name ?? 'No name',
        available: counts['available']!,
        completed: counts['completed']!,
        verified: counts['verified']!,
        skipped: counts['skipped']!,
        submitted: counts['submitted']!,
        expired: counts['expired']!,
        totalDuration: counts['totalDuration']!,
        onTap: () => _handleTaskCardTap(context, task),
      );
    }).toList();
  }

  Future<bool> _onBackPressed() async {
    bool shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Exit'),
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop(); // Close the app on Android
                    } else if (Platform.isIOS) {
                      Navigator.of(context)
                          .pop(true); // Minimize the app on iOS
                    }
                  },
                ),
              ],
            );
          },
        ) ??
        false;
    return shouldExit;
  }

  Future<String?> getAccessCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        'accessCode'); // Fetch the access code stored with the key 'accessCode'
  }

  Future<void> goToWhatsap() async {
    final phoneNumber = dotenv.env['PHONE_NUMBER'];
    const message =
        "Please click the send button on the right to begin the process of sharing the Kathbath Lite app with your friends. Instructions will follow.";

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUri = Uri.parse(
        "https://api.whatsapp.com/send/?phone=$phoneNumber&text=$encodedMessage");
    await launchUrl(whatsappUri);
  }

  void showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/whatsappicon.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 16), // Space between logo and text
              const Text(
                  'Share our app with your friends! Click the button below to help recruit more contributors. Help us create AI tools(like ChatGPT) that can converse in Indian languages'),
            ],
          ),
          actions: [
            Container(
              width: double.infinity, // Center-aligns within available space
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange, // Set white text color
                ),
                onPressed: goToWhatsap,
                child: const Text('Share'),
              ),
            ),
            Center(
              child: TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _onBackPressed();
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkerOrange,
          title: FutureBuilder<String?>(
            future: getAccessCode(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return Text(snapshot.data ?? 'No Access Code');
              } else {
                return const Text('No Access Code');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                showShareDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                loggedOut = true;
                await handleSubmitTasks();
                SharedPreferences? prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('otp_verified', false);
                await prefs.setString('id_token', '');
                await prefs.setString('loggedInNum', '');
                await _taskDao.clearAllTasks();
                await _microTaskDao.clearAllMicroTasks();
                await _microTaskAssignmentDao.clearAllMicrotaskAssignments();

                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            filterLines = "";
            await _loadTasks();
          },
          child: Column(
            children: [
              // --- Task Submit/Get Section ---
              TaskSubmitWidget(
                uploadedTasks: uploadedCount,
                onPhoneTasks: onPhoneCount,
                handleSubmitTasks: () async {
                  await handleSubmitTasks();
                },
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: EditBoxWidget(
                      onTextSubmitted: (text) async {
                        setState(() {
                          filterLines = text;
                          _loadTasks();
                        });
                      },
                      buttonType: 'search')),
              // --- Tasks Recycler View ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: !loadingDone
                      ? const Center(
                          child:
                              CircularProgressIndicator(), // Show a loading indicator
                        )
                      : _tasks.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Thank you!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text(
                                    'You are done with your tasks! :)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Center-align the text
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap:
                                  true, // Important to prevent scrolling issues
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                return _buildTaskCards(context)[index];
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
