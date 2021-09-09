import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:raygun4flutter/src/services/settings.dart';
import 'package:raygun4flutter/src/utils/response.dart';

class CrashReportingPostService {
  /// Raw post method that delivers a pre-built Crash Reporting payload to the Raygun API.
  ///
  /// @param apiKey      The API key of the app to deliver to
  /// @param jsonPayload The JSON representation of a RaygunMessage to be delivered over HTTPS.
  /// @return HTTP result code - 202 if successful, 403 if API key invalid, 400 if bad message (invalid properties), 429 if rate limited
  Future<Response<int>> postCrashReporting(
    String apiKey,
    dynamic jsonPayload,
  ) async {
    try {
      if (_validateApiKey(apiKey)) {
        final response = await http.post(
          Uri.parse(Settings.crashReportingEndpoint),
          body: jsonEncode(jsonPayload),
          headers: {
            'X-ApiKey': apiKey,
            'Content-Type': 'application/json; charset=utf-8',
          },
        );
        return Response.success(response.statusCode);
      } else {
        return Response.error(
          'API key is empty, nothing will be logged or reported',
        );
      }
    } catch (e) {
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
