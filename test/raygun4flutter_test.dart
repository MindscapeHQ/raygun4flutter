// ignore_for_file: require_trailing_commas, avoid_print, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:raygun4flutter/raygun4flutter.dart';
import 'package:raygun4flutter/src/logging/raygun_logger.dart';
import 'package:raygun4flutter/src/messages/raygun_error_message.dart';
import 'package:raygun4flutter/src/messages/raygun_message.dart';
import 'package:raygun4flutter/src/services/crash_reporting_device.dart';
import 'package:raygun4flutter/src/services/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dynamic capturedBody;
  Uri? capturedUrl;
  int callCount = 0;

  setUp(() async {
    RaygunLogger.testMode = true;
    capturedBody = null;
    capturedUrl = null;
    callCount = 0;
    Settings.skipIfTest = true;
    Settings.tags = null;
    Settings.customData = null;
    Settings.breadcrumbs = [];
    Settings.crashReportingEndpoint = Settings.kDefaultCrashReportingEndpoint;
    Settings.customHttpClient = MockClient((request) async {
      capturedBody = jsonDecode(request.body);
      capturedUrl = request.url;
      callCount += 1;
      print(capturedBody);
      return http.Response('', 204);
    });
    Settings.getConnectivityState = () async {
      return [ConnectivityResult.wifi];
    };
    Settings.getIps = () async {
      return [];
    };
    Settings.listenToConnectivityChanges = false;
    Settings.cacheDirectory = Directory('.');

    await Raygun.init(apiKey: 'KEY', version: '1.0.0');
  });

  test('init', () {
    expect(Settings.apiKey, 'KEY');
  });

  test('init with version', () {
    Raygun.init(apiKey: 'KEY', version: 'x.y.z');
    expect(Settings.apiKey, 'KEY');
    expect(Settings.version, 'x.y.z');
  });

  test('sendException', () async {
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody['details']['error']['message'], 'Exception: MESSAGE');
    expect(capturedBody['details']['tags'], []);
    expect(capturedBody['details']['userCustomData'], {});
  });

  test('should fill client data', () async {
    await Raygun.sendException(error: Exception('MESSAGE'));
    // Client URL and name never change
    expect(
      capturedBody['details']['client']['clientUrl'],
      'https://github.com/MindscapeHQ/raygun4flutter',
    );
    expect(capturedBody['details']['client']['name'], 'Raygun4Flutter');

    // Version changes on each release
    expect(capturedBody['details']['client']['version'], isNotEmpty);
  });

  test('sendException with tags', () async {
    await Raygun.sendException(
      error: Exception('MESSAGE'),
      tags: ['tag1', 'tag2'],
    );
    expect(capturedBody['details']['error']['message'], 'Exception: MESSAGE');
    expect(capturedBody['details']['tags'], ['tag1', 'tag2']);
    expect(capturedBody['details']['userCustomData'], {});
  });

  test('sendException with custom data', () async {
    await Raygun.sendException(
      error: Exception('MESSAGE'),
      customData: {'custom': 42},
    );
    expect(capturedBody['details']['error']['message'], 'Exception: MESSAGE');
    expect(capturedBody['details']['tags'], []);
    expect(capturedBody['details']['userCustomData'], {'custom': 42});
  });

  test('sendCustom with innerError', () async {
    await Raygun.sendCustom(
      className: 'CLASSNAME',
      reason: 'REASON',
      innerError: Exception('MESSAGE'),
    );

    // main error should be custom className and reason
    expect(capturedBody['details']['error']['message'], 'REASON');
    expect(capturedBody['details']['error']['className'], 'CLASSNAME');

    // innerError should be exception message and type
    expect(
      capturedBody['details']['error']['innerError']['message'],
      'Exception: MESSAGE',
    );
    expect(
      capturedBody['details']['error']['innerError']['className'],
      '_Exception',
    );
  });

  test('Breadcrumb', () async {
    Raygun.recordBreadcrumb('BREADCRUMB');
    final breadcrumbMessage = RaygunBreadcrumbMessage(message: 'BREADCRUMB');
    expect(
      Settings.breadcrumbs.single.toJson()['message'],
      breadcrumbMessage.toJson()['message'],
    );
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(
      capturedBody['details']['breadcrumbs'].single['message'],
      breadcrumbMessage.toJson()['message'],
    );
    // should clear after send
    expect(Settings.breadcrumbs, isEmpty);
  });

  test('Breadcrumb level is serialised as string', () async {
    Raygun.recordBreadcrumbObject(
      RaygunBreadcrumbMessage(
        message: 'debug msg',
        level: RaygunBreadcrumbLevel.debug,
      ),
    );
    Raygun.recordBreadcrumbObject(RaygunBreadcrumbMessage(message: 'info msg'));
    Raygun.recordBreadcrumbObject(
      RaygunBreadcrumbMessage(
        message: 'warning msg',
        level: RaygunBreadcrumbLevel.warning,
      ),
    );
    Raygun.recordBreadcrumbObject(
      RaygunBreadcrumbMessage(
        message: 'error msg',
        level: RaygunBreadcrumbLevel.error,
      ),
    );
    await Raygun.sendException(error: Exception('MESSAGE'));
    final breadcrumbs = capturedBody['details']['breadcrumbs'] as List;
    // recordBreadcrumbObject inserts at index 0, so order is reversed
    expect(breadcrumbs[3]['level'], 'debug');
    expect(breadcrumbs[2]['level'], 'info');
    expect(breadcrumbs[1]['level'], 'warning');
    expect(breadcrumbs[0]['level'], 'error');
  });

  test('UserId with ID', () async {
    Raygun.setUserId('ID');
    final raygunUserInfo = RaygunUserInfo(identifier: 'ID');
    expect(Settings.userInfo.toJson(), raygunUserInfo.toJson());
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody['details']['user'], raygunUserInfo.toJson());
  });

  test('UserId to null', () async {
    Raygun.setUserId(null);
    final raygunUserInfo = RaygunUserInfo();
    expect(Settings.userInfo.toJson(), raygunUserInfo.toJson());
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody['details']['user'], raygunUserInfo.toJson());
  });

  test('call to onBeforeSend before sending', () async {
    bool called = false;
    Raygun.onBeforeSend = (payload) {
      called = true;
      payload.details.error!.message = 'NEW MESSAGE';
      return payload;
    };
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(called, isTrue);
    expect(capturedBody['details']['error']['message'], 'NEW MESSAGE');
    Raygun.onBeforeSend = null;
  });

  test('cancel sending message with onBeforeSend', () async {
    Raygun.onBeforeSend = (payload) {
      return null;
    };
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody, isNull);
    Raygun.onBeforeSend = null;
  });

  test('store crash reports', () async {
    await _deleteOldFiles();

    final service = CrashReportingPostService();
    final raygunMessage = RaygunMessage();

    // create three files, same timestamp but different uuid
    await service.store(raygunMessage.toJson());
    await service.store(raygunMessage.toJson());
    await service.store(raygunMessage.toJson());
    final files = await CrashReportingPostService.getCachedFiles();
    for (final file in files) {
      print('Found file: ${file.path}');
    }

    // three files should have been created
    expect(files.length, 3);

    // check files are read correctly
    for (final file in files) {
      final content = await File(file.path).readAsString();
      expect(content, jsonEncode(raygunMessage.toJson()));
    }

    // delete test files
    for (final file in files) {
      print('Deleting test file: ${file.path}');
      await file.delete();
    }
  });

  test('delete stored files on error', () async {
    await _deleteOldFiles();

    final cacheDir = Settings.cacheDirectory!;
    final file = File('${cacheDir.path}/error.raygun4');
    await file.writeAsString('asdasdasf{}{}{');

    var files = await CrashReportingPostService.getCachedFiles();
    expect(files.length, 1);

    // should fail with an error
    final service = CrashReportingPostService();
    await service.sendAllStored('KEY');

    // should delete all cached files
    files = await CrashReportingPostService.getCachedFiles();
    expect(files.length, 0);
  });

  test('global tags merge with per-call tags', () async {
    await Raygun.setTags(['global1', 'global2']);
    await Raygun.sendException(error: Exception('MESSAGE'), tags: ['call1']);
    expect(capturedBody['details']['tags'], ['call1', 'global1', 'global2']);
  });

  test('setTags(null) clears global tags', () async {
    await Raygun.setTags(['global']);
    await Raygun.setTags(null);
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody['details']['tags'], []);
  });

  test('global customData merges with per-call customData', () async {
    await Raygun.setCustomData({'global': 'value', 'shared': 'global'});
    await Raygun.sendException(
      error: Exception('MESSAGE'),
      customData: {'call': 1, 'shared': 'call'},
    );
    expect(capturedBody['details']['userCustomData'], {
      'call': 1,
      // global value overwrites per-call when keys collide (addAll semantics)
      'shared': 'global',
      'global': 'value',
    });
  });

  test('setUser with full RaygunUserInfo', () async {
    final user = RaygunUserInfo(
      identifier: 'user-42',
      email: 'jane@example.com',
      firstName: 'Jane',
      fullName: 'Jane Doe',
    );
    await Raygun.setUser(user);
    await Raygun.sendException(error: Exception('MESSAGE'));
    final sentUser = capturedBody['details']['user'] as Map<String, dynamic>;
    expect(sentUser['identifier'], 'user-42');
    expect(sentUser['email'], 'jane@example.com');
    expect(sentUser['firstName'], 'Jane');
    expect(sentUser['fullName'], 'Jane Doe');
    expect(sentUser['isAnonymous'], false);
  });

  test('setUser(null) resets to anonymous user', () async {
    await Raygun.setUser(
      RaygunUserInfo(identifier: 'someone', email: 'a@b.com'),
    );
    await Raygun.setUser(null);
    expect(Settings.userInfo.isAnonymous, isTrue);
    expect(Settings.userInfo.email, isNull);
  });

  test('setCustomCrashReportingEndpoint changes request URL', () async {
    await Raygun.setCustomCrashReportingEndpoint(
      'https://custom.example.com/entries',
    );
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedUrl.toString(), 'https://custom.example.com/entries');
  });

  test('setCustomCrashReportingEndpoint(null) restores default', () async {
    await Raygun.setCustomCrashReportingEndpoint(
      'https://custom.example.com/entries',
    );
    await Raygun.setCustomCrashReportingEndpoint(null);
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedUrl.toString(), Settings.kDefaultCrashReportingEndpoint);
  });

  test('clearBreadcrumbs empties the breadcrumb buffer', () async {
    Raygun.recordBreadcrumb('a');
    Raygun.recordBreadcrumb('b');
    expect(Settings.breadcrumbs.length, 2);
    await Raygun.clearBreadcrumbs();
    expect(Settings.breadcrumbs, isEmpty);
  });

  test('RaygunBreadcrumbLevel round-trips as string for every value', () {
    for (final level in RaygunBreadcrumbLevel.values) {
      final original = RaygunBreadcrumbMessage(
        message: 'msg',
        level: level,
        timestamp: 1234567890,
      );
      final json = original.toJson();
      // levels must be serialised as strings, not ints
      expect(json['level'], isA<String>());
      expect(json['level'], level.name);

      // round-trip back through fromJson
      final decoded = RaygunBreadcrumbMessage.fromJson(json);
      expect(decoded.level, level);
      expect(decoded.message, 'msg');
      expect(decoded.timestamp, 1234567890);
    }
  });

  test('sendAllStored happy path re-sends and clears the cache', () async {
    await _deleteOldFiles();

    final service = CrashReportingPostService(
      client: Settings.customHttpClient,
    );
    final raygunMessage = RaygunMessage();
    await service.store(raygunMessage.toJson());
    await service.store(raygunMessage.toJson());

    var files = await CrashReportingPostService.getCachedFiles();
    expect(files.length, 2);

    callCount = 0;
    await service.sendAllStored('KEY');

    // every cached payload should have been re-posted
    expect(callCount, 2);

    // cache should be empty after a successful flush
    files = await CrashReportingPostService.getCachedFiles();
    expect(files, isEmpty);
  });

  test('offline path stores instead of sending', () async {
    await _deleteOldFiles();
    Settings.getConnectivityState = () async => [ConnectivityResult.none];

    await Raygun.sendException(error: Exception('MESSAGE'));

    // MockClient must not have been hit
    expect(callCount, 0);
    expect(capturedBody, isNull);

    // payload should have been written to disk instead
    final files = await CrashReportingPostService.getCachedFiles();
    expect(files.length, 1);

    // clean up
    for (final file in files) {
      await file.delete();
    }
  });

  test('sendException passes explicit stackTrace through', () async {
    final trace = StackTrace.fromString(
      '#0      myMethod (package:my_app/foo.dart:42:7)\n'
      '#1      main (package:my_app/main.dart:10:3)',
    );
    await Raygun.sendException(error: Exception('MESSAGE'), stackTrace: trace);
    final frames = capturedBody['details']['error']['stackTrace'] as List;
    expect(frames, isNotEmpty);
    // first frame should be our explicit trace's first frame
    expect(frames.first['fileName'], contains('foo.dart'));
    expect(frames.first['lineNumber'], 42);
    expect(frames.first['methodName'], contains('myMethod'));
  });

  test('stack-trace lines serialise with expected keys', () async {
    await Raygun.sendException(error: Exception('MESSAGE'));
    final frames = capturedBody['details']['error']['stackTrace'] as List;
    expect(frames, isNotEmpty);
    final first = frames.first as Map<String, dynamic>;
    // matches Raygun API spec / .g.dart serialiser
    expect(
      first.keys,
      containsAll(<String>[
        'lineNumber',
        'className',
        'fileName',
        'methodName',
        'columnNumber',
      ]),
    );
  });

  test('breadcrumb category, customData and className round-trip', () {
    final original = RaygunBreadcrumbMessage(
      message: 'msg',
      category: 'navigation',
      level: RaygunBreadcrumbLevel.warning,
      customData: {'screen': 'home', 'count': 3},
      className: 'MyClass',
      methodName: 'myMethod',
      lineNumber: '17',
      timestamp: 1700000000000,
    );
    final json = original.toJson();
    expect(json['category'], 'navigation');
    expect(json['level'], 'warning');
    expect(json['customData'], {'screen': 'home', 'count': 3});
    expect(json['className'], 'MyClass');
    expect(json['methodName'], 'myMethod');
    expect(json['lineNumber'], '17');
    expect(json['timestamp'], 1700000000000);

    final decoded = RaygunBreadcrumbMessage.fromJson(json);
    expect(decoded.category, 'navigation');
    expect(decoded.level, RaygunBreadcrumbLevel.warning);
    expect(decoded.customData, {'screen': 'home', 'count': 3});
    expect(decoded.className, 'MyClass');
    expect(decoded.methodName, 'myMethod');
    expect(decoded.lineNumber, '17');
  });

  test('RaygunUserInfo round-trips through JSON', () {
    final user = RaygunUserInfo(
      identifier: 'abc',
      email: 'a@b.com',
      firstName: 'A',
      fullName: 'A B',
    );
    final json = user.toJson();
    expect(json['identifier'], 'abc');
    expect(json['email'], 'a@b.com');
    expect(json['firstName'], 'A');
    expect(json['fullName'], 'A B');
    expect(json['isAnonymous'], false);

    final decoded = RaygunUserInfo.fromJson(json);
    expect(decoded.identifier, 'abc');
    expect(decoded.email, 'a@b.com');
    expect(decoded.firstName, 'A');
    expect(decoded.fullName, 'A B');
    expect(decoded.isAnonymous, false);
  });

  test('nested innerError chain serialises to depth >1', () {
    final outer = RaygunErrorMessage('Outer', 'outer message');
    final middle = RaygunErrorMessage('Middle', 'middle message');
    final inner = RaygunErrorMessage('Inner', 'inner message');
    middle.innerError = inner;
    outer.innerError = middle;

    // Round-trip through JSON encoding so nested toJson() is invoked
    // (the generated serialiser stores the inner object as-is).
    final json = jsonDecode(jsonEncode(outer.toJson())) as Map<String, dynamic>;
    expect(json['className'], 'Outer');
    expect(json['innerError']['className'], 'Middle');
    expect(json['innerError']['innerError']['className'], 'Inner');
    expect(json['innerError']['innerError']['message'], 'inner message');
    expect(json['innerError']['innerError']['innerError'], isNull);
  });

  test('onBeforeSend can mutate tags before send', () async {
    Raygun.onBeforeSend = (payload) {
      payload.details.tags.add('injected');
      return payload;
    };
    await Raygun.sendException(error: Exception('MESSAGE'), tags: ['original']);
    expect(capturedBody['details']['tags'], ['original', 'injected']);
    Raygun.onBeforeSend = null;
  });

  test('onBeforeSend returning payload unchanged sends as-is', () async {
    Raygun.onBeforeSend = (payload) => payload;
    await Raygun.sendException(error: Exception('MESSAGE'));
    expect(capturedBody['details']['error']['message'], 'Exception: MESSAGE');
    Raygun.onBeforeSend = null;
  });

  test('429 response retains the payload for retry', () async {
    await _deleteOldFiles();
    Settings.customHttpClient = MockClient((request) async {
      callCount += 1;
      return http.Response('', 429);
    });

    await Raygun.sendException(error: Exception('MESSAGE'));

    // it was sent once
    expect(callCount, 1);
    // and the payload should have been stored for later retry
    final files = await CrashReportingPostService.getCachedFiles();
    expect(files.length, 1);

    // clean up
    for (final file in files) {
      await file.delete();
    }
  });

  test('init called twice replaces the apiKey and version', () async {
    await Raygun.init(apiKey: 'KEY1', version: '1.0.0');
    expect(Settings.apiKey, 'KEY1');
    await Raygun.init(apiKey: 'KEY2', version: '2.0.0');
    expect(Settings.apiKey, 'KEY2');
    expect(Settings.version, '2.0.0');
  });
}

Future<void> _deleteOldFiles() async {
  final oldFiles = await CrashReportingPostService.getCachedFiles();
  for (final file in oldFiles) {
    print('Deleting old file: ${file.path}');
    await file.delete();
  }
}
