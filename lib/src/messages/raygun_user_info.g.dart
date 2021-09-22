// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunUserInfo _$RaygunUserInfoFromJson(Map<String, dynamic> json) =>
    RaygunUserInfo(
      identifier: json['identifier'] as String?,
      firstName: json['firstName'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
    )..isAnonymous = json['isAnonymous'] as bool;

Map<String, dynamic> _$RaygunUserInfoToJson(RaygunUserInfo instance) =>
    <String, dynamic>{
      'isAnonymous': instance.isAnonymous,
      'firstName': instance.firstName,
      'fullName': instance.fullName,
      'email': instance.email,
      'identifier': instance.identifier,
    };
