import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raygun4flutter/raygun4flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeMethodChannel fakeChannel;

  setUp(() {
    fakeChannel = FakeMethodChannel();
    // Re-pipe to our fake to verify invocations.
    Raygun.channel.setMockMethodCallHandler((MethodCall call) async {
      // The explicit type can be void as the only method call has a return type of void.
      await fakeChannel.invokeMethod<void>(call.method, call.arguments);
    });
  });

  test('init', () {
    Raygun.init(apiKey: 'KEY');
    expect(fakeChannel.invocation, {
      'init': {
        'apiKey': 'KEY',
        'version': null,
      }
    });
  });

  test('init with version', () {
    Raygun.init(apiKey: 'KEY', version: 'x.y.z');
    expect(fakeChannel.invocation, {
      'init': {
        'apiKey': 'KEY',
        'version': 'x.y.z',
      }
    });
  });

  test('sendException without StackTrace', () {
    Raygun.sendException(error: Exception('MESSAGE'));
    expect(fakeChannel.invocation, {
      'send': {
        'className': '_Exception',
        'reason': 'Exception: MESSAGE',
        'stackTrace':
            'main.<fn>#test/raygun4flutter_test.dart 40:12;Declarer.test.<fn>.<fn>#package:test_api/src/backend/declarer.dart 200:19;StackZoneSpecification._registerUnaryCallback.<fn>#package:stack_trace/src/stack_zone_specification.dart',
        'tags': null,
        'customData': null,
      },
    });
  });

  test('sendException with StackTrace', () {
    Raygun.sendException(
      error: Exception('MESSAGE'),
      stackTrace: StackTrace.current,
    );
    expect(fakeChannel.invocation, {
      'send': {
        'className': '_Exception',
        'reason': 'Exception: MESSAGE',
        'stackTrace':
            'main.<fn>#test/raygun4flutter_test.dart 56:30;Declarer.test.<fn>.<fn>#package:test_api/src/backend/declarer.dart 200:19;StackZoneSpecification._registerUnaryCallback.<fn>#package:stack_trace/src/stack_zone_specification.dart',
        'tags': null,
        'customData': null,
      },
    });
  });

  test('sendException with tags', () {
    Raygun.sendException(
      error: Exception('MESSAGE'),
      stackTrace: StackTrace.current,
      tags: ['tag1', 'tag2']
    );
    expect(fakeChannel.invocation, {
      'send': {
        'className': '_Exception',
        'reason': 'Exception: MESSAGE',
        'stackTrace':
        'main.<fn>#test/raygun4flutter_test.dart 73:30;Declarer.test.<fn>.<fn>#package:test_api/src/backend/declarer.dart 200:19;StackZoneSpecification._registerUnaryCallback.<fn>#package:stack_trace/src/stack_zone_specification.dart',
        'tags': ['tag1', 'tag2'],
        'customData': null,
      },
    });
  });

  test('Breadcrumb', () {
    Raygun.recordBreadcrumb('BREADCRUMB');
    expect(fakeChannel.invocation, {
      'recordBreadcrumb': {
        'message': 'BREADCRUMB',
      },
    });
  });

  test('UserId with ID', () {
    Raygun.setUserId('ID');
    expect(fakeChannel.invocation, {
      'setUserId': {
        'userId': 'ID',
      },
    });
  });

  test('UserId to null', () {
    Raygun.setUserId(null);
    expect(fakeChannel.invocation, {
      'setUserId': {
        'userId': null,
      },
    });
  });

  test('Set user with RaygunUserInfo', () {
    final raygunUserInfo = RaygunUserInfo(
      identifier: 'ID',
      firstName: 'FIRST',
      fullName: 'FULL',
      email: 'EMAIL',
    );
    Raygun.setUser(raygunUserInfo);
    expect(fakeChannel.invocation, {
      'setUser': {
        'identifier': 'ID',
        'firstName': 'FIRST',
        'fullName': 'FULL',
        'email': 'EMAIL',
      },
    });
  });
}

class FakeMethodChannel extends Fake implements MethodChannel {
  Map<String, dynamic>? invocation;

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    invocation = {method: arguments};
    return null;
  }
}
