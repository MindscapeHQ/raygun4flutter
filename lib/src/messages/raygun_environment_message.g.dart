// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_environment_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunEnvironmentMessage _$RaygunEnvironmentMessageFromJson(
        Map<String, dynamic> json) =>
    RaygunEnvironmentMessage()
      ..cpu = json['cpu'] as String?
      ..architecture = json['architecture'] as String?
      ..processorCount = json['processorCount'] as int?
      ..oSVersion = json['oSVersion'] as String?
      ..osSDKVersion = json['osSDKVersion'] as String?
      ..windowsBoundWidth = json['windowsBoundWidth'] as int?
      ..windowsBoundHeight = json['windowsBoundHeight'] as int?
      ..currentOrientation = json['currentOrientation'] as String?
      ..locale = json['locale'] as String?
      ..totalPhysicalMemory = json['totalPhysicalMemory'] as int?
      ..availablePhysicalMemory = json['availablePhysicalMemory'] as int?
      ..totalVirtualMemory = json['totalVirtualMemory'] as int?
      ..availableVirtualMemory = json['availableVirtualMemory'] as int?
      ..diskSpaceFree = json['diskSpaceFree'] as int?
      ..utcOffset = (json['utcOffset'] as num?)?.toDouble()
      ..deviceName = json['deviceName'] as String?
      ..brand = json['brand'] as String?
      ..board = json['board'] as String?
      ..deviceCode = json['deviceCode'] as String?;

Map<String, dynamic> _$RaygunEnvironmentMessageToJson(
        RaygunEnvironmentMessage instance) =>
    <String, dynamic>{
      'cpu': instance.cpu,
      'architecture': instance.architecture,
      'processorCount': instance.processorCount,
      'oSVersion': instance.oSVersion,
      'osSDKVersion': instance.osSDKVersion,
      'windowsBoundWidth': instance.windowsBoundWidth,
      'windowsBoundHeight': instance.windowsBoundHeight,
      'currentOrientation': instance.currentOrientation,
      'locale': instance.locale,
      'totalPhysicalMemory': instance.totalPhysicalMemory,
      'availablePhysicalMemory': instance.availablePhysicalMemory,
      'totalVirtualMemory': instance.totalVirtualMemory,
      'availableVirtualMemory': instance.availableVirtualMemory,
      'diskSpaceFree': instance.diskSpaceFree,
      'utcOffset': instance.utcOffset,
      'deviceName': instance.deviceName,
      'brand': instance.brand,
      'board': instance.board,
      'deviceCode': instance.deviceCode,
    };
