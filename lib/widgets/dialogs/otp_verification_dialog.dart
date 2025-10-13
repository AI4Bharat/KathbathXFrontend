import 'package:flutter/material.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:kathbath_lite/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationDialog extends StatefulWidget {
  final WorkerApiService workerApiService;
  final String accessCode;
  const OtpVerificationDialog(
      {super.key, required this.workerApiService, required this.accessCode});

  @override
  State<StatefulWidget> createState() {
    return _OtpVerificationDialogState();
  }
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final TextEditingController otpTextController = TextEditingController();
  String? otpErrorMessage;
  bool showLoading = false;

  changeLoadingStatus(bool status) {
    setState(() {
      showLoading = status;
    });
  }

  void _submitAndVerifyOtp(BuildContext context) async {
    // removing the keyboard
    FocusScope.of(context).unfocus();
    otpErrorMessage = null;
    String otp = otpTextController.text;
    String? error = validateOTP(otp);
    if (error != null) {
      setState(() {
        otpErrorMessage = error;
      });
      return;
    }

    changeLoadingStatus(true);
    final response =
        await widget.workerApiService.verifyOTP(widget.accessCode, otp);
    changeLoadingStatus(false);
    if (!context.mounted) {
      return;
    }
    if (response.responseCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("id_token", response.details["id_token"]);

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState(() {
        otpErrorMessage = response.message;
      });
    }
  }

  void _resendOtp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    otpTextController.text = "";
    changeLoadingStatus(true);
    final response = await widget.workerApiService.resendOTP(widget.accessCode);
    changeLoadingStatus(false);
    if (!context.mounted) {
      return;
    }
    if (response.responseCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP/Passcode was resend")));
    } else {
      setState(() {
        otpErrorMessage = response.message;
      });
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
            TextField(
              controller: otpTextController,
              decoration: InputDecoration(
                  labelText: 'OTP/Passcode', errorText: otpErrorMessage),
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
                    onPressed: () => _resendOtp(context),
                    child: const Text('Resend'),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitAndVerifyOtp(context),
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
          showLoading
              ? const LinearProgressIndicator()
              : const SizedBox(height: 2)
        ]);
  }
}
