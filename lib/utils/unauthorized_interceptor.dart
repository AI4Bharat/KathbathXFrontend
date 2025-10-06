import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final GlobalKey<NavigatorState> navigatorKey;
  SharedPreferences? prefs;
  String? phoneNum;
  String? accessCode;
  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;
  final TextEditingController otpController = TextEditingController();

  TokenInterceptor(this.navigatorKey);
  // late Dio dio;
  // late ApiService apiService;
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // dio = Dio();
      // apiService = ApiService(dio);
      // final MicroTaskAssignmentService microApiService = MicroTaskAssignmentService(apiService);
      // var jsonOut = await microApiService.renewToken()

      final context = navigatorKey.currentContext;
      Navigator.pop(context!);
      prefs = await SharedPreferences.getInstance();
      phoneNum = prefs?.getString('loggedInNum') ?? '0';
      accessCode = prefs?.getString('accessCode') ?? '0';
      bool isOtpGenerated = await _generateOtp();
      if (isOtpGenerated) {
        _showOtpNotVerifiedDialog();
      }
      // if (context != null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //         content: Text(
      //             "Token expired. We are renewing your token. Kindly wait 10 seconds before submitting again"),
      //         duration: Duration(seconds: 10)),
      //   );
      //   // Optionally: Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      // }
    }
    // super.onError(err, handler);
    handler.next(err);
  }

  Future<bool> _generateOtp() async {
    try {
      dio = Dio();
      apiService = ApiService(dio);
      workerApiService = WorkerApiService(apiService);
      print("accesscode is: $accessCode");
      final response =
          await workerApiService.generateOTP(accessCode!, phoneNum!);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('OTP generation failed: $e')),
      // );
      log('Error generating OTP: $e');
      return false;
    }
  }

  void _showOtpNotVerifiedDialog() {
    final context = navigatorKey.currentContext;
    log("reached here generating otp");
    if (context == null) {
      log("Cannot show dialog: navigatorKey.currentContext is null");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String errorMessage = '';
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: const Text('Passcode Verification'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Your session has expired. Please enter the Passcode/OTP to continue. Wait for verification before resubmitting.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                        labelText: 'Passcode',
                        border: const OutlineInputBorder(),
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
                        // ElevatedButton(
                        //   onPressed: _handleResend,
                        //   child: const Text('Resend'),
                        // ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isVerified = await _handleSubmit();
                            if (!isVerified) {
                              setState(() {
                                errorMessage =
                                    'Invalid passcode. Please try again.';
                              });
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ]);
        });
      },
    );
  }

  Future<bool> _handleSubmit() async {
    final context = navigatorKey.currentContext;
    final otp = otpController.text;
    if (otp.isNotEmpty) {
      bool otpStat = await _verifyOtp(otp);
      if (otpStat) {
        Navigator.of(context!).pop();
        prefs = await SharedPreferences.getInstance();
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text('Passcode verified successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
              content: Text('Passcode verification failed. Please try again')),
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
    final context = navigatorKey.currentContext;
    try {
      final response = await workerApiService.resendOTP(accessCode!, phoneNum!);
      log("resend response:$response");
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
              content: Text('OTP send again to the registered number')),
        );
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(content: Text('OTP resent failed. Please try again')),
        );
      }
    } catch (e) {
      log('Error generating OTP: $e');
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
            content: Text('OTP resent failed. error. Please try again')),
      );
    }
  }

  Future<bool> _verifyOtp(String otp) async {
    try {
      final response =
          await workerApiService.verifyOTP(accessCode!, phoneNum!, otp);
      print("verify otp response ${response.data}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> otpResponse = jsonDecode(response.data!);
        final String? idToken = otpResponse['id_token'];

        if (idToken != null) {
          await prefs?.setString('id_token', idToken);
        } else {
          log('ID Token not found in the response.');
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('OTP verification failed: $e')),
      // );
      log('Error generating OTP: $e');
      return false;
    }
  }
}
