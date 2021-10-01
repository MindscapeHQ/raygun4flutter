import 'package:json_annotation/json_annotation.dart';

import 'raygun_message_details.dart';

part 'raygun_message.g.dart';

@JsonSerializable()
class RaygunMessage {
  late String occurredOn;
  late RaygunMessageDetails details;

  RaygunMessage() {
    occurredOn = DateTime.now().toIso8601String();
    details = RaygunMessageDetails();
  }

  Map<String, dynamic> toJson() => _$RaygunMessageToJson(this);

  factory RaygunMessage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunMessageFromJson(json);
}
