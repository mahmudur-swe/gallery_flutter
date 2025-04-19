
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestMediaPermission() async {
    // return await Permission.storage.request();

    if (await Permission.storage.isGranted) return PermissionStatus.granted;

    if (await Permission.photos.request().isGranted) return PermissionStatus.granted;

    if (await Permission.storage.request().isGranted) return PermissionStatus.granted;

    return PermissionStatus.denied;
  }

  Future<bool> isMediaPermissionGranted() async {
    return await Permission.photos.isGranted  || await Permission.storage.isGranted;
  }
}