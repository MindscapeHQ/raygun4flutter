import 'package:json_annotation/json_annotation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'raygun_error_stack_trace_line_message.dart';

part 'raygun_error_message.g.dart';

@JsonSerializable()
class RaygunErrorMessage {
  String message;
  String className;

  RaygunErrorMessage? innerError;

  List<RaygunErrorStackTraceLineMessage> stackTrace = [];

  RaygunErrorMessage(this.className, this.message);

  Map<String, dynamic> toJson() => _$RaygunErrorMessageToJson(this);

  void setStackTrace(Trace trace) {
    stackTrace = trace.frames
        .map(
          (frame) => RaygunErrorStackTraceLineMessage(
            frame.line,
            '', // class is included in member
            frame.uri.toString(),
            frame.member, // includes both class and method
            frame.column,
          ),
        )
        .toList();
  }

  factory RaygunErrorMessage.fromException(Exception exception) {
    return RaygunErrorMessage(
      exception.runtimeType.toString(),
      exception.toString(),
    );
  }

  factory RaygunErrorMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunErrorMessageFromJson(json);
}
