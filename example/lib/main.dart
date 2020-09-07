import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:raygun4flutter/raygun.dart';

void main() {
  // Configure Flutter to report errors to Raygun
  //
  // Called whenever the Flutter framework catches an error.
  FlutterError.onError = (details) {
    // Default error handling
    FlutterError.presentError(details);

    // Raygun error handling
    Raygun.sendException(
      details.exception,
      details.stack,
    );
  };

  // Catch any errors in the main() function.
  Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
    var isolateError = pair as List<dynamic>;
    await Raygun.sendException(
      isolateError.first.toString(),
      // isolateError.last,
    );
  }).sendPort);

  // To catch any 'Dart' errors 'outside' of the Flutter framework.
  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Raygun4Flutter example app'),
        ),
        body: Column(
          children: [
            RaisedButton(
              child: Text('Cause Dart Exception'),
              onPressed: () {
                throw new StateError('This is a Dart exception.');
              },
            ),
            RaisedButton(
              child: Text('Cause Async Dart Exception'),
              onPressed: () async {
                foo() async {
                  throw new StateError('This is an async Dart exception.');
                }

                bar() async {
                  await foo();
                }

                await bar();
              },
            ),
            RaisedButton(
              child: Text('Send custom error'),
              onPressed: () {
                Raygun.sendCustom(
                  'MyApp',
                  'test error message',
                  StackTrace.current,
                );
              },
            ),
            RaisedButton(
              child: Text('Breadcrumb'),
              onPressed: () {
                Raygun.breadcrumb('test breadcrumb');
              },
            ),
            RaisedButton(
              child: Text('User Id'),
              onPressed: () {
                Raygun.setUserId('1234');
              },
            ),
          ],
        ),
      ),
    );
  }
}
