import 'package:flutter/material.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:path/path.dart';

class OtpVerificationDialog extends StatelessWidget {
  final TextEditingController otpTextController = TextEditingController();
  final WorkerApiService workerApiService;
  final String accessCode;
  String? otpErrorMessage;

  OtpVerificationDialog(
      {required this.workerApiService, required this.accessCode});

  void _submitAndVerifyOtp(BuildContext context) async {
    otpErrorMessage = null;
    String otp = otpTextController.text;

    final response = await workerApiService.verifyOTP(accessCode, otp);
    print("The verify otp response is ${response.responseCode}");
    if (!context.mounted) {
      return;
    }
    if (response.responseCode == 200) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      otpErrorMessage = response.message;
    }
  }

  void _resentOtp(BuildContext context) async {
    otpTextController.text = "";
    final response = await workerApiService.resendOTP(accessCode);
    if (!context.mounted) {
      return;
    }

    if (response.responseCode == 200) {
		print("\nresent otp was successfull\n");
    } else {
      otpErrorMessage = response.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Passcode/OTP Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter the OTP sent to your phone number or the unique passcode provided to you.',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otpTextController,
              decoration:
                  InputDecoration(labelText: 'OTP', errorText: otpErrorMessage),
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
                    onPressed: () => _resentOtp(context),
                    child: const Text('Resend'),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitAndVerifyOtp(context),
                    // async {
                    //                // bool isVerified = await _handleSubmit();
                    //                if (!isVerified) {
                    //                  setState(() {
                    //                    errorMessage = 'Invalid OTP. Please try again.';
                    //                  });
                    //                }
                    //              },
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
  }
}
