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
    Raygun.init('12345');
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
            ElevatedButton(
              onPressed: () {
                throw StateError('This is a Dart exception.');
              },
              child: const Text('Cause Dart Exception'),
            ),
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
            ElevatedButton(
              onPressed: () {
                Raygun.sendCustom(
                  className: 'MyApp',
                  reason: 'test error message',
                );
              },
              child: const Text('Send custom error'),
            ),
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
                );
              },
              child: const Text('Send custom error with tags and customData'),
            ),
            ElevatedButton(
              onPressed: () {
                Raygun.breadcrumb('test breadcrumb');
              },
              child: const Text('Breadcrumb'),
            ),
            ElevatedButton(
              onPressed: () {
                Raygun.setUserId('1234');
              },
              child: const Text('User Id'),
            ),
          ],
        ),
      ),
    );
  }
}
