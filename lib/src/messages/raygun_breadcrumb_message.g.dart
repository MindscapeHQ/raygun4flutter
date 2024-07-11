// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_breadcrumb_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunBreadcrumbMessage _$RaygunBreadcrumbMessageFromJson(
        Map<String, dynamic> json) =>
    RaygunBreadcrumbMessage(
      message: json['message'] as String,
      category: json['category'] as String?,
      level:
          $enumDecodeNullable(_$RaygunBreadcrumbLevelEnumMap, json['level']) ??
              RaygunBreadcrumbLevel.info,
      customData: json['customData'] as Map<String, dynamic>?,
      className: json['className'] as String?,
      methodName: json['methodName'] as String?,
      lineNumber: json['lineNumber'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RaygunBreadcrumbMessageToJson(
        RaygunBreadcrumbMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'category': instance.category,
      'level': _$RaygunBreadcrumbLevelEnumMap[instance.level]!,
      'customData': instance.customData,
      'className': instance.className,
      'methodName': instance.methodName,
      'lineNumber': instance.lineNumber,
      'timestamp': instance.timestamp,
    };

const _$RaygunBreadcrumbLevelEnumMap = {
  RaygunBreadcrumbLevel.debug: 0,
  RaygunBreadcrumbLevel.info: 1,
  RaygunBreadcrumbLevel.warning: 2,
  RaygunBreadcrumbLevel.error: 3,
};
