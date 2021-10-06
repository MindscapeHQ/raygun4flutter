// ignore_for_file: avoid_classes_with_only_static_members, avoid_print

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Internal logger to print debug and error messages.
///
/// Only displays debug logs on debug mode.
/// Warnings and Errors are always displayed.
/// Levels are based on https://github.com/dart-lang/logging/blob/master/lib/src/level.dart
class RaygunLogger {
  static void d(String message) {
    if (kDebugMode) {
      developer.log(
        '[RAYGUN][D] $message',
        level: 500,
        name: 'raygun4flutter',
      );
    }
  }

  static void i(String message) {
    developer.log(
      '[RAYGUN][I] $message',
      level: 800,
      name: 'raygun4flutter',
    );
  }

  static void w(String message) {
    developer.log(
      '[RAYGUN][W] $message',
      level: 900,
      name: 'raygun4flutter',
    );
  }

  static void e(String message) {
    developer.log(
      '[RAYGUN][E] $message',
      level: 1000,
      name: 'raygun4flutter',
    );
  }
}
