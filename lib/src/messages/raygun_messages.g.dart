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
    RaygunClientMessage();

Map<String, dynamic> _$RaygunClientMessageToJson(
        RaygunClientMessage instance) =>
    <String, dynamic>{};

RaygunEnvironmentMessage _$RaygunEnvironmentMessageFromJson(
        Map<String, dynamic> json) =>
    RaygunEnvironmentMessage();

Map<String, dynamic> _$RaygunEnvironmentMessageToJson(
        RaygunEnvironmentMessage instance) =>
    <String, dynamic>{};

RaygunErrorMessage _$RaygunErrorMessageFromJson(Map<String, dynamic> json) =>
    RaygunErrorMessage();

Map<String, dynamic> _$RaygunErrorMessageToJson(RaygunErrorMessage instance) =>
    <String, dynamic>{};
