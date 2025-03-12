// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raygun_flutter_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaygunFlutterVersion _$RaygunFlutterVersionFromJson(
        Map<String, dynamic> json) =>
    RaygunFlutterVersion()
      ..version = json['version'] as String
      ..channel = json['channel'] as String
      ..gitUrl = json['gitUrl'] as String
      ..frameworkRevision = json['frameworkRevision'] as String
      ..engineRevision = json['engineRevision'] as String
      ..dartVersion = json['dartVersion'] as String;

Map<String, dynamic> _$RaygunFlutterVersionToJson(
        RaygunFlutterVersion instance) =>
    <String, dynamic>{
      'version': instance.version,
      'channel': instance.channel,
      'gitUrl': instance.gitUrl,
      'frameworkRevision': instance.frameworkRevision,
      'engineRevision': instance.engineRevision,
      'dartVersion': instance.dartVersion,
    };
