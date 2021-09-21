// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_error_stack_trace_line_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
