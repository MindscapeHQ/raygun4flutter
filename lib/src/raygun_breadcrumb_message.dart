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

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'category': category,
      'level': level.index,
      'customData': customData,
      'className': className,
      'methodName': methodName,
      'lineNumber': lineNumber,
    };
  }
}

enum RaygunBreadcrumbLevel {
  debug,
  info,
  warning,
  error,
}
