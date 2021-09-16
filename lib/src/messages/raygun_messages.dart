import 'package:json_annotation/json_annotation.dart';
import 'package:raygun4flutter/raygun4flutter.dart';

import '../raygun_user_info.dart';

part 'raygun_messages.g.dart';

@JsonSerializable()
class RaygunMessage {
  late String occurredOn;
  late RaygunMessageDetails details;

  RaygunMessage() {
    occurredOn = 'TODO DATE';
    details = RaygunMessageDetails();
  }

  Map<String, dynamic> toJson() => _$RaygunMessageToJson(this);
}

@JsonSerializable()
class RaygunMessageDetails {
  String? groupingKey;
  String? machineName;
  String version = 'Not supplied';
  RaygunErrorMessage? error;
  RaygunEnvironmentMessage? environment;
  RaygunClientMessage? client;
  List<String> tags = [];
  @JsonKey(name: 'userCustomData')
  Map customData = {};
  RaygunAppContext? context;
  RaygunUserInfo? user;
  NetworkInfo? request;
  List<RaygunBreadcrumbMessage> breadcrumbs = [];

  Map<String, dynamic> toJson() => _$RaygunMessageDetailsToJson(this);
}

@JsonSerializable()
class NetworkInfo {
  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}

@JsonSerializable()
class RaygunAppContext {
  Map<String, dynamic> toJson() => _$RaygunAppContextToJson(this);
}

@JsonSerializable()
class RaygunClientMessage {
  Map<String, dynamic> toJson() => _$RaygunClientMessageToJson(this);
}

@JsonSerializable()
class RaygunEnvironmentMessage {
  Map<String, dynamic> toJson() => _$RaygunEnvironmentMessageToJson(this);
}

@JsonSerializable()
class RaygunErrorMessage {
  Map<String, dynamic> toJson() => _$RaygunErrorMessageToJson(this);
}
