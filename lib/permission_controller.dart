import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<bool> requestPermission(Permission permission) async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int androidVersion = int.parse(androidInfo.version.release);
    if (androidVersion <= 9) {
      // Code to be executed for Android SDK version 28 and below
      // Add your logic here
      var status = await permission.status;
      if (status.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        }
      }
    } else {
      return true;
    }
  } else {
    // Code to handle non-Android platforms
    // Add your logic here
  }

  return false; // Default return value if the conditions are not met
}

//Request permission for notifications
Future<void> notificationPermission() async {
  var statusNotification = await Permission.notification.status;

  if (statusNotification.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
    if (await Permission.notification.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else {
      await Permission.notification.request();
    }
  }
}

//Request permission for camera
Future<void> cameraPermission() async {
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  if (await Permission.camera.isPermanentlyDenied) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    openAppSettings();
  } else {
    await Permission.camera.request();
  }
}

//Request permission for storage
Future<void> storagePermission() async {
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  if (await Permission.storage.isPermanentlyDenied) {
    // The user opted to never again see the permission request dialog for this
    // app. The only way to change the permission's status now is to let the
    // user manually enable it in the system settings.
    // print('here');
    openAppSettings();
  } else {
    // print('herrrre');
    await Permission.storage.request();
  }
}
