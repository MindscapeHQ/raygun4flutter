class RaygunUserInfo {
  /// Set the current user's info to be transmitted
  /// some parameters can be null if the data is not available or you do not
  /// wish to send it.
  RaygunUserInfo({
    required this.identifier,
    this.firstName,
    this.fullName,
    this.email,
  });

  /// The user's first name
  final String? firstName;

  /// The user's full name - if setting the first name you should set this too
  final String? fullName;

  /// User's email address
  final String? email;

  /// Unique identifier for this user.
  ///
  /// Set this to the internal identifier you use to look up users,
  /// or a correlation ID for anonymous users if you have one.
  /// It doesn't have to be unique, but we will treat any duplicated values as
  /// the same user. If you use their email address here, pass it in as the
  /// 'emailAddress' parameter too.
  final String identifier;

  Map<String, String?> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'firstName': firstName,
      'identifier': identifier,
    };
  }

  @override
  String toString() {
    return 'RaygunUserInfo{email: $email, fullName: $fullName, firstName: $firstName, identifier: $identifier}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RaygunUserInfo &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              fullName == other.fullName &&
              firstName == other.firstName &&
              identifier == other.identifier;

  @override
  int get hashCode =>
      email.hashCode ^
      fullName.hashCode ^
      firstName.hashCode ^
      identifier.hashCode;
}
