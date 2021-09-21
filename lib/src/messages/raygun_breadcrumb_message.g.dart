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
          _$enumDecodeNullable(_$RaygunBreadcrumbLevelEnumMap, json['level']) ??
              RaygunBreadcrumbLevel.info,
      customData: json['customData'] as Map<String, dynamic>?,
      className: json['className'] as String?,
      methodName: json['methodName'] as String?,
      lineNumber: json['lineNumber'] as String?,
    );

Map<String, dynamic> _$RaygunBreadcrumbMessageToJson(
        RaygunBreadcrumbMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'category': instance.category,
      'level': _$RaygunBreadcrumbLevelEnumMap[instance.level],
      'customData': instance.customData,
      'className': instance.className,
      'methodName': instance.methodName,
      'lineNumber': instance.lineNumber,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$RaygunBreadcrumbLevelEnumMap = {
  RaygunBreadcrumbLevel.debug: 0,
  RaygunBreadcrumbLevel.info: 1,
  RaygunBreadcrumbLevel.warning: 2,
  RaygunBreadcrumbLevel.error: 3,
};
