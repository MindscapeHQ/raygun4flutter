import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:raygun4flutter/raygun4flutter.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:stack_trace/stack_trace.dart';

import '../raygun_user_info.dart';

part 'raygun_messages.g.dart';

@JsonSerializable()
class RaygunMessage {
  late String occurredOn;
  late RaygunMessageDetails details;

  RaygunMessage() {
    occurredOn = 'TODO DATE';
    details = RaygunMessageDetails();
  }

  Map<String, dynamic> toJson() => _$RaygunMessageToJson(this);
}

@JsonSerializable()
class RaygunMessageDetails {
  String? groupingKey;
  String? machineName;
  String version = 'Not supplied';
  RaygunErrorMessage? error;
  RaygunEnvironmentMessage? environment;
  RaygunClientMessage? client;
  List<String> tags = [];
  @JsonKey(name: 'userCustomData')
  Map customData = {};
  RaygunAppContext? context;
  RaygunUserInfo? user;
  NetworkInfo? request;
  List<RaygunBreadcrumbMessage> breadcrumbs = [];

  Map<String, dynamic> toJson() => _$RaygunMessageDetailsToJson(this);
}

@JsonSerializable()
class NetworkInfo {
  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}

@JsonSerializable()
class RaygunAppContext {
  Map<String, dynamic> toJson() => _$RaygunAppContextToJson(this);
}

@JsonSerializable()
class RaygunClientMessage {
  String? version;
  final String clientUrl = 'https://github.com/MindscapeHQ/raygun4flutter';
  final String name = 'Raygun4Flutter';

  Future<void> loadVersionFromPackage() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
  }

  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);
}

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

  static Future<RaygunEnvironmentMessage> fromDeviceInfo() async {
    final environment = RaygunEnvironmentMessage();

    environment.windowsBoundHeight = window.physicalSize.height.toInt();
    environment.windowsBoundWidth = window.physicalSize.width.toInt();
    environment.locale = window.locale.toLanguageTag();

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
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
      // otherwise, it may be web
      // final info = await deviceInfo.webBrowserInfo;

      // todo Load more device info
    } catch (e) {
      RaygunLogger.e('Could not load device info: $e');
    }

    return environment;
  }

  Map<String, dynamic> toJson() => _$RaygunEnvironmentMessageToJson(this);
}

@JsonSerializable()
class RaygunErrorMessage {
  final String message;
  final String className;

  // todo: innerError is null at the moment
  RaygunErrorMessage? innerError;

  List<RaygunErrorStackTraceLineMessage> stackTrace = [];

  RaygunErrorMessage(this.className, this.message);

  Map<String, dynamic> toJson() => _$RaygunErrorMessageToJson(this);

  void setStackTrace(Trace trace) {
    stackTrace = trace.frames
        .map((frame) => RaygunErrorStackTraceLineMessage(
              frame.line,
              '', // class is included in member
              frame.uri.toString(),
              frame.member, // includes both class and method
            ))
        .toList();
  }
}

@JsonSerializable()
class RaygunErrorStackTraceLineMessage {
  final int? lineNumber;
  final String? className;
  final String? fileName;
  final String? methodName;

  RaygunErrorStackTraceLineMessage(
    this.lineNumber,
    this.className,
    this.fileName,
    this.methodName,
  );

  Map<String, dynamic> toJson() =>
      _$RaygunErrorStackTraceLineMessageToJson(this);
}
