// ignore_for_file: avoid_classes_with_only_static_members, avoid_print

import 'package:flutter/foundation.dart';

/// Internal logger to print debug and error messages.
///
/// Only displays debug logs on debug mode.
/// Warnings and Errors are always displayed.
class RaygunLogger {
  static void d(String message) {
    if (kDebugMode) {
      print('[RAYGUN][D] $message');
    }
  }

  static void i(String message) {
    print('[RAYGUN][I] $message');
  }

  static void w(String message) {
    print('[RAYGUN][WARNING] $message');
  }

  static void e(String message) {
    print('[RAYGUN][ERROR] $message');
  }
}
