import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionService {
  static Future<bool> requestStoragePermissions() async {
    if (!Platform.isAndroid) return true;

    PermissionStatus status;
    
    // Request storage permission
    if (await Permission.storage.isDenied) {
      status = await Permission.storage.request();
      if (status.isDenied) {
        return false;
      }
    }
    
    // Request photos permission
    if (await Permission.photos.isDenied) {
      status = await Permission.photos.request();
      if (status.isDenied) {
        return false;
      }
    }
    
    return true;
  }
} 