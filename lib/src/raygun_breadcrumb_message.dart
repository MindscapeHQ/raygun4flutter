import 'package:json_annotation/json_annotation.dart';

part 'raygun_breadcrumb_message.g.dart';

@JsonSerializable()
class RaygunBreadcrumbMessage {
  RaygunBreadcrumbMessage({
    required this.message,
    this.category,
    this.level = RaygunBreadcrumbLevel.info,
    this.customData,
    this.className,
    this.methodName,
    this.lineNumber,
  });

  final String message;

  final String? category;

  final RaygunBreadcrumbLevel level;

  final Map<String, dynamic>? customData;

  /// Note: Not used in iOS
  final String? className;

  /// Note: Not used in iOS
  final String? methodName;

  /// Note: Not used in iOS
  final String? lineNumber;

  Map<String, dynamic> toJson() => _$RaygunBreadcrumbMessageToJson(this);
}

enum RaygunBreadcrumbLevel {
  @JsonValue(0) debug,
  @JsonValue(1) info,
  @JsonValue(2) warning,
  @JsonValue(3) error,
}
