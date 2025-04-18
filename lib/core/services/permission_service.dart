
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestMediaPermission() async {
    return await Permission.photos.request();
  }

  Future<bool> isMediaPermissionGranted() async {
    return await Permission.photos.isGranted;
  }
}