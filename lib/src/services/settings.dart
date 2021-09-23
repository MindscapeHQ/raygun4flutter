// ignore_for_file: avoid_classes_with_only_static_members

import 'package:http/http.dart' as http;
import 'package:raygun4flutter/raygun4flutter.dart';

class Settings {
  static const kDefaultCrashReportingEndpoint = "https://api.raygun.io/entries";

  static String crashReportingEndpoint = kDefaultCrashReportingEndpoint;

  static String? apiKey;

  static String? version;

  static RaygunUserInfo userInfo = RaygunUserInfo();

  static List<RaygunBreadcrumbMessage> breadcrumbs = [];

  /// Global custom data
  static Map<String, dynamic>? customData;

  /// Global tags
  static List<String>? tags;

  /// Allow to set a custom HttpClient (internal for testing)
  static http.Client? customHttpClient;

  /// Set to true during unit tests
  static bool skipIfTest = false;
}
