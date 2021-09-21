import 'package:json_annotation/json_annotation.dart';

import 'network_info.dart';
import 'raygun_app_context.dart';
import 'raygun_breadcrumb_message.dart';
import 'raygun_client_message.dart';
import 'raygun_environment_message.dart';
import 'raygun_error_message.dart';
import 'raygun_user_info.dart';

part 'raygun_message_details.g.dart';

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

  RaygunMessageDetails();

  Map<String, dynamic> toJson() => _$RaygunMessageDetailsToJson(this);

  factory RaygunMessageDetails.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RaygunMessageDetailsFromJson(json);
}
