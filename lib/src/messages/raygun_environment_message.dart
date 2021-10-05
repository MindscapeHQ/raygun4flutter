import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';

part 'raygun_environment_message.g.dart';

@JsonSerializable()
class RaygunEnvironmentMessage {
  String? cpu;
  String? architecture;
  int? processorCount;
  String? oSVersion;
  String? osSDKVersion;
  int? windowsBoundWidth;
  int? windowsBoundHeight;
  String? currentOrientation;
  String? locale;
  int? totalPhysicalMemory;
  int? availablePhysicalMemory;
  int? totalVirtualMemory;
  int? availableVirtualMemory;
  int? diskSpaceFree;
  double? utcOffset;
  String? deviceName;
  String? brand;
  String? board;
  String? deviceCode;

  RaygunEnvironmentMessage();

  static Future<RaygunEnvironmentMessage> fromDeviceInfo() async {
    final environment = RaygunEnvironmentMessage();

    environment.windowsBoundHeight = window.physicalSize.height.toInt();
    environment.windowsBoundWidth = window.physicalSize.width.toInt();
    environment.locale = window.locale.toLanguageTag();
    environment.utcOffset = DateTime.now().timeZoneOffset.inHours.toDouble();

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if(kIsWeb) {
        final info = await deviceInfo.webBrowserInfo;
        environment.deviceName = info.userAgent;
        environment.brand = info.browserName.toString();
      } else {
        if (Platform.isIOS) {
          final info = await deviceInfo.iosInfo;
          environment.oSVersion = info.systemVersion;
          environment.deviceName = info.name;
          environment.deviceCode = info.model;
        }
        if (Platform.isAndroid) {
          final info = await deviceInfo.androidInfo;
          environment.brand = info.brand;
          environment.oSVersion = info.version.sdkInt?.toString();
          environment.deviceName = info.device;
        }
        if (Platform.isLinux) {
          final info = await deviceInfo.linuxInfo;
          environment.deviceName = info.name;
          environment.oSVersion = info.version;
        }
        if (Platform.isMacOS) {
          final info = await deviceInfo.macOsInfo;
          environment.deviceName = info.computerName;
          environment.oSVersion = info.osRelease;
        }
        if (Platform.isWindows) {
          final info = await deviceInfo.windowsInfo;
          environment.deviceName = info.computerName;
        }
      }
    } catch (e) {
      RaygunLogger.e('Could not load device info: $e');
    }

    return environment;
  }

  Map<String, dynamic> toJson() => _$RaygunEnvironmentMessageToJson(this);

  factory RaygunEnvironmentMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunEnvironmentMessageFromJson(json);
}
