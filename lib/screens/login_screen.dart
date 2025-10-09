import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kathbath_lite/models/login_items.dart';
import 'package:kathbath_lite/models/registration_items.dart';
import 'package:kathbath_lite/screens/register_screen.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:kathbath_lite/utils/validator.dart';
import 'package:kathbath_lite/widgets/action_button.dart';
import 'package:kathbath_lite/widgets/form_dropdown_widget.dart';
import 'package:kathbath_lite/widgets/loading_dialog.dart';
import 'package:kathbath_lite/widgets/logo_widget.dart';
import 'package:kathbath_lite/widgets/otp_verification_dialog.dart';
import 'package:kathbath_lite/widgets/textfield_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  LoginItem loginItem = LoginItem();

  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;

  SharedPreferences? prefs;
  String? accessCode;
  String? loggedInNum;

  @override
  void initState() {
    super.initState();
    _initSharedPrefnAC();

    dio = Dio();
    apiService = ApiService(dio);
    workerApiService = WorkerApiService(apiService);
  }

  Future<bool> _generateOtp() async {
    RegistrationResponse response =
        await workerApiService.generateOTP(accessCode!, loginItem.phoneNumber!);

    if (response.responseCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      return false;
    }
  }

  // Future<bool> _verifyOtp(String otp) async {
  //   try {
  //     final response = await workerApiService.verifyOTP(accessCode!, otp);
  //     // print("verify otp response: $response");
  //     if (response.responseCode == 200) {
  //       final Map<String, dynamic> otpResponse = jsonDecode(response.data!);
  //       final String? idToken = otpResponse['id_token'];
  //       final int submittedCount = otpResponse['submitted_count'] ?? 0;
  //
  //       if (idToken != null) {
  //         await prefs?.setString('id_token', idToken);
  //         await prefs?.setString('loggedInNum', loginItem.phoneNumber!);
  //         await prefs?.setInt('submittedCount', submittedCount);
  //       } else {
  //         log('ID Token not found in the response.');
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log('Error generating OTP: $e');
  //     return false;
  //   }
  // }

  Future<void> _initSharedPrefnAC() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInNum = prefs?.getString('loggedInNum') ?? '0';
    });
  }

  Future<void> _checkOtpStatus() async {
    // if (loginItem.phoneNumber != loggedInNum) {
    //   await prefs?.setBool('otp_verified', false);
    // }
    // prefs = await SharedPreferences.getInstance();
    // bool? isVerified = prefs?.getBool('otp_verified');
    // if (!isVerified!) {
    // bool isOtpGenerated = await _generateOtp();
    // Navigator.of(context).pop();
    // if (isOtpGenerated) {
    // _showOtpNotVerifiedDialog();
    // _showOtpVerificationDialog();
    // } else {
    //   Navigator.pop(context);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //       content: Text(
    //           'Phone number is wrong or OTP generation failed. Kindly check your internet connection')),
    // );
    //   }
    // } else {
    //   Navigator.pushReplacementNamed(context, '/dashboard');
    // }
  }

  // Future<bool> _handleSubmit() async {
  //   final otp = otpController.text;
  //   if (otp.isNotEmpty) {
  //     bool otpStat = await _verifyOtp(otp);
  //     if (otpStat) {
  //       prefs = await SharedPreferences.getInstance();
  //       setState(() {
  //         prefs?.setBool('otp_verified', true);
  //       });
  //
  //       Navigator.of(context).pop();
  //       Navigator.pushReplacementNamed(context, '/dashboard');
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('OTP verified successfully'),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('OTP verification failed. Please try again')),
  //       );
  //     }
  //     return otpStat;
  //   } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('OTP can\'t be empty')),
      // );
  //     return false;
  //   }
  // }
  //
  // Future<void> _handleResend() async {
  //   try {
  //     final response =
  //         await workerApiService.resendOTP(accessCode!, loginItem.phoneNumber!);
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('OTP send again to the registered number')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('OTP resent failed. Please try again')),
  //       );
  //     }
  //   } catch (e) {
  //     log('Error generating OTP: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('OTP resent failed. Please try again')),
  //     );
  //   }
  // }

  void _showOtpVerificationDialog() {
    if (accessCode == null) {
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OtpVerificationDialog(
            workerApiService: workerApiService, accessCode: accessCode!);
      },
    );
  }

  void _submit() async {
    String? accessEncode = dotenv.env['ACCESS_ENCODE'];
    int? langValue = languageCode[loginItem.language];
    if (langValue == null) {
      return;
    }
    accessCode = '${loginItem.phoneNumber}$accessEncode$langValue';

    showLoadingDialog("We are generating your OTP...", context);

    final otpGenerationStatus = await _generateOtp();
		Navigator.of(context).pop();
    if (!otpGenerationStatus) {
      return;
    }
		_showOtpVerificationDialog();

    // _checkOtpStatus();
    // if (_formKey.currentState!.validate()) {
    //   _checkOtpStatus();
    // } else {
    //   Navigator.pop(context);
    // }
  }

  // void _showLoadingDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return const AlertDialog(
  //         content: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(width: 20),
  //             Text("Generating OTP..."),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WelcomeLogoWidget(),
                TextFieldWidget(
                  label: 'Phone number',
                  icon: Icons.call,
                  errorText: null,
                  onSave: (value) => {loginItem.phoneNumber = value!},
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    return validateRegistrationItem(value, "phone number");
                  },
                ),
                FormDropdown<Language>(
                  label: 'Language',
                  value: null,
                  icon: Icons.language,
                  items: language,
                  errorText: null,
                  onChanged: (value) {
                    loginItem.setLanguage(value);
                  },
                  validator: (value) =>
                      validateRegistrationItem(value, "language"),
                ),
                const SizedBox(height: 8),
                ActionButton(
                  onPressed: () => _submit(),
                  text: "Log In",
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const RegisterScreen()));
                  },
                  child: const Row(spacing: 8, children: [
                    Text(
                      "Don't have an accout?",
                    ),
                    Text(
                      "Register Here",
                      style: TextStyle(color: darkerOrange),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
