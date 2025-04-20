// coverage:ignore-file

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestMediaPermission() async {

    if (Platform.isAndroid) {
      int sdkInt = await getAndroidSdkVersion();
      if (sdkInt <= 32) {
        // Android 12 and below
          return await Permission.storage.request();
      }
    }

    return await Permission.photos.request();

  }

  Future<bool> isMediaPermissionGranted() async {

    if (Platform.isAndroid) {
      int sdkInt = await getAndroidSdkVersion();
      if (sdkInt <= 32) {
        // Android 12 and below
        return await Permission.storage.isGranted;
      }
    }

    return await Permission.photos.isGranted;
  }

  Future<int> getAndroidSdkVersion() async {

    if(Platform.isAndroid == false) Exception("This method is only available for Android devices");

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    return sdkInt;

  }
}