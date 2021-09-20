// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunMessage _$RaygunMessageFromJson(Map<String, dynamic> json) =>
    RaygunMessage()
      ..occurredOn = json['occurredOn'] as String
      ..details = RaygunMessageDetails.fromJson(
          json['details'] as Map<String, dynamic>);

Map<String, dynamic> _$RaygunMessageToJson(RaygunMessage instance) =>
    <String, dynamic>{
      'occurredOn': instance.occurredOn,
      'details': instance.details,
    };

RaygunMessageDetails _$RaygunMessageDetailsFromJson(
        Map<String, dynamic> json) =>
    RaygunMessageDetails()
      ..groupingKey = json['groupingKey'] as String?
      ..machineName = json['machineName'] as String?
      ..version = json['version'] as String
      ..error = json['error'] == null
          ? null
          : RaygunErrorMessage.fromJson(json['error'] as Map<String, dynamic>)
      ..environment = json['environment'] == null
          ? null
          : RaygunEnvironmentMessage.fromJson(
              json['environment'] as Map<String, dynamic>)
      ..client = json['client'] == null
          ? null
          : RaygunClientMessage.fromJson(json['client'] as Map<String, dynamic>)
      ..tags = (json['tags'] as List<dynamic>).map((e) => e as String).toList()
      ..customData = json['userCustomData'] as Map<String, dynamic>
      ..context = json['context'] == null
          ? null
          : RaygunAppContext.fromJson(json['context'] as Map<String, dynamic>)
      ..user = json['user'] == null
          ? null
          : RaygunUserInfo.fromJson(json['user'] as Map<String, dynamic>)
      ..request = json['request'] == null
          ? null
          : NetworkInfo.fromJson(json['request'] as Map<String, dynamic>)
      ..breadcrumbs = (json['breadcrumbs'] as List<dynamic>)
          .map((e) =>
              RaygunBreadcrumbMessage.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RaygunMessageDetailsToJson(
        RaygunMessageDetails instance) =>
    <String, dynamic>{
      'groupingKey': instance.groupingKey,
      'machineName': instance.machineName,
      'version': instance.version,
      'error': instance.error,
      'environment': instance.environment,
      'client': instance.client,
      'tags': instance.tags,
      'userCustomData': instance.customData,
      'context': instance.context,
      'user': instance.user,
      'request': instance.request,
      'breadcrumbs': instance.breadcrumbs,
    };

NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) => NetworkInfo();

Map<String, dynamic> _$NetworkInfoToJson(NetworkInfo instance) =>
    <String, dynamic>{};

RaygunAppContext _$RaygunAppContextFromJson(Map<String, dynamic> json) =>
    RaygunAppContext();

Map<String, dynamic> _$RaygunAppContextToJson(RaygunAppContext instance) =>
    <String, dynamic>{};

RaygunClientMessage _$RaygunClientMessageFromJson(Map<String, dynamic> json) =>
    RaygunClientMessage()..version = json['version'] as String?;

Map<String, dynamic> _$RaygunClientMessageToJson(
        RaygunClientMessage instance) =>
    <String, dynamic>{
      'version': instance.version,
    };

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

RaygunErrorMessage _$RaygunErrorMessageFromJson(Map<String, dynamic> json) =>
    RaygunErrorMessage(
      json['className'] as String,
      json['message'] as String,
    )
      ..innerError = json['innerError'] == null
          ? null
          : RaygunErrorMessage.fromJson(
              json['innerError'] as Map<String, dynamic>)
      ..stackTrace = (json['stackTrace'] as List<dynamic>)
          .map((e) => RaygunErrorStackTraceLineMessage.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RaygunErrorMessageToJson(RaygunErrorMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'className': instance.className,
      'innerError': instance.innerError,
      'stackTrace': instance.stackTrace,
    };

RaygunErrorStackTraceLineMessage _$RaygunErrorStackTraceLineMessageFromJson(
        Map<String, dynamic> json) =>
    RaygunErrorStackTraceLineMessage(
      json['lineNumber'] as int?,
      json['className'] as String?,
      json['fileName'] as String?,
      json['methodName'] as String?,
    );

Map<String, dynamic> _$RaygunErrorStackTraceLineMessageToJson(
        RaygunErrorStackTraceLineMessage instance) =>
    <String, dynamic>{
      'lineNumber': instance.lineNumber,
      'className': instance.className,
      'fileName': instance.fileName,
      'methodName': instance.methodName,
    };
