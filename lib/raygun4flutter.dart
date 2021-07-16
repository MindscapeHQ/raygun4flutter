import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stack_trace/stack_trace.dart';

/// The official Raygun provider for Flutter.
/// This is the main class that provides functionality for
/// sending exceptions to the Raygun service.
class Raygun {
  // Don't allow instances
  Raygun._();

  @visibleForTesting
  static const channel =
      MethodChannel('com.raygun.raygun4flutter/raygun4flutter');

  /// Initalizes the Raygun client with your Raygun API [apiKey].
  ///
  /// [version] is optional, if not provided it will be obtained from your
  /// pubspec.yaml.
  static Future init({
    required String apiKey,
    String? version,
  }) async {
    await channel.invokeMethod('init', <String, dynamic>{
      'apiKey': apiKey,
      'version': version,
    });
  }

  /// Sends an exception to Raygun.
  /// Convenience method that wraps [sendCustom].
  /// The class name and the message are obtained from the [error] object.
  static Future sendException({
    required Object error,
    List<String>? tags,
    Map<String, dynamic>? customData,
    StackTrace? stackTrace,
  }) async {
    await sendCustom(
      className: error.runtimeType.toString(),
      reason: error.toString(),
      tags: tags,
      customData: customData,
      stackTrace: stackTrace,
    );
  }

  /// Sends a custom error message to Raygun.
  ///
  /// [className] and [reason] correspond to the class name and message displayed
  /// in Raygun's dashboard.
  ///
  /// [tags] A list of data that will be attached to the Raygun message and
  /// visible on the error in the dashboard.
  /// This could be a build tag, lifecycle state, debug/production version etc.
  ///
  /// [customData] A set of custom key-value pairs relating to your application
  /// and its current state. This is a bucket
  /// where you can attach any related data you want to see to the error.
  ///
  /// [stackTrace] optional parameter, if not provided this method will obtain
  /// the current stacktrace automatically.
  static Future sendCustom({
    required String className,
    required String reason,
    List<String>? tags,
    Map<String, dynamic>? customData,
    StackTrace? stackTrace,
  }) async {
    var traceLocations = '';
    if (stackTrace == null) {
      // if no stackTrace provided, create one
      traceLocations = Trace.current()
          .frames
          // skip all frames that reference to this file
          .skipWhile((element) => element.location.contains('raygun4flutter.dart'))
          .map((frame) => '${frame.member}#${frame.location}')
          .join(';');
    } else {
      traceLocations = Trace.from(stackTrace)
          .frames
          .map((frame) => '${frame.member}#${frame.location}')
          .join(';');
    }

    await channel.invokeMethod('send', <String, dynamic>{
      'className': className,
      'reason': reason,
      'stackTrace': traceLocations,
      'tags': tags,
      'customData': customData,
    });
  }

  /// Sets a List of tags which will be sent along with every exception.
  /// This will be merged with any other tags passed in [sendException] and [sendCustom].
  ///
  /// Set to null to clear the value.
  static Future<void> setTags(List<String>? tags) async {
    await channel.invokeMethod('setTags', tags);
  }

  /// Sets a key-value Map which, like the tags, will be sent along with every exception.
  /// This will be merged with any other custom data passed in [sendException] and [sendCustom].
  ///
  /// Set to null to clear the value.
  static Future<void> setCustomData(Map<String, dynamic>? tags) async {
    await channel.invokeMethod('setCustomData', tags);
  }

  /// Sends a breadcrumb to Raygun
  static Future breadcrumb(String message) async {
    await channel.invokeMethod('breadcrumb', <String, String>{
      'message': message,
    });
  }

  /// Sets User Id to Raygun
  ///
  /// Set to null to clear User Id
  static Future setUserId(String? userId) async {
    await channel.invokeMethod('userId', <String, String?>{
      'userId': userId,
    });
  }
}
