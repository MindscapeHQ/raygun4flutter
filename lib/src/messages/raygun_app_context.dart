import 'package:json_annotation/json_annotation.dart';

part 'raygun_app_context.g.dart';

@JsonSerializable()
class RaygunAppContext {

  RaygunAppContext();

  Map<String, dynamic> toJson() => _$RaygunAppContextToJson(this);

  factory RaygunAppContext.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$RaygunAppContextFromJson(json);
}
