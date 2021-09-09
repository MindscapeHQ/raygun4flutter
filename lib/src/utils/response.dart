class Response<T> {
  Response._();

  /// Create a Response containing a successful value
  factory Response.success(T value) = _SuccessResponse<T>;

  /// Create a Response containing an error
  factory Response.error(dynamic error) = _ErrorResponse<T>;

  bool get isSuccess => this is _SuccessResponse<T>;

  bool get isError => this is _ErrorResponse<T>;

  _SuccessResponse<T> get asSuccess => this as _SuccessResponse<T>;

  _ErrorResponse<T> get asError => this as _ErrorResponse<T>;
}

class _ErrorResponse<T> extends Response<T> {
  _ErrorResponse(this.error) : super._();

  final dynamic error;

  @override
  String toString() {
    return 'ErrorResponse{error: $error}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ErrorResponse &&
              runtimeType == other.runtimeType &&
              error == other.error;

  @override
  int get hashCode => error.hashCode;
}

class _SuccessResponse<T> extends Response<T> {
  _SuccessResponse(this.value) : super._();

  final T value;

  @override
  String toString() {
    return 'SuccessResponse{value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _SuccessResponse &&
              runtimeType == other.runtimeType &&
              value == other.value;

  @override
  int get hashCode => value.hashCode;
}
