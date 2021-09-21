import 'package:json_annotation/json_annotation.dart';

part 'raygun_app_context.g.dart';

@JsonSerializable()
class RaygunAppContext {
  Map<String, dynamic> toJson() => _$RaygunAppContextToJson(this);
}
