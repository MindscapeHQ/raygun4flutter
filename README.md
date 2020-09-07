# Raygun4flutter

The world's best Flutter Crash Reporting and Real User Monitoring solution.

This plugin uses the Android and iOS plugins internally to report crashes and custom
error messages to Raygun.

## Requirements

TBD

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  raygun4flutter: ^0.0.1
```

### Capturing errors

To be able to capture errors inside Flutter, you need to add the following changes in your main method:

Provide a custom `FlutterError.onError` that redirects Flutter errors to Raygun.

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
captured errors to Raygun.

```dart
  // To catch any 'Dart' errors 'outside' of the Flutter framework.
  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(error, stackTrace);
  });
```

### Platform specifics

#### Android

With Flutter 1.12, all the dependencies are automatically added to your project.
If your project was created before Flutter 1.12, you may need to follow [this](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects).

#### iOS

TBD

#### Other platforms

TBD

## Usage

### Initialisation

Call `Raygun.init(API_KEY)` to initialise RaygunClient on app start, for example, from your `initState` method.

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

