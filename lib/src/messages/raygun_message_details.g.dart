// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_message_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
