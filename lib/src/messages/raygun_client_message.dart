import 'package:json_annotation/json_annotation.dart';

part 'raygun_client_message.g.dart';

@JsonSerializable()
class RaygunClientMessage {
  String? clientUrl = 'https://github.com/MindscapeHQ/raygun4flutter';
  String? name = 'Raygun4Flutter';

  RaygunClientMessage();

  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);

  factory RaygunClientMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunClientMessageFromJson(json);
}
