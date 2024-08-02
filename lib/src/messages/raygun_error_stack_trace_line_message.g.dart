// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_error_stack_trace_line_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunErrorStackTraceLineMessage _$RaygunErrorStackTraceLineMessageFromJson(
        Map<String, dynamic> json) =>
    RaygunErrorStackTraceLineMessage(
      (json['lineNumber'] as num?)?.toInt(),
      json['className'] as String?,
      json['fileName'] as String?,
      json['methodName'] as String?,
      (json['columnNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RaygunErrorStackTraceLineMessageToJson(
        RaygunErrorStackTraceLineMessage instance) =>
    <String, dynamic>{
      'lineNumber': instance.lineNumber,
      'className': instance.className,
      'fileName': instance.fileName,
      'methodName': instance.methodName,
      'columnNumber': instance.columnNumber,
    };
