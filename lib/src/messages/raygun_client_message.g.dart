// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_client_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunClientMessage _$RaygunClientMessageFromJson(Map<String, dynamic> json) =>
    RaygunClientMessage()
      ..clientUrl = json['clientUrl'] as String?
      ..name = json['name'] as String?;

Map<String, dynamic> _$RaygunClientMessageToJson(
        RaygunClientMessage instance) =>
    <String, dynamic>{
      'clientUrl': instance.clientUrl,
      'name': instance.name,
    };
