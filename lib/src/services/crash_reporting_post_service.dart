import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/services/settings.dart';
import 'package:raygun4flutter/src/utils/response.dart';
import 'package:intl/intl.dart';

class CrashReportingPostService {
  late http.Client _client;

  CrashReportingPostService({
    http.Client? client,
  }) {
    _client = client ?? http.Client();
  }

  /// Raw post method that delivers a pre-built Crash Reporting payload to the Raygun API.
  ///
  /// @param apiKey      The API key of the app to deliver to
  /// @param jsonPayload The JSON representation of a RaygunMessage to be delivered over HTTPS.
  /// @return HTTP result code - 202 if successful, 403 if API key invalid, 400 if bad message (invalid properties), 429 if rate limited
  Future<Response<int>> postCrashReporting(
    String apiKey,
    dynamic jsonPayload,
  ) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // No connection, store crash in cache
      RaygunLogger.w('No connection, caching payload');
      await _store(jsonPayload);
    } else {
      final result = await _send(apiKey, jsonPayload);
      // If sending error or rate limited (429)
      if (result.isError ||
          (result.isSuccess && result.asSuccess.value == 429)) {
        // Failed to send payload, storing in cache
        await _store(jsonPayload);
      } else {
        return result;
      }
    }
    return Response.error('Could not send report now.');
  }

  Future<Response<int>> _send(String apiKey, jsonPayload) async {
    try {
      RaygunLogger.d('Sending crash reports');
      if (_validateApiKey(apiKey)) {
        final response = await _client.post(
          Uri.parse(Settings.crashReportingEndpoint),
          body: jsonEncode(jsonPayload),
          headers: {
            'X-ApiKey': apiKey,
            'Content-Type': 'application/json; charset=utf-8',
          },
        );
        RaygunLogger.d(
          'Sent crash reports. Response code: ${response.statusCode}',
        );
        return Response.success(response.statusCode);
      } else {
        RaygunLogger.e('API key is empty, nothing will be logged or reported');
        return Response.error(
          'API key is empty, nothing will be logged or reported',
        );
      }
    } catch (e) {
      RaygunLogger.e('Error while posting crash reports: $e');
      return Response.error(e);
    }
  }

  /// Validation to check if an API key has been supplied to the service
  ///
  /// @param apiKey      The API key of the app to deliver to
  /// @return true or false
  static bool _validateApiKey(String apiKey) {
    if (apiKey.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _store(jsonPayload) async {
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

  Future<void> sendAllStored(String apiKey) async {
    RaygunLogger.d('Sending all stored crash reports');
    final connectivity = await Connectivity().checkConnectivity();
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
        final result = await _send(apiKey, jsonDecode(content));
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
