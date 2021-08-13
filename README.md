# raygun4flutter

![Pub Version](https://img.shields.io/pub/v/raygun4flutter)
[![CI](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml/badge.svg)](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml)

The world's best Flutter Crash Reporting solution.

## Introduction

### Library organisation

This Flutter plugin internally uses the Android and iOS providers to report crashes and custom errors to Raygun.

In addition to this documentation, depending on your project's requirements we recommend to go through the platform-specific documentation for [Raygun4Android](https://github.com/MindscapeHQ/raygun4android/blob/master/README.md) and [Raygun4Apple](https://github.com/MindscapeHQ/raygun4apple) as well.

The file `lib/raygun4flutter.dart` provides the main API entry point for Flutter users. In there, the plugin sets up a `MethodChannel` to pass through the API calls to native Kotlin and Swift code in `android/src` and `ios/Classes` respectively. 

These bridges to native code provide additional information if you want to understand what exactly will be called in the native layers of the plugin.

### Requirements

- Android API 16+
- iOS 10.0+
- Flutter for Web and Desktop are currently not supported.

Raygun4Flutter currently uses the following versions of the native providers behind the scenes:

- Android: Raygun4Android 4.0.1
- iOS: 1.5.3

## Installation

### 1. Depend on it

Run this command:

`$ flutter pub add raygun4flutter`

This will add a line like this to your package's pubspec.yaml (and run an implicit `dart pub get`):

```
dependencies:
  raygun4flutter: ^0.5.0
```
Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

### 2. Import it

Now in your Dart code, you can use:

`import 'package:raygun4flutter/raygun4flutter.dart';`

Check the "Installing" tab on https://pub.dev/packages/raygun4flutter/install for more info.

### 3. Platform-specific notes

#### Android

In your app's **AndroidManifest.xml** (usually located in your Flutter project's `/android/src/main` directory), make sure you have granted Internet permissions. Beneath the ```<manifest>``` element add:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Inside the `<application>` element, add:

```xml
<service android:name="com.raygun.raygun4android.services.CrashReportingPostService"
         android:exported="false"
         android:permission="android.permission.BIND_JOB_SERVICE"
         android:process=":crashreportingpostservice"/>
```

Also please be aware that depending on the complexity of your Android project setup and if you use R8 or Proguard with additional Android code, you might need to add some custom rules for Proguard-support. This is outlined in the [Raygun4Android documentation](https://github.com/MindscapeHQ/raygun4android#raygun-and-proguard).

## Setup and usage
### Initialisation and version tracking

Call `Raygun.init()` with an API key to initialise RaygunClient on application start, for example, from your `initState` method.

```dart
class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Raygun.init('12345');
  }

}
```

The `.init()` method can also accept an optional `appVersion` argument. If this is supplied, the version of your app will be tracked across Raygun crash reports:

```dart
Raygun.init('12345','1.4.5');
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
      details.exception,
      details.stack,
    );
  };
```

You can also catch Dart errors outside of the code controlled by the Flutter framework by calling to `runApp` from a `runZonedGuarded` and redirecting captured errors to Raygun. For example: errors that happen in asynchronous code.

Note: This works both in "Release" and "Debug" modes.

```dart
  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    Raygun.sendException(error, stackTrace);
  });
```

### Sending errors manually

Call `Raygun.sendException(error, tags, customData, stackTrace)` to send errors to Raygun.

For example:

```dart
try {
  // code that crashes
} catch (error) {
  Raygun.sendException(error);
}
```

All arguments but `error` are optional. This method is mainly a convenience wrapper around the more customisable `.sendCustom()` method that obtains the class name and the message from the `error` object.

### Sending custom errors manually

Call `Raygun.sendCustom(className, message, tags, customData, stackTrace)` to send custom errors to Raygun with your own customised `className` and `message`. As with `.sendException()`, `tags`, `customData` and `stackTrace` are optional.

For example:

```dart
Raygun.sendCustom(
  className: 'MyApp',
  message: 'test error message',
  tags: ['API','Tag2'],
  stackTrace: StackTrace.current,
);
```

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

For a working sample app, check the Flutter project in the `example` directory.

## Known issues

1. `onBeforeSend` handlers that would allow you to modify the payload right before sending to the Raygun backend. If this functionality is required for you, you can use the respective feature as provided in the lower-level native providers.

2. `setMaxReportsStoredOnDevice` is not exposed to the Flutter layer. The respective platform details will apply.

3. Due to limitations to how the lower-level libraries manage stacktraces, the Flutter-specific stacktrace from iOS devices will currently be sent and shown in the custom data field. The easiest way to make this information more visible, is to favourite the field in the Raygun backend so that it show up on the first tab of your crash report.

We envisage to improve the issues listed above for a future 1.0.0 relese.
