# raygun4flutter

![Pub Version](https://img.shields.io/pub/v/raygun4flutter)
[![CI](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml/badge.svg)](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml)

The world's best Flutter Crash Reporting solution.

Current version: 1.1.3

## Introduction

### Library organisation

Raygun4Flutter is from version 1.0.0 onwards built entirely in Dart and does *not* rely on the native providers [Raygun4Android](https://github.com/MindscapeHQ/raygun4android/blob/master/README.md) and [Raygun4Apple](https://github.com/MindscapeHQ/raygun4apple) anymore as earlier versions of Raygun4Flutter.

The file `lib/raygun4flutter.dart` provides the main API entry point for Flutter users.

### Requirements

- Dart SDK 2.12+

Flutter for Web and Desktop are currently not *officially* supported yet. However, as of release 1.0.0-dev.1, the package seems to be working fine on them.

## Installation

### 1. Depend on it

Run this command:

`$ flutter pub add raygun4flutter`

This will add a line like this to your package's pubspec.yaml (and run an implicit `dart pub get`):

```
dependencies:
  raygun4flutter: ^1.1.3
```

Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

### 2. Import it

Now in your Dart code, you can use:

`import 'package:raygun4flutter/raygun4flutter.dart';`

Check the "Installing" tab on https://pub.dev/packages/raygun4flutter/install for more info.

### 3. Platform-specific notes

#### General

If your application comprises hybrid code both using Flutter and native Android or iOS elements, please be aware that the Raygun4Flutter package will only track and report crashes from Flutter and Dart.

If you have a requirement to track crash reports across various layers and parts of your application written in different technologies you might need to implement the respective native providers for Android, iOS or other platforms of choice as well.

#### Android-specific

In your app's **AndroidManifest.xml** (usually located in your Flutter project's `/android/src/main` directory), make sure you have granted Internet permissions. Inside the ```<manifest>``` element add:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

if it doesn't exist yet.

## Setup and usage
### Initialisation and version tracking

Call `Raygun.init()` with an apiKey argument to initialise RaygunClient on application start, for example, from your `initState` method.

```dart
class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Raygun.init(apiKey:'12345');
  }

}
```

The `.init()` method can also accept an optional `version` argument. If this is supplied, the version of your app will be tracked across Raygun crash reports:

```dart
Raygun.init(apiKey:'12345', version:'1.4.5');
```

As an additional convenience way to set the version, a method `.setVersion()` is available. Typical use cases would most likely fall back to setting the app version in the .init() method call when you setup the library.

## Capturing and sending errors

To be able to capture errors inside Flutter, you need to add a custom `FlutterError.onError` handler to your main method. That redirects Flutter errors to Raygun.

Note: This only works when the app is running in "Release" mode.

```dart
  FlutterError.onError = (details) {
    // Default error handling
    FlutterError.presentError(details);

    // Raygun error handling
    Raygun.sendException(
      error: details.exception,
      stackTrace: details.stack,
    );
  };
```

You can also catch Dart errors outside of the code controlled by the Flutter framework by calling to `runApp` from a `runZonedGuarded` and redirecting captured errors to Raygun. For example: errors that happen in asynchronous code.

Note: This works both in "Release" and "Debug" modes.

```dart
  runZonedGuarded<Future<void>>(() async {
    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(
      error: error,
      stackTrace: stackTrace,
    );
  });
```

### Sending errors manually

Call `Raygun.sendException(error, tags, customData, stackTrace)` to send errors to Raygun.

For example:

```dart
try {
  // code that crashes
} catch (error) {
  Raygun.sendException(error: error);
}
```

All arguments but `error` are optional. This method is mainly a convenience wrapper around the more customisable `.sendCustom()` method that obtains the class name and the message from the `error` object.

### Sending custom errors manually

Call `Raygun.sendCustom(className, reason, tags, customData, stackTrace)` to send custom errors to Raygun with your own customised `className` and `reason`. As with `.sendException()`, `tags`, `customData` and `stackTrace` are optional.

For example:

```dart
Raygun.sendCustom(
  className: 'MyApp',
  reason: 'test error message',
  tags: ['API','Tag2'],
  customData: {
    'custom1': 'value',
    'custom2': 42,
  },
  stackTrace: StackTrace.current,
);
```

Crash reports will be sent to the Raygun backend after the crash occurred. Should a user's device be offline, Raygun4Flutter will store up to 64 crash reports locally and try to send them when the device comes back online.

## Other functionality
### Setting tags

`Raygun.setTags()` sets a list of global tags that will be logged with every exception. This will be merged with other tags passed into manually created crash reports via `sendException()` and `sendCustom()`.

```dart
Raygun.setTags(['Tag1','Tag2']);
```
### Setting custom data

`Raygun.setCustomData()` sets a global map of key-value pairs that, similar to tags, that will be logged with every exception. This will be merged with other custom data passed into manually created crash reports via `sendException()` and `sendCustom()`.

```dart
Raygun.setCustomData({
  'custom1': 'value',
  'custom2': 42,
});
```

### Sending breadcrumbs

Breadcrumbs can be sent to Raygun to provide additional information to look into and debug issues stemming from crash reports. Breadcrumbs can be created in two ways.

#### Simple string:

Call `Raygun.recordBreadcrumb(message)`, where `message` is just a string:

```dart
Raygun.recordBreadcrumb('test breadcrumb');
```

#### Using RaygunBreadcrumbMessage:

Create your own `RaygunBreadcrumbMessage` object and send more than just a message with `Raygun.recordBreadcrumb(RaygunBreadcrumbMessage)`.

The structure of the type `RaygunBreadcrumbMessage` is as shown here:

```dart
 RaygunBreadcrumbMessage({
    required this.message,
    this.category,
    this.level = RaygunBreadcrumbLevel.info,
    this.customData,
    this.className,
    this.methodName,
    this.lineNumber,
  });
```

Breadcrumbs can be cleared with `Raygun.clearBreadcrumbs()`.

### Affected Customers

Raygun supports tracking the unique customers who encounter bugs in your apps.

By default a device-derived UUID is transmitted. You can also add the currently logged in customer's data like this using an object of type `RaygunUserInfo`:

```dart
Raygun.setUser(
  RaygunUserInfo(
    identifier: '1234',
    firstName: 'FIRST',
    fullName: 'LAST',
    email: 'test@example.com',
  ),
);
```

To clear the currently logged in customer, call `setUser(null)`.

There is an additional convenience method that offers a shortcut to just track your customer by an indentifier only. If you use an email address to identify the user, please consider using `setUser` instead of `setUserId` as it would allow you to set the email address into both the identifier and email fields of the crash data to be sent.

```dart
Raygun.setUserId('1234');
```

Call with `null` to clear the user identifier: `setUserId(null)`

### Custom endpoints

Raygun supports sending data from Crash Reporting to your own endpoints. If you want to set custom endpoints, could can do so by setting them after you've initialised Raygun:

```dart
Raygun.setCustomCrashReportingEndpoint(url)
```

Please note that setting a custom endpoint will stop Crash Report or Real User Monitoring data from being sent to the Raygun backend.

## Comprehensive sample app

For a working sample app across multiple platforms, check the Flutter project in the `example` directory.

## Known issues

1. `onBeforeSend` handlers that would allow you to modify the payload right before sending to the Raygun backend are currently unsupported.

2. `setMaxReportsStoredOnDevice` is not exposed and is currently set to 64.

