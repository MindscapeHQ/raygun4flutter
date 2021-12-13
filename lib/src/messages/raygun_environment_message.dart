import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

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

  Map<String, dynamic> toJson() => _$RaygunEnvironmentMessageToJson(this);

  factory RaygunEnvironmentMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunEnvironmentMessageFromJson(json);
}
