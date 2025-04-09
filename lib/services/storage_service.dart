import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class StorageService {
  static Future<String> savePDF(List<int> bytes, String fileName) async {
    Directory? directory;
    if (Platform.isAndroid) {
      // Try to save in Downloads folder first
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        // Fallback to external storage
        directory = await getExternalStorageDirectory();
      }
    } else {
      // For iOS, use app documents directory
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not access storage directory');
    }

    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<void> openFile(String filePath) async {
    await OpenFile.open(filePath);
  }
} 