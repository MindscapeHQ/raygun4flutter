// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:stack_trace/stack_trace.dart';

import 'logging/raygun_logger.dart';
import 'messages/raygun_client_message.dart';
import 'messages/raygun_environment_message.dart';
import 'messages/raygun_error_message.dart';
import 'messages/raygun_message.dart';
import 'services/crash_reporting_post_service.dart';
import 'services/settings.dart';

class CrashReporting {
  static Future<void> send(
    String className,
    String reason,
    List<String>? tags,
    Map? customData,
    Trace? trace,
  ) async {
    final RaygunMessage msg = await _buildMessage(className, reason, trace);

    msg.details.tags = tags ?? [];
    final globalTags = Settings.tags;
    if (globalTags != null) {
      msg.details.tags.addAll(globalTags);
    }

    msg.details.customData = customData ?? {};
    final globalCustomData = Settings.customData;
    if (globalCustomData != null) {
      msg.details.customData.addAll(globalCustomData);
    }

    final response = await CrashReportingPostService(
      client: Settings.customHttpClient,
    ).postCrashReporting(
      Settings.apiKey ?? '',
      msg.toJson(),
    );

    if (response.isSuccess) {
      Settings.breadcrumbs.clear();
    } else {
      RaygunLogger.e(
        'Failed to send Crash Report. Reason: ${response.asError.error}',
      );
    }

    // if (onBeforeSend != null) {
    //   msg = onBeforeSend.onBeforeSend(msg);
    //   if (msg == null) {
    //     return;
    //   }
    // }

    // enqueueWorkForCrashReportingService(
    //     RaygunClient.getApiKey(), new Gson().toJson(msg));
    // postCachedMessages();
  }
}

Future<RaygunMessage> _buildMessage(
  String className,
  String reason,
  Trace? trace,
) async {
  final raygunMessage = RaygunMessage();

  raygunMessage.details.error = RaygunErrorMessage(className, reason);
  if (trace != null) {
    raygunMessage.details.error!.setStackTrace(trace);
  }

  raygunMessage.details.client = RaygunClientMessage();
  raygunMessage.details.breadcrumbs.addAll(Settings.breadcrumbs);
  raygunMessage.details.user = Settings.userInfo;

  // Cannot load device info in tests
  if (!Settings.skipIfTest) {
    raygunMessage.details.machineName = await _machineName();
    raygunMessage.details.environment =
        await RaygunEnvironmentMessage.fromDeviceInfo();
  }

  // .setEnvironmentDetails(RaygunClient.getApplicationContext())
  //     .setAppContext(RaygunClient.getAppContextIdentifier())
  //     .setVersion(RaygunClient.getVersion())
  //     .setNetworkInfo(RaygunClient.getApplicationContext())

  return raygunMessage;
}

Future<String?> _machineName() async {
  try {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.name;
    }
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.model;
    }
    if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      return info.name;
    }
    if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      return info.computerName;
    }
    if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      return info.computerName;
    }
    // otherwise, it may be web
    final info = await deviceInfo.webBrowserInfo;
    return info.browserName.toString();
  } catch (e) {
    RaygunLogger.e('Could not load device info: $e');
    return null;
  }
}
