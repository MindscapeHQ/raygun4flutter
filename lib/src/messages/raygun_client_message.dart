import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'raygun_client_message.g.dart';

@JsonSerializable()
class RaygunClientMessage {
  // todo: how to load the Raygun version?
  String? version;
  final String clientUrl = 'https://github.com/MindscapeHQ/raygun4flutter';
  final String name = 'Raygun4Flutter';

  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);
}

