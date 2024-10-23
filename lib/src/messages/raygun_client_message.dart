import 'package:json_annotation/json_annotation.dart';
import 'package:raygun4flutter/src/services/settings.dart';

part 'raygun_client_message.g.dart';

@JsonSerializable()
class RaygunClientMessage {
  String? clientUrl = 'https://github.com/MindscapeHQ/raygun4flutter';
  String? name = 'Raygun4Flutter';
  String version = Settings.kVersion;

  RaygunClientMessage();

  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);

  factory RaygunClientMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunClientMessageFromJson(json);
}
