import 'package:json_annotation/json_annotation.dart';

part 'raygun_error_stack_trace_line_message.g.dart';

@JsonSerializable()
class RaygunErrorStackTraceLineMessage {
  int? lineNumber;
  String? className;
  String? fileName;
  String? methodName;

  RaygunErrorStackTraceLineMessage(
    this.lineNumber,
    this.className,
    this.fileName,
    this.methodName,
  );

  Map<String, dynamic> toJson() =>
      _$RaygunErrorStackTraceLineMessageToJson(this);

  factory RaygunErrorStackTraceLineMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunErrorStackTraceLineMessageFromJson(json);
}
