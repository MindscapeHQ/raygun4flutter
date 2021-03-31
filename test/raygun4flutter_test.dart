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
    Raygun.init('KEY');
    expect(fakeChannel.invocation, {
      'init': {'apiKey': 'KEY'}
    });
  });

  test('sendException without StackTrace', () {
    Raygun.sendException(Exception('MESSAGE'));
    expect(fakeChannel.invocation, {
      'send': {
        'className': '_Exception',
        'reason': 'Exception: MESSAGE',
        'stackTrace': '',
      },
    });
  });

  test('sendException with StackTrace', () {
    Raygun.sendException(Exception('MESSAGE'), StackTrace.current);
    expect(fakeChannel.invocation, {
      'send': {
        'className': '_Exception',
        'reason': 'Exception: MESSAGE',
        'stackTrace':
            'main.<fn>#test/raygun4flutter_test.dart 38:59;Declarer.test.<fn>.<fn>#package:test_api/src/backend/declarer.dart 200:19;StackZoneSpecification._registerUnaryCallback.<fn>#package:stack_trace/src/stack_zone_specification.dart'
      },
    });
  });

  test('Breadcrumb', () {
    Raygun.breadcrumb('BREADCRUMB');
    expect(fakeChannel.invocation, {
      'breadcrumb': {
        'message': 'BREADCRUMB',
      },
    });
  });

  test('UserId with ID', () {
    Raygun.setUserId('ID');
    expect(fakeChannel.invocation, {
      'userId': {
        'userId': 'ID',
      },
    });
  });

  test('UserId to null', () {
    Raygun.setUserId(null);
    expect(fakeChannel.invocation, {
      'userId': {
        'userId': null,
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
