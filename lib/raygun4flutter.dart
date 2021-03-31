import 'package:flutter/services.dart';
import 'package:stack_trace/stack_trace.dart';

/// The official Raygun provider for Flutter.
/// This is the main class that provides functionality for
/// sending exceptions to the Raygun service.
class Raygun {
  // Don't allow instances
  Raygun._();

  static const _channel = MethodChannel('com.raygun.raygun4flutter/raygun4flutter');

  static Future init(String apiKey) async {
    await _channel.invokeMethod('init', <String, String>{
      'apiKey': apiKey,
    });
  }

  /// Sends an exception to Raygun.
  static Future sendException(
    Object error, [
    StackTrace? stackTrace,
  ]) async {
    await sendCustom(
      error.runtimeType.toString(),
      error.toString(),
      stackTrace,
    );
  }

  /// Sends a custom error message to Raygun.
  static Future sendCustom(
    String className,
    String reason, [
    StackTrace? stackTrace,
  ]) async {
    var traceLocations = '';
    if (stackTrace != null) {
      traceLocations = Trace.from(stackTrace).frames.map((frame) => '${frame.member}#${frame.location}').join(';');
    }

    await _channel.invokeMethod('send', <String, String>{
      'className': className,
      'reason': reason,
      'stackTrace': traceLocations,
    });
  }

  /// Sends a breadcrumb to Raygun
  static Future breadcrumb(String message) async {
    await _channel.invokeMethod('breadcrumb', <String, String>{
      'message': message,
    });
  }

  /// Sets User Id to Raygun
  static Future setUserId(dynamic userId) async {
    String? stringToSend;
    if (userId is int) {
      stringToSend = userId.toString();
    } else if (userId is String) {
      stringToSend = userId;
    }

    await _channel.invokeMethod('userId', <String, String?>{
      'userId': stringToSend,
    });
  }
}
