import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/messages/raygun_environment_message.dart';

Future<RaygunEnvironmentMessage> fromDeviceInfo() async {
  final environment = RaygunEnvironmentMessage();

  environment.windowsBoundHeight = window.physicalSize.height.toInt();
  environment.windowsBoundWidth = window.physicalSize.width.toInt();
  environment.locale = window.locale.toLanguageTag();
  environment.utcOffset = DateTime.now().timeZoneOffset.inHours.toDouble();

  try {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.webBrowserInfo;
    environment.deviceName = info.userAgent;
    environment.brand = info.browserName.toString();
  } catch (e) {
    RaygunLogger.e('Could not load device info: $e');
  }

  return environment;
}
