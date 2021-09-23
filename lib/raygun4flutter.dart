import 'package:package_info_plus/package_info_plus.dart';
import 'package:raygun4flutter/src/raygun_crash_reporting.dart';
import 'package:raygun4flutter/src/services/settings.dart';
import 'package:stack_trace/stack_trace.dart';

import 'src/messages/raygun_breadcrumb_message.dart';
import 'src/messages/raygun_user_info.dart';

export 'src/messages/raygun_breadcrumb_message.dart';
export 'src/messages/raygun_user_info.dart';

/// The official Raygun provider for Flutter.
/// This is the main class that provides functionality for
/// sending exceptions to the Raygun service.
class Raygun {
  // Don't allow instances
  Raygun._();

  /// Initalizes the Raygun client with your Raygun API [apiKey].
  ///
  /// [version] is optional, if not provided it will be obtained from your
  /// pubspec.yaml.
  static Future<void> init({
    required String apiKey,
    String? version,
  }) async {
    Settings.apiKey = apiKey;
    setVersion(version);
  }

  /// Manually stores the version of your application to be transmitted with
  /// each message, for version filtering. This is normally read from your
  /// pubspec.yaml or passed in on init(); this is only provided as a convenience.
  ///
  /// [version] The version of your application, format x.x.x.x, where x is a
  /// positive integer.
  static Future<void> setVersion(
    String? version,
  ) async {
    if (version != null) {
      Settings.version = version;
    } else {
      final info = await PackageInfo.fromPlatform();
      Settings.version = info.version;
    }
  }

  /// Sends an exception to Raygun.
  /// Convenience method that wraps [sendCustom].
  /// The class name and the message are obtained from the [error] object.
  static Future<void> sendException({
    required Object error,
    List<String>? tags,
    Map<String, dynamic>? customData,
    StackTrace? stackTrace,
  }) async {
    return sendCustom(
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
  static Future<void> sendCustom({
    required String className,
    required String reason,
    List<String>? tags,
    Map<String, dynamic>? customData,
    StackTrace? stackTrace,
  }) async {
    Trace trace;
    if (stackTrace == null) {
      // if no stackTrace provided, create one
      trace = Trace.current();
    } else {
      trace = Trace.from(stackTrace);
    }

    return CrashReporting.send(className, reason, tags, customData, trace);
  }

  /// Sets a List of tags which will be sent along with every exception.
  /// This will be merged with any other tags passed in [sendException] and [sendCustom].
  ///
  /// Set to null to clear the value.
  static Future<void> setTags(List<String>? tags) async {
    Settings.tags = tags;
  }

  /// Sets a key-value Map which, like the tags, will be sent along with every exception.
  /// This will be merged with any other custom data passed in [sendException] and [sendCustom].
  ///
  /// Set to null to clear the value.
  static Future<void> setCustomData(Map<String, dynamic>? customData) async {
    Settings.customData = customData;
  }

  /// Sends a breadcrumb to Raygun as String
  static Future<void> recordBreadcrumb(String message) async {
    Settings.breadcrumbs.add(RaygunBreadcrumbMessage(message: message));
  }

  /// Sends a breadcrumb to Raygun as [RaygunBreadcrumbMessage]
  static Future<void> recordBreadcrumbObject(
    RaygunBreadcrumbMessage raygunBreadcrumbMessage,
  ) async {
    Settings.breadcrumbs.add(raygunBreadcrumbMessage);
  }

  /// Clears breadcrumbs
  static Future<void> clearBreadcrumbs() async {
    Settings.breadcrumbs.clear();
  }

  /// Sets the current user of your application.
  ///
  /// This is a convenience method wrapping [setUser].
  ///
  /// If you use an email address to identify the user, please consider using
  /// [setUser] instead of this method as it would allow you to set the email
  /// address into both the identifier and email fields of the crash data to be sent.
  ///
  /// [userId] A user name or email address representing the current user.
  ///
  /// Set to null to clear User Id
  static Future<void> setUserId(String? userId) async {
    Settings.userInfo = RaygunUserInfo(identifier: userId);
  }

  /// Sets the current user of your application.
  ///
  /// If user is an email address which is associated with a Gravatar,
  /// their picture will be displayed in the error view.
  ///
  /// If [setUser] is not called, a random ID will be assigned.
  ///
  /// If the user context changes in your application (i.e log in/out), be sure
  /// to call this again with the updated user name/email address.
  ///
  /// [raygunUserInfo] A [RaygunUserInfo] object containing the user data you want to send in its fields.
  ///
  /// Set to null to clear
  static Future<void> setUser(RaygunUserInfo? raygunUserInfo) async {
    Settings.userInfo = raygunUserInfo ?? RaygunUserInfo();
  }

  /// Allows the user to set a custom endpoint for Crash Reporting
  ///
  /// [url] String with the URL to be used
  ///
  /// Set to null to use default.
  static Future<void> setCustomCrashReportingEndpoint(String? url) async {
    Settings.crashReportingEndpoint =
        url ?? Settings.kDefaultCrashReportingEndpoint;
  }
}
