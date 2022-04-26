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
    // optional, users can provide custom timestamp
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  String message;

  String? category;

  RaygunBreadcrumbLevel level;

  Map<String, dynamic>? customData;

  /// Note: Not used in iOS
  String? className;

  /// Note: Not used in iOS
  String? methodName;

  /// Note: Not used in iOS
  String? lineNumber;

  // Milliseconds since the Unix Epoch (required)
  int timestamp;

  Map<String, dynamic> toJson() => _$RaygunBreadcrumbMessageToJson(this);

  factory RaygunBreadcrumbMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunBreadcrumbMessageFromJson(json);
}

enum RaygunBreadcrumbLevel {
  @JsonValue(0)
  debug,
  @JsonValue(1)
  info,
  @JsonValue(2)
  warning,
  @JsonValue(3)
  error,
}
