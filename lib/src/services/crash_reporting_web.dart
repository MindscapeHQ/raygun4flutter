import 'package:raygun4flutter/src/services/crash_reporting_post_service.dart';

class CrashReportingPostService extends CrashReportingPostServiceBase {
  CrashReportingPostService({super.client});

  @override
  Future<void> store(dynamic jsonPayload) async {
    // Do nothing on web
  }

  @override
  Future<void> sendAllStored(String apiKey) async {
    // Do nothing on web
  }
}
