// Use web implementation for both web and wasm compilation targets
export '_device_info_util_web.dart'
    if (dart.library.io) '_device_info_util_device.dart';
