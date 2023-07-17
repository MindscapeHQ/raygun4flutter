import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/services/settings.dart';
import 'package:raygun4flutter/src/utils/response.dart';

abstract class CrashReportingPostServiceBase {
  late http.Client _client;

  CrashReportingPostServiceBase({
    http.Client? client,
  }) {
    _client = client ?? http.Client();
  }

  Future<void> store(dynamic jsonPayload);

  Future<void> sendAllStored(String apiKey);

  /// Raw post method that delivers a pre-built Crash Reporting payload to the Raygun API.
  ///
  /// @param apiKey      The API key of the app to deliver to
  /// @param jsonPayload The JSON representation of a RaygunMessage to be delivered over HTTPS.
  /// @return HTTP result code - 202 if successful, 403 if API key invalid, 400 if bad message (invalid properties), 429 if rate limited
  Future<Response<int>> postCrashReporting(String apiKey, dynamic jsonPayload, {Map<String, String>? additionalHeaders}) async {
    final connectivity = await Settings.getConnectivityState();
    if (connectivity == ConnectivityResult.none) {
      // No connection, store crash in cache
      RaygunLogger.w('No connection, caching payload');
      await store(jsonPayload);
    } else {
      final result = await send(apiKey, jsonPayload, additionalHeaders: additionalHeaders);
      // If sending error or rate limited (429)
      if (result.isError || (result.isSuccess && result.asSuccess.value == 429)) {
        // Failed to send payload, storing in cache
        await store(jsonPayload);
      } else {
        return result;
      }
    }
    return Response.error('Could not send report now.');
  }

  Future<Response<int>> send(String apiKey, dynamic jsonPayload, {Map<String, String>? additionalHeaders}) async {
    try {
      RaygunLogger.d('Sending crash reports');
      if (_validateApiKey(apiKey)) {
        Map<String, String> headers = {
          'X-ApiKey': apiKey,
          'Content-Type': 'application/json; charset=utf-8',
        };
        if (additionalHeaders != null) {
          headers.addAll(additionalHeaders);
        }
        final response = await _client.post(Uri.parse(Settings.crashReportingEndpoint), body: jsonEncode(jsonPayload), headers: headers);
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
}
