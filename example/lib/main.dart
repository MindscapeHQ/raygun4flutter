// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raygun4flutter/raygun4flutter.dart';

void main() {
  // Configure Flutter to report errors to Raygun
  //
  // Called whenever the Flutter framework catches an error.
  // Only works when running in Release.
  FlutterError.onError = (details) {
    // Default error handling
    FlutterError.presentError(details);

    // Raygun error handling
    Raygun.sendException(
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // To catch any 'Dart' errors 'outside' of the Flutter framework.
  runZonedGuarded<Future<void>>(() async {
    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(
      error: error,
      stackTrace: stackTrace,
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // example: init with app version
    Raygun.init(apiKey: '', version: '1.2.3');

    // example: set custom tags to all error messages
    Raygun.setTags(['tag1', 'tag2']);

    // example: set custom data to all error messages
    Raygun.setCustomData({'custom': 'data'});

    // example: custom onBeforeSend to process payload
    Raygun.onBeforeSend = (payload) {
      // example: print error message before sending
      final message = payload.details.error.message;
      debugPrint('Sending: $message');

      // example: remove breadcrumbs with confidential data
      payload.details.breadcrumbs.removeWhere(
        (breadcrumb) => breadcrumb.message.contains('some-confidential-data'),
      );

      // example: cancel sending if condition is met
      if (message.contains('some-pattern')) {
        return null;
      }

      // important! return payload to continue with the payload send
      return payload;
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Raygun4Flutter example app'),
        ),
        body: Column(
          children: [
            // example: button tap causes sync Dart exception
            ElevatedButton(
              onPressed: () {
                throw StateError('This is a Dart exception.');
              },
              child: const Text('Cause Dart Exception'),
            ),

            // example: Button tap causes async Dart exception
            ElevatedButton(
              onPressed: () async {
                Future<void> foo() async {
                  throw StateError('This is an async Dart exception.');
                }

                Future<void> bar() async {
                  await foo();
                }

                await bar();
              },
              child: const Text('Cause Async Dart Exception'),
            ),

            // example: Button tap sends custom error
            ElevatedButton(
              onPressed: () {
                Raygun.sendCustom(
                  className: 'MyApp',
                  reason: 'test error message',
                );
              },
              child: const Text('Send custom error'),
            ),

            // example: Button tap sends custom error with StackTrace
            ElevatedButton(
              onPressed: () {
                Raygun.sendCustom(
                  className: 'MyApp',
                  reason: 'test error message',
                  stackTrace: StackTrace.current,
                );
              },
              child: const Text('Send custom error with StackTrace'),
            ),

            // example: Button tap sends custom error with tags
            ElevatedButton(
              onPressed: () {
                Raygun.sendCustom(
                  className: 'MyApp',
                  reason: 'test error message',
                  tags: ['myTag1', 'myTag2'],
                  customData: {
                    'custom1': 'value',
                    'custom2': 42,
                  },
                  stackTrace: StackTrace.current,
                );
              },
              child: const Text('Send custom error with tags and customData'),
            ),

            // example: Button tap adds breadcrumb to future error message
            ElevatedButton(
              onPressed: () {
                Raygun.recordBreadcrumb('test breadcrumb');
                Raygun.recordBreadcrumbObject(
                  RaygunBreadcrumbMessage(
                    message: 'message',
                    category: 'category',
                    level: RaygunBreadcrumbLevel.warning,
                    customData: {'custom': 'data'},
                  ),
                );
              },
              child: const Text('Breadcrumb'),
            ),

            // example: Button tap sets User Id
            ElevatedButton(
              onPressed: () {
                Raygun.setUserId('1234');
              },
              child: const Text('User Id'),
            ),

            // example: Button tap sets full User info
            ElevatedButton(
              onPressed: () {
                Raygun.setUser(
                  RaygunUserInfo(
                    identifier: '1234',
                    firstName: 'FIRST',
                    fullName: 'FIRST LAST',
                    email: 'test@example.com',
                  ),
                );
              },
              child: const Text('Set RaygunUserInfo'),
            ),

            // example: Button tap clears user data and makes user anonymous
            ElevatedButton(
              onPressed: () {
                Raygun.setUser(null);
              },
              child: const Text('Set Anonymous user'),
            ),
          ],
        ),
      ),
    );
  }
}
