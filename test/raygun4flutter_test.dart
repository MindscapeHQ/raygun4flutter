import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raygun4flutter/raygun4flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('raygun4flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Raygun4flutter.platformVersion, '42');
  });
}
