// ignore_for_file: avoid_classes_with_only_static_members

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
}
