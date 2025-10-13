import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/dao/microtask_dao.dart';
import 'package:kathbath_lite/data/database/dao/task_dao.dart';
import 'package:kathbath_lite/data/database/repo/assignment_repo.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/models/assignment_status_enum.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/task_api.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:kathbath_lite/utils/send_output.dart';
import 'package:kathbath_lite/widgets/editbox_widget.dart';
import 'package:kathbath_lite/widgets/task_card_widget.dart';
import 'package:kathbath_lite/widgets/task_submit_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  int submittedCount = 0;
  int uploadedCount = 0;
  int onPhoneCount = 0;
  int total_available = 0;
  bool loggedOut = false;
  bool loadingDone = false;

  final ValueNotifier<bool> _isSubmitting = ValueNotifier(false);

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    submittedCount = prefs.getInt('submittedCount') ?? 0;
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
    if (mounted) {
      setState(() {
        _tasks = tasks;
        if (total_available == 0 && !loggedOut) {
          showShareDialog(context);
        }
      });
    }
  }

  Future<void> showProgressDialog(
      BuildContext context, ValueNotifier<String> messageNotifier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submitting Tasks'),
          content: ValueListenableBuilder<String>(
            valueListenable: messageNotifier,
            builder: (context, message, _) {
              return Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Expanded(child: Text(message)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> handleSubmitTasks() async {
    final ValueNotifier<String> progressMessage = ValueNotifier('Starting...');
    showProgressDialog(context, progressMessage);
    try {
      progressMessage.value = '1/4 Loading completed tasks...';
      Future.delayed(const Duration(seconds: 3), () {
        if (progressMessage.value.contains('Skipping assignment')) {
          progressMessage.value = 'Continuing upload...';
        }
      });
      List<MicroTaskAssignmentRecord> completedAssignments =
          await _microTaskAssignmentDao.getMicrotaskAssignmentByStatus(
              MicrotaskAssignmentStatus.COMPLETED);
      //Filtering out the unsubmitted assignments based on output_file_id null or size>0 , same as the logic defined in the old app
      progressMessage.value = '2/4 Getting unsubmitted tasks...';
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nothing to submit'),
            duration: Duration(seconds: 2),
          ),
        );
        return true;
      } else {
        //sending the output file and updating the value in the local client db
        progressMessage.value = '3/4 Uploading audio files...';
        List<MicroTaskAssignmentRecord> fileNotFoundAssignments = [];
        for (var assignment in unsubmittedAssignments) {
          final outFileResult =
              await sendOutputFileWithInput(assignment.id, assignment);
          // log("Output file id: $outputFileId");

          if (outFileResult.errorType != null) {
            if (outFileResult.errorType == "fileNotFound") {
              progressMessage.value = outFileResult.errorMsg!;
              // 'WAV file not found for assignment ${assignment.id}.Skipping assignment.';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(outFileResult.errorMsg!),
                  duration: const Duration(seconds: 3), // optional
                ),
              );

              fileNotFoundAssignments.add(assignment);

              continue; // Skip the error task and continue with the next
            }
            progressMessage.value =
                'Error uploading ${assignment.id}, ${outFileResult.errorMsg}';
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Failed to upload output file. Submission aborted.'),
              ),
            );
            return false;
          } else {
            String? outputFileId = outFileResult.fileId;
            if (outputFileId != null && outputFileId != "") {
              await _microTaskAssignmentDao
                  .updateMicrotaskAssignmentOutputFileId(
                      assignment.id, outputFileId);
            }
          }
        }
        completedAssignments =
            await _microTaskAssignmentDao.getMicrotaskAssignmentByStatus(
                MicrotaskAssignmentStatus.COMPLETED);
        final fileNotFoundIds =
            fileNotFoundAssignments.map((a) => a.id).toSet();
        completedAssignments.removeWhere(
          (assignment) => fileNotFoundIds.contains(assignment.id),
        );
        progressMessage.value = '4/4 Submitting metadata to server...';

        //api to update the server db
        final MicroTaskAssignmentService microApiService =
            MicroTaskAssignmentService(apiService);
        Response submitResponse = await microApiService
            .submitCompletedAssignments(completedAssignments);
        if (submitResponse.statusCode == 200 &&
            completedAssignments.isNotEmpty) {
          List<dynamic> submittedIds = submitResponse.data;
          for (var assignment in completedAssignments) {
            if (submittedIds.contains(assignment.id)) {
              // print("assignmentid: ${assignment.id}");
              await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
                assignment.id,
                MicrotaskAssignmentStatus.SUBMITTED,
              );
            }
          }
          for (var assignment in fileNotFoundAssignments) {
            if (submittedIds.contains(assignment.id)) {
              await _microTaskAssignmentDao.updateMicrotaskAssignmentStatus(
                assignment.id,
                MicrotaskAssignmentStatus.ASSIGNED,
              );
            }
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data Submitted successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          await _populateDb();
          await _loadTasks();
          if (fileNotFoundIds.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Some audio files where corrupted. Please redo those and submit'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return true;
        } else if (submitResponse.statusCode == 401) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Token expired. Please login again.')),
          );
          return false;
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Some of the data Submission failed. Please try again'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      }
    } catch (e) {
      Navigator.pop(context); // close dialog on error
      if (e is DioException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please check your network')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      return false;
    }
  }

  Future<void> _handleTaskCardTap(BuildContext context, TaskRecord task) async {
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

        case 'SPEECH_DV_MULTI' || 'SPEECH_VERIFICATION':
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
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with animation
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Share App',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Share our app with your friends! Help us create AI tools that can converse in Indian languages.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0), // Slide + fade-in animation

                  const SizedBox(height: 32),

                  // App icon with animation
                  Image.asset(
                    'assets/icons/whatsappicon.png',
                    width: 50,
                    height: 50,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16), // Space between logo and text

                  // Description text with animation
                  const Text(
                    'Whatsapp',
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 32),

                  // Action buttons with animation
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: goToWhatsap,
                      child: const Text('Share'),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  Center(
                    child: TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
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
          automaticallyImplyLeading: false,
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
              icon: const Icon(Icons.logout),
              onPressed: () async {
                loggedOut = true;
                // bool submitSuccess = await handleSubmitTasks();
                // if (submitSuccess) {
                  SharedPreferences? prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('otp_verified', false);
                  await prefs.setString('id_token', '');
                  await prefs.setString('loggedInNum', '');
                  await prefs.setString('submittedCount', '');
                  await prefs.setBool("referral_send", false);
                  await _taskDao.clearAllTasks();
                  await _microTaskDao.clearAllMicroTasks();
                  await _microTaskAssignmentDao.clearAllMicrotaskAssignments();

                  Navigator.pushReplacementNamed(context, '/');
                // }
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
              ValueListenableBuilder<bool>(
                valueListenable: _isSubmitting,
                builder: (context, isSubmitting, _) {
                  return TaskSubmitWidget(
                    // uploadedTasks: uploadedCount,
                    uploadedTasks: submittedCount + uploadedCount,
                    onPhoneTasks: onPhoneCount,
                    handleSubmitTasks: () async {
                      await handleSubmitTasks();
                    },
                  );
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
