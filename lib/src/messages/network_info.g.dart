// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) => NetworkInfo()
  ..iPAddress =
      (json['iPAddress'] as List<dynamic>).map((e) => e as String).toList()
  ..networkConnectivityState = json['networkConnectivityState'] as String?;

Map<String, dynamic> _$NetworkInfoToJson(NetworkInfo instance) =>
    <String, dynamic>{
      'iPAddress': instance.iPAddress,
      'networkConnectivityState': instance.networkConnectivityState,
    };
