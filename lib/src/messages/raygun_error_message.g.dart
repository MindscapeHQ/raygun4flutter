// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_error_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
