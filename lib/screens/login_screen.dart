import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karya_flutter/screens/register_screen.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/worker_api.dart';
import 'package:karya_flutter/widgets/dropdown_widget.dart';
import 'package:karya_flutter/widgets/logo_widget.dart';
import 'package:karya_flutter/widgets/phone_num_textbox_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? _selectedLanguage;
  List<String> _languages = [];
  Map<String, dynamic>? langData;

  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;

  SharedPreferences? prefs;
  String? accessCode;
  String? loggedInNum;
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    _initLangJson();
    _initSharedPrefnAC();

    dio = Dio();
    apiService = ApiService(dio);
    workerApiService = WorkerApiService(apiService);
  }

  Future<bool> _generateOtp() async {
    try {
      String? accessEncode = dotenv.env['ACCESS_ENCODE'];
      int? langValue = langData?[_selectedLanguage];
      accessCode = '$phoneNumber$accessEncode$langValue';
      print("accesscode is: $accessCode");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessCode', accessCode!);
      final response =
          await workerApiService.generateOTP(accessCode!, phoneNumber);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error generating OTP: $e');
      return false;
    }
  }

  Future<bool> _verifyOtp(String otp) async {
    try {
      final response =
          await workerApiService.verifyOTP(accessCode!, phoneNumber, otp);
      // print("verify otp response: $response");
      if (response.statusCode == 200) {
        final Map<String, dynamic> otpResponse = jsonDecode(response.data!);
        final String? idToken = otpResponse['id_token'];
        final int submittedCount = otpResponse['submitted_count'] ?? 0;

        if (idToken != null) {
          await prefs?.setString('id_token', idToken);
          await prefs?.setString('loggedInNum', phoneNumber);
          await prefs?.setInt('submittedCount', submittedCount);
        } else {
          log('ID Token not found in the response.');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error generating OTP: $e');
      return false;
    }
  }

  Future<void> _initLangJson() async {
    final String langJson =
        await rootBundle.loadString('assets/mappings_json/lang_code.json');
    setState(() {
      langData = jsonDecode(langJson);
      _languages = langData!.keys.toList();
      _selectedLanguage = null;
    });
  }

  Future<void> _initSharedPrefnAC() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInNum = prefs?.getString('loggedInNum') ?? '0';
    });
  }

  Future<void> _checkOtpStatus() async {
    if (phoneNumber != loggedInNum) {
      await prefs?.setBool('otp_verified', false);
    }
    prefs = await SharedPreferences.getInstance();
    bool? isVerified = prefs?.getBool('otp_verified');
    if (!isVerified!) {
      bool isOtpGenerated = await _generateOtp();
      if (isOtpGenerated) {
        _showOtpNotVerifiedDialog();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Phone number is wrong or OTP generation failed. Kindly check your internet connection')),
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<bool> _handleSubmit() async {
    final otp = otpController.text;
    if (otp.isNotEmpty) {
      bool otpStat = await _verifyOtp(otp);
      if (otpStat) {
        prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs?.setBool('otp_verified', true);
        });

        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, '/dashboard');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('OTP verification failed. Please try again')),
        );
      }
      return otpStat;
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('OTP can\'t be empty')),
      // );
      return false;
    }
  }

  Future<void> _handleResend() async {
    try {
      final response =
          await workerApiService.resendOTP(accessCode!, phoneNumber);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('OTP send again to the registered number')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent failed. Please try again')),
        );
      }
    } catch (e) {
      log('Error generating OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent failed. Please try again')),
      );
    }
  }

  void _showOtpNotVerifiedDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String errorMessage = '';
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: const Text('OTP Verification'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your phone number is not verified. We have send an otp to the registered number. Please enter OTP here to continue :',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                        labelText: 'OTP',
                        border: OutlineInputBorder(),
                        errorText:
                            errorMessage.isNotEmpty ? errorMessage : null),
                    // errorText: 'Invalid OTP. Please try again'),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                ],
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _handleResend,
                          child: const Text('Resend'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isVerified = await _handleSubmit();
                            if (!isVerified) {
                              setState(() {
                                errorMessage = 'Invalid OTP. Please try again.';
                              });
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ]);
        });
      },
    );
  }

  void _submit() {
    _showLoadingDialog(context);
    if (_formKey.currentState!.validate()) {
      phoneNumber = _phoneNumberController.text;
      _checkOtpStatus();
    } else {
      Navigator.pop(context);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Generating OTP..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WelcomeLogoWidget(),
                const SizedBox(height: 20),
                PhoneNumberInput(controller: _phoneNumberController),
                const SizedBox(height: 20),
                CustomDropdown(
                  value: _selectedLanguage,
                  items: _languages,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a language.';
                    }
                    return null;
                  },
                  label: 'Language',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Register here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
