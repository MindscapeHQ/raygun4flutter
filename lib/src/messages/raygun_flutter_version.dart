import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'raygun_flutter_version.g.dart';

@JsonSerializable()
class RaygunFlutterVersion {
  String? version = FlutterVersion.version;
  String? channel = FlutterVersion.channel;
  String? gitUrl = FlutterVersion.gitUrl;
  String? frameworkRevision = FlutterVersion.frameworkRevision;
  String? engineRevision = FlutterVersion.engineRevision;
  String? dartVersion = FlutterVersion.dartVersion;

  RaygunFlutterVersion();

  Map<String, dynamic> toJson() => _$RaygunFlutterVersionToJson(this);

  factory RaygunFlutterVersion.fromJson(Map<String, dynamic> json) =>
      _$RaygunFlutterVersionFromJson(json);
}
