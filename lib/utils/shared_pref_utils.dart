import 'package:shared_preferences/shared_preferences.dart';

Future<bool> clearAllSharedPref() async {
  try {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.setBool('otp_verified', false);
    await prefs.setString('id_token', '');
    await prefs.setString('loggedInNum', '');
    await prefs.setString('submittedCount', '');
    await prefs.setBool("referral_send", false);
    return true;
  } catch (_) {
    return false;
  }
}
