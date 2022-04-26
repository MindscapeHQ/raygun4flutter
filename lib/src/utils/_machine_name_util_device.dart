import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';

Future<String?> machineName() async {
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
  } catch (e) {
    RaygunLogger.e('Could not load device info: $e');
    return null;
  }
}
