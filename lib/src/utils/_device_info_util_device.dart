import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/messages/raygun_environment_message.dart';

Future<RaygunEnvironmentMessage> fromDeviceInfo() async {
  final environment = RaygunEnvironmentMessage();

  // Basic device information from Flutter's Platform
  environment.platform = Platform.operatingSystem;
  environment.oSVersion = Platform.operatingSystemVersion;
  environment.processorCount = Platform.numberOfProcessors;

  final window = PlatformDispatcher.instance.implicitView;
  environment.windowsBoundHeight = window?.physicalSize.height.toInt();
  environment.windowsBoundWidth = window?.physicalSize.width.toInt();
  environment.locale = PlatformDispatcher.instance.locale.toLanguageTag();
  environment.utcOffset = DateTime.now().timeZoneOffset.inHours.toDouble();

  try {
    // abi returns String in the format 'os_arch' like 'android_arm64'
    final abi = Abi.current().toString();
    environment.architecture = abi.split('_').last;
  } catch (e) {
    RaygunLogger.e('Failed to parse architecture. $e');
  }

  try {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      // Report iOS version number as SDK Version
      environment.osSDKVersion = info.systemVersion;
      environment.deviceName = info.name;
      environment.deviceCode = info.model;
    }
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      environment.brand = info.brand;
      environment.deviceName = info.device;

      final release = info.version.release;
      if (release.isNotEmpty) {
        environment.oSVersion = release;
      }
      // Report Android API level as OS SDK Version
      environment.osSDKVersion = info.version.sdkInt.toString();
    }
    if (Platform.isLinux) {
      final info = await deviceInfo.linuxInfo;
      environment.deviceName = info.name;
    }
    if (Platform.isMacOS) {
      final info = await deviceInfo.macOsInfo;
      environment.deviceName = info.computerName;
    }
    if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      environment.deviceName = info.computerName;
    }
  } catch (e) {
    RaygunLogger.e('Could not load device info: $e');
  }

  return environment;
}
