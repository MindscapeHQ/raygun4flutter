import 'package:json_annotation/json_annotation.dart';

part 'network_info.g.dart';

@JsonSerializable()
class NetworkInfo {
  NetworkInfo();

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);

  factory NetworkInfo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NetworkInfoFromJson(json);
}
