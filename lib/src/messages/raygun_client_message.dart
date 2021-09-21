import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'raygun_client_message.g.dart';

@JsonSerializable()
class RaygunClientMessage {
  String? version;
  final String clientUrl = 'https://github.com/MindscapeHQ/raygun4flutter';
  final String name = 'Raygun4Flutter';

  Future<void> loadVersionFromPackage() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
  }

  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);
}

