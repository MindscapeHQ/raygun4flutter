import 'package:http/http.dart' as http;
import 'package:raygun4flutter/src/services/crash_reporting_post_service.dart';

class CrashReportingPostService extends CrashReportingPostServiceBase {
  CrashReportingPostService({http.Client? client}) : super(client: client);

  @override
  Future<void> store(dynamic jsonPayload) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendAllStored(String apiKey) async {
    throw UnimplementedError();
  }
}
