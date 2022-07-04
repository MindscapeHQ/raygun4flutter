import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/services/crash_reporting_post_service.dart';
import 'package:uuid/uuid.dart';

import 'settings.dart';

class CrashReportingPostService extends CrashReportingPostServiceBase {
  CrashReportingPostService({http.Client? client}) : super(client: client);

  static const _uuid = Uuid();

  @override
  Future<void> store(dynamic jsonPayload) async {
    RaygunLogger.d('Storing crash for later');
    try {
      final cacheDir = await getTemporaryDirectory();
      final cachedFiles = await _getCachedFiles();
      RaygunLogger.d('Currently ${cachedFiles.length} stored');
      if (cachedFiles.length < Settings.maxReportsStoredOnDevice) {
        final timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        final uuid = _uuid.v4();
        final file = File('${cacheDir.path}/$timestamp-$uuid.raygun4');
        await file.writeAsString(jsonEncode(jsonPayload));
        RaygunLogger.d('Saved payload in: ${file.path}');
      } else {
        RaygunLogger.w(
          "Can't write crash report to local disk, maximum number of stored reports reached.",
        );
      }
    } catch (e) {
      RaygunLogger.e('Failed to store payload: $e');
    }
  }

  @override
  Future<void> sendAllStored(String apiKey) async {
    RaygunLogger.d('Sending all stored crash reports');
    final connectivity = await Settings.getConnectivityState();
    if (connectivity == ConnectivityResult.none) {
      RaygunLogger.w('No connectivity, cannot send stored payloads');
      return;
    }
    try {
      final cachedFiles = await _getCachedFiles();
      RaygunLogger.d('Currently ${cachedFiles.length} stored');
      for (final file in cachedFiles) {
        try {
          final content = await File(file.path).readAsString();
          final json = jsonDecode(content);
          final result = await send(apiKey, json);
          if (result.isSuccess && result.asSuccess.value != 429) {
            RaygunLogger.d('Stored payload sent, deleting file: ${file.path}');
            await file.delete();
          } else {
            RaygunLogger.w('Failed to send ${file.path}');
          }
        } on FormatException catch (e) {
          RaygunLogger.e(
            'Format exception in stored payload: ${file.path} error: $e',
          );
          RaygunLogger.w('Deleting file');
          await file.delete();
        }
      }
    } catch (e) {
      RaygunLogger.e('Error while sending stored payloads: $e');
      RaygunLogger.w('Deleting all cached files');
      final cachedFiles = await _getCachedFiles();
      for (final file in cachedFiles) {
        await file.delete();
      }
    }
  }

  Future<Iterable<FileSystemEntity>> _getCachedFiles() async {
    final cacheDir = await getTemporaryDirectory();
    RaygunLogger.d('Cache dir: $cacheDir');
    return cacheDir
        .listSync()
        .where((element) => element.path.endsWith('.raygun4'));
  }
}
