import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:network_info_plus/network_info_plus.dart' as plus;

part 'network_info.g.dart';

@JsonSerializable()
class NetworkInfo {
  NetworkInfo();

  List<String> iPAddress = [];
  String? networkConnectivityState;

  static Future<NetworkInfo> create() async {
    final info = NetworkInfo();
    info.iPAddress.addAll(await getIps());
    info.networkConnectivityState = await getConnectivityState();
    return info;
  }

  static Future<List<String>> getIps() async {
    if (kIsWeb) {
      // Cannot use getWifiIp on Web
      return [];
    }
    final info = plus.NetworkInfo();
    final ip4 = await info.getWifiIP();
    final ip6 = await info.getWifiIPv6();
    return [
      if (ip4 != null) ip4,
      if (ip6 != null) ip6,
    ];
  }

  static Future<String> getConnectivityState() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.mobile:
        return 'Mobile';
      case ConnectivityResult.none:
        return 'Not Connected';
    }
  }

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);

  factory NetworkInfo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NetworkInfoFromJson(json);
}
