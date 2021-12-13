import 'package:device_info_plus/device_info_plus.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';

Future<String?> machineName() async {
  try {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.webBrowserInfo;
    return info.browserName.toString();
  } catch (e) {
    RaygunLogger.e('Could not load device info: $e');
    return null;
  }
}
