import 'package:json_annotation/json_annotation.dart';
import 'package:raygun4flutter/src/services/settings.dart';

import '../logging/raygun_logger.dart';

part 'raygun_user_info.g.dart';

@JsonSerializable()
class RaygunUserInfo {
  /// Set the current user's info to be transmitted
  /// some parameters can be null if the data is not available or you do not
  /// wish to send it.
  RaygunUserInfo({
    String? identifier,
    this.firstName,
    this.fullName,
    this.email,
  }) {
    if (identifier == null || identifier.isEmpty) {
      Settings.deviceUuid().then((value) {
        _identifier = value;
        RaygunLogger.i("Assigned ID to anonymous user: $_identifier");
      });
      isAnonymous = true;
      RaygunLogger.i("Created anonymous user");
    } else {
      _identifier = identifier;
      isAnonymous = false;
      RaygunLogger.i("Created user with id: $identifier");
    }
  }

  /// due to limitations on the Json library we need to expose this field
  /// but users should not be modifying it
  late bool isAnonymous;

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
  String? _identifier;

  String? get identifier => _identifier;

  Map<String, dynamic> toJson() => _$RaygunUserInfoToJson(this);

  factory RaygunUserInfo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunUserInfoFromJson(json);
}
