// ignore_for_file: avoid_classes_with_only_static_members
import 'package:raygun4flutter/src/messages/raygun_app_context.dart';
import 'package:raygun4flutter/src/utils/device_info_util.dart';
import 'package:raygun4flutter/src/utils/machine_name_util.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:uuid/uuid.dart';

import '../raygun4flutter.dart';
import 'logging/raygun_logger.dart';
import 'messages/network_info.dart';
import 'messages/raygun_client_message.dart';
import 'messages/raygun_error_message.dart';
import 'messages/raygun_message.dart';
import 'services/crash_reporting_device.dart' if (dart.library.js) 'services/crash_reporting_web.dart';
import 'services/settings.dart';

class CrashReporting {
  static Future<void> send(String className, String reason, List<String>? tags, Map? customData, Trace? trace,
      {Map<String, String>? additionalHeaders}) async {
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

    final onBeforeSend = Raygun.onBeforeSend;
    final msgToSend = onBeforeSend != null ? onBeforeSend(msg) : msg;
    if (msgToSend == null) {
      RaygunLogger.d('Cancelled sending message.');
      return;
    }

    final response = await CrashReportingPostService(
      client: Settings.customHttpClient,
    ).postCrashReporting(
      Settings.apiKey ?? '',
      msgToSend.toJson(),
      additionalHeaders: additionalHeaders,
    );

    if (response.isSuccess) {
      Settings.breadcrumbs.clear();
    } else {
      RaygunLogger.e(
        'Failed to send Crash Report. Reason: ${response.asError.error}',
      );
    }
  }

  static Future<void> sendStored() async {
    await CrashReportingPostService(client: Settings.customHttpClient).sendAllStored(Settings.apiKey ?? '');
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

  // Set App context
  final raygunAppContext = RaygunAppContext();
  raygunAppContext.identifier = const Uuid().v4();
  raygunMessage.details.context = raygunAppContext;

  // Cannot load device info in tests
  if (!Settings.skipIfTest) {
    raygunMessage.details.request = await NetworkInfo.create();
    raygunMessage.details.machineName = await machineName();
    raygunMessage.details.environment = await fromDeviceInfo();
  }

  // .setEnvironmentDetails(RaygunClient.getApplicationContext())
  //     .setAppContext(RaygunClient.getAppContextIdentifier())
  //     .setVersion(RaygunClient.getVersion())

  return raygunMessage;
}
