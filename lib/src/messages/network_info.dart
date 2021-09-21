import 'package:json_annotation/json_annotation.dart';

part 'network_info.g.dart';

@JsonSerializable()
class NetworkInfo {
  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}
