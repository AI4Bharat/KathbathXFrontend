import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/firebase_options.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/screens/dashboard_screen.dart';
import 'package:kathbath_lite/screens/login_screen.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_audio_refinement.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_image_audio.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_image_transcription.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_speech_data.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_speech_verification.dart';
import 'package:kathbath_lite/screens/microtasks/microtask_video_collection.dart';
import 'package:kathbath_lite/screens/register_screen.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:kathbath_lite/utils/app_scafold.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize firebase crashlytics
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      print("The error is $error");
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
  }
  // Initialize the database
  final db = await _openDatabase();
  await dotenv.load(fileName: ".env");

  // Check for in App update
  if (Platform.isAndroid) {
    await checkForAndroidUpdate();
  } else if (Platform.isIOS) {
    await checkForIOSUpdate();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => RecorderPlayerProvider(),
        child: KaryaApp(db),
      ),
    );
  });
}

Future<void> checkForAndroidUpdate() async {
  try {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      log("Update available: ${updateInfo.availableVersionCode}");
      if (updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
        log("Immediate update started");
      } else if (updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        log("Flexible update started");
        await InAppUpdate.completeFlexibleUpdate();
        log("Flexible update completed");
      } else {
        log("No update type allowed (immediate or flexible)");
      }
    } else {
      log("No update available");
    }
  } catch (e) {
    log("Error during in-app update: $e");
  }
}

Future<void> checkForIOSUpdate() async {
  return;
}

Future<KaryaDatabase> _openDatabase() async {
  return KaryaDatabase();
}

class KaryaApp extends StatefulWidget {
  final KaryaDatabase db;

  const KaryaApp(this.db, {super.key});

  @override
  _KaryaAppState createState() => _KaryaAppState();
}

class _KaryaAppState extends State<KaryaApp> {
  String? initialRoute;
  String _referrerDetails = '';
  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;

  @override
  void initState() {
    super.initState();
    _getInitialRoute();
    // initReferrerDetails();
  }

  Future<void> initReferrerDetails() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    bool referralSend = prefs.getBool("referral_send") ?? false;

    log("Referral send status is $referralSend");
    if (referralSend) {
      return;
    }

    dio = Dio();
    apiService = ApiService(dio);
    workerApiService = WorkerApiService(apiService);
    String referrerDetailsString;
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.toString();
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }
    if (!mounted) return;

    setState(() {
      _referrerDetails = referrerDetailsString;
    });
    Response response =
        await workerApiService.sendReferrerLink(_referrerDetails);
    if (response.statusCode == 200) {
      log("Ref code send successfully");
      prefs.setBool("referral_send", true);
    } else {
      log("Ref code send failed");
      prefs.setBool("referral_send", false);
    }
  }

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? idToken = prefs.getString('id_token');
    if (idToken != null && idToken != "") {
      return '/dashboard';
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: MaterialApp(
                title: 'Karya App',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: darkerOrange,
                      primary: primaryOrange,
                      onPrimary: Colors.white,
                      secondary: secondaryOrange,
                    ),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: backgroundColor,
                    ),
                    scaffoldBackgroundColor: backgroundColor,
                    useMaterial3: true,
                    fontFamily: 'CustomFont'),
                initialRoute: snapshot.data,
                routes: {
                  '/': (context) =>
                      const Scaffold(body: SafeArea(child: LoginScreen())),
                  '/register': (context) => const AppScaffold(
                      body: Scaffold(body: SafeArea(child: RegisterScreen()))),
                  '/dashboard': (context) => AppScaffold(
                      body: DashboardScreen(
                          title: 'Dashboard Screen', db: widget.db)),
                  '/sd_microtask': (context) {
                    final args = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                    return AppScaffold(
                        body: SpeechRecordingScreen(
                      db: widget.db,
                      microtasks: args['microtasks'] as List<MicroTaskRecord>,
                      microtaskAssignments: args['microtaskAssignments']
                          as List<MicroTaskAssignmentRecord>,
                    ));
                  },
                  // '/image_transcription_microtask': (context) {
                  //   final args = ModalRoute.of(context)!.settings.arguments
                  //       as Map<String, dynamic>;
                  //   return AppScaffold(
                  //       body: ImageTranscriptionScreen(
                  //     db: widget.db,
                  //     microtasks: args['microtasks'] as List<MicroTaskRecord>,
                  //     microtaskAssignments: args['microtaskAssignments']
                  //         as List<MicroTaskAssignmentRecord>,
                  //   ));
                  // },
                  // '/image_audio_microtask': (context) {
                  //   final args = ModalRoute.of(context)!.settings.arguments
                  //       as Map<String, dynamic>;
                  //   return AppScaffold(
                  //       body: ImageAudioScreen(
                  //     db: widget.db,
                  //     microtasks: args['microtasks'] as List<MicroTaskRecord>,
                  //     microtaskAssignments: args['microtaskAssignments']
                  //         as List<MicroTaskAssignmentRecord>,
                  //   ));
                  // },
                  '/speech_verification_microtask': (context) {
                    final args = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                    return AppScaffold(
                        body: SpeechVerificationScreen(
                      db: widget.db,
                      microtasks: args['microtasks'] as List<MicroTaskRecord>,
                      microtaskAssignments: args['microtaskAssignments']
                          as List<MicroTaskAssignmentRecord>,
                      taskName: args['taskName'],
                    ));
                  },
                  // '/speech_audio_refinement': (context) {
                  //   final args = ModalRoute.of(context)!.settings.arguments
                  //       as Map<String, dynamic>;
                  //   return AppScaffold(
                  //       body: SpeechAudioScreen(
                  //     db: widget.db,
                  //     microtasks: args['microtasks'] as List<MicroTaskRecord>,
                  //     microtaskAssignments: args['microtaskAssignments']
                  //         as List<MicroTaskAssignmentRecord>,
                  //   ));
                  // },
                  '/video_collection_task': (context) {
                    final args = ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                    return AppScaffold(
                        body: VideoCollectionScreen(
                      db: widget.db,
                      microtasks: args['microtasks'] as List<MicroTaskRecord>,
                      microtaskAssignments: args['microtaskAssignments']
                          as List<MicroTaskAssignmentRecord>,
                    ));
                  }
                },
              ));
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
