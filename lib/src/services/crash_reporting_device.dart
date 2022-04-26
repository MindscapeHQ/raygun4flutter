import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/services/crash_reporting_post_service.dart';

import 'settings.dart';

class CrashReportingPostService extends CrashReportingPostServiceBase {
  CrashReportingPostService({http.Client? client}) : super(client: client);

  @override
  Future<void> store(dynamic jsonPayload) async {
    RaygunLogger.d('Storing crash for later');
    try {
      final cacheDir = await getTemporaryDirectory();
      RaygunLogger.d('Cache dir: $cacheDir');
      final cachedFiles = cacheDir
          .listSync()
          .where((element) => element.path.endsWith('.raygun4'));
      RaygunLogger.d('Currently ${cachedFiles.length} stored');
      if (cachedFiles.length < Settings.maxReportsStoredOnDevice) {
        final timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        final file = File('${cacheDir.path}/$timestamp.raygun4');
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
      final cacheDir = await getTemporaryDirectory();
      RaygunLogger.d('Cache dir: $cacheDir');
      final cachedFiles = cacheDir
          .listSync()
          .where((element) => element.path.endsWith('.raygun4'));
      RaygunLogger.d('Currently ${cachedFiles.length} stored');
      for (final file in cachedFiles) {
        final content = await File(file.path).readAsString();
        final result = await send(apiKey, jsonDecode(content));
        if (result.isSuccess && result.asSuccess.value != 429) {
          RaygunLogger.d('Stored payload sent, deleting file: ${file.path}');
          await file.delete();
        } else {
          RaygunLogger.w('Failed to send ${file.path}');
        }
      }
    } catch (e) {
      RaygunLogger.e('Error while sending stored payloads: $e');
    }
  }
}
