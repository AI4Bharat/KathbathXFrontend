import 'package:permission_handler/permission_handler.dart';

Future<bool> requestAudioRecordingPermission() async {
  await Permission.storage.request();
  Map<Permission, PermissionStatus> audioRecordingPermissions =
      await [Permission.microphone].request();

  print("The permission are $audioRecordingPermissions");
  if (!audioRecordingPermissions[Permission.microphone]!.isGranted) {
    return false;
  }
  return true;
}
