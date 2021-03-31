# raygun4flutter

![Pub Version](https://img.shields.io/pub/v/raygun4flutter)
[![CI](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml/badge.svg)](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml)


The world's best Flutter Crash Reporting and Real User Monitoring solution.

This plugin uses the Android and iOS plugins internally to report crashes and custom
error messages to Raygun.

## Requirements

- Android API 16
- iOS 10.0
- Web and desktop not supported.

## Installation

Check the "Installing" tab in pub.dev for more info.

## Usage

For a working sample, check the Flutter project in `example`.

### Capturing errors

To be able to capture errors inside Flutter, you need to add the following changes in your main method:

Provide a custom `FlutterError.onError` that redirects Flutter errors to Raygun.

Note: This only works when the app is running in "Release" mode.

```dart
  FlutterError.onError = (details) {
    // Default error handling
    FlutterError.presentError(details);

    // Raygun error handling
    Raygun.sendException(
      details.exception,
      details.stack,
    );
  };
```

Catch errors outside of the Flutter framework by calling to `runApp` from a `runZonedGuarded` and redirecting
captured errors to Raygun. For example, errors happening in asynchronous code.

Note: This works both in "Release" and "Debug" modes.

```dart
  // To catch any 'Dart' errors 'outside' of the Flutter framework.
  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(error, stackTrace);
  });
```

### Initialisation

Call `Raygun.init(API_KEY)` to initialise RaygunClient on app start, for example, from your `initState` method.

```dart
class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Raygun.init('12345');
  }

}
```

### Sending errors manually

Call `Raygun.sendException(error, stacktrace)` to send errors to Raygun.

For example:

```dart
try {
  // code that crashes
} catch (error, stackTrace) {
  Raygun.sendException(error, stacktrace);
}
```

### Sending custom errors manually

Call `Raygun.sendCustom(className, message, stacktrace)` to send custom errors to Raygun.

For example:

```dart
Raygun.sendCustom(
  'MyApp',
  'test error message',
  StackTrace.current,
);
```

### Sending breadcrumbs

Call `Raygun.breadcrumb(message)` to send breadcrumbs to Raygun.

```dart
Raygun.breadcrumb('test breadcrumb');
```

### Set User Id

Call `Raygun.setUserId(id)` to set the User Id on Raygun.

```dart
Raygun.setUserId('1234');
```

Call with id `null` to clear it.

