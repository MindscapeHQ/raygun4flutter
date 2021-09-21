// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunMessage _$RaygunMessageFromJson(Map<String, dynamic> json) =>
    RaygunMessage()
      ..occurredOn = json['occurredOn'] as String
      ..details = RaygunMessageDetails.fromJson(
          json['details'] as Map<String, dynamic>);

Map<String, dynamic> _$RaygunMessageToJson(RaygunMessage instance) =>
    <String, dynamic>{
      'occurredOn': instance.occurredOn,
      'details': instance.details,
    };
