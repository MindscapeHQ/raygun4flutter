import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:network_info_plus/network_info_plus.dart' as plus;
import 'package:raygun4flutter/src/services/settings.dart';

part 'network_info.g.dart';

@JsonSerializable()
class NetworkInfo {
  NetworkInfo();

  List<String> iPAddress = [];
  String? networkConnectivityState;

  static Future<NetworkInfo> create() async {
    final info = NetworkInfo();
    info.iPAddress.addAll(await Settings.getIps());
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
    return [
      if (ip4 != null) ip4,
    ];
  }

  static Future<String> getConnectivityState() async {
    final connectivityResult = await Settings.getConnectivityState();
    return connectivityResult.map((e) => e._toName()).join(', ');
  }

  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);

  factory NetworkInfo.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$NetworkInfoFromJson(json);
}

extension _ConnectivityResult on ConnectivityResult {
  String _toName() {
    return switch (this) {
      ConnectivityResult.wifi => 'WiFi',
      ConnectivityResult.ethernet => 'Ethernet',
      ConnectivityResult.mobile => 'Mobile',
      ConnectivityResult.none => 'Not Connected',
      ConnectivityResult.bluetooth => 'Bluetooth',
      ConnectivityResult.vpn => 'VPN',
      ConnectivityResult.other => 'Other'
    };
  }
}
