import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class VoskModelManager {
  static final VoskModelManager _instance = VoskModelManager._internal();
  factory VoskModelManager() => _instance;
  VoskModelManager._internal();

  final Dio _dio = Dio();

  Future<String> getModelsPath() async {
    final appDir = await getApplicationSupportDirectory();
    final path = "${appDir.path}/vosk_models";
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  Future<bool> isModelDownloaded(String modelName) async {
    final path = await getModelsPath();
    final modelDir = Directory("$path/$modelName");
    return await modelDir.exists();
  }

  Future<void> downloadAndExtractModel({
    required String modelName,
    required String url,
    required Function(double) onProgress,
    required Function(String) onStatus,
  }) async {
    try {
      final modelsPath = await getModelsPath();
      final zipPath = "$modelsPath/$modelName.zip";

      onStatus("Yuklanmoqda...");
      await _dio.download(
        url,
        zipPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      onStatus("Extract qilinmoqda (unzip)...");
      onProgress(0); // Reset for extraction

      final bytes = File(zipPath).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      int totalFiles = archive.length;
      int count = 0;

      for (final file in archive) {
        final filename = "$modelsPath/${file.name}";
        if (file.isFile) {
          final data = file.content as List<int>;
          File(filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(filename).createSync(recursive: true);
        }
        count++;
        onProgress(count / totalFiles);
      }

      // ZIP faylni o'chirib tashlaymiz (joy tejash uchun)
      await File(zipPath).delete();
      onStatus("Tayyor!");
    } catch (e) {
      onStatus("Xato: $e");
      rethrow;
    }
  }

  Future<String?> getModelLocalPath(String modelName) async {
    if (await isModelDownloaded(modelName)) {
      final path = await getModelsPath();
      return "$path/$modelName";
    }
    return null;
  }
}
