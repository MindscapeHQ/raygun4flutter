# raygun4flutter

![Pub Version](https://img.shields.io/pub/v/raygun4flutter)
[![CI](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml/badge.svg)](https://github.com/MindscapeHQ/raygun4flutter/actions/workflows/main.yml)

The world's best Flutter Crash Reporting solution.

## Introduction

### Library organisation

The file `lib/raygun4flutter.dart` provides the main API entry point for Flutter users.

### Requirements

- Dart SDK 3.3.0+

As of release 1.0.0 we've started to improve support for Flutter Desktop and Web. The package seems to be working fine with these targets but we'd appreciate any additional feedback on Github.

## Installation

### 1. Depend on it

Run this command:

`$ flutter pub add raygun4flutter`

This will add a line like this to your package's pubspec.yaml (and run an implicit `dart pub get`):

```
dependencies:
  raygun4flutter: ^x.y.z
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

- [Raygun4Android](https://github.com/MindscapeHQ/raygun4android/) for Android apps.
- [Raygun4Apple](https://github.com/MindscapeHQ/raygun4apple) for iOS and macOS apps.
- [Raygun4js](https://github.com/MindscapeHQ/raygun4js) for web apps.

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

You can also provide an optional `innerError` `Exception` object that will be attached to the error report.

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
  innerError: Exception('Error!'),
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

### Getting/setting/cancelling the error before it is sent

This provider has an `onBeforeSend` API to support accessing or mutating the candidate 
error payload immediately before it is sent, or cancelling the sending action. 

This is provided as the public callback `Raygun.onBeforeSend`, 
which takes an `OnBeforeSendCallback`.

Example:

```dart
Raygun.onBeforeSend = (payload) {
  // e.g. override the payload error message with a new message
  payload.details.error!.message = 'New Error Message';
  
  // important: return the payload to continue the sending action
  return payload;
};
```

To cancel the sending action, return `null`:

```dart
Raygun.onBeforeSend = (payload) {
  return null;
};
```

Set the `Raygun.onBeforeSend` to `null` to remove your custom callback:

```dart
Raygun.onBeforeSend = null;
```

### Affected Customers

Raygun supports tracking the unique customers who encounter bugs in your apps.

By default, a device-derived UUID is transmitted. You can also add the currently logged in customer's data like this using an object of type `RaygunUserInfo`:

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

## Obfuscation

Flutter supports code obfuscation with the `--obfuscate` parameter, this option generates symbol files that can be used to decode the obfuscated stack traces, as described in the section [Obfuscate Dart code](https://docs.flutter.dev/deployment/obfuscate) from the Flutter SDK.

Note that Flutter Web uses sourcemaps instead, which are described in the next section.

### Using Flutter mobile/native symbols within Raygun

To decode obfuscated Flutter stacktraces within Raygun, you can take advantage of our Flutter Symbols center, located within the Application Settings section of you app. From there, add the version number of your symbols and upload the particular file.

The file name should follow the following convention - `app.{platform}-{architecture}.symbols`

The version is required to match with the `version` located in the crash report. In order to ensure we process your intended crash reports.

To set the `version`, you can add the version during the initialization (`Raygun.init`) or calling `.setVersion()` where it is avaliable. More information can be find in the [Setup and usage section](https://github.com/MindscapeHQ/raygun4flutter?tab=readme-ov-file#setup-and-usage)

Once the symbols have been uploaded, incoming crash reports will be decoded. To symbolicate crash reports that were existing before uploading the symbols to the symbols center, head to the crash report of the identified de-symbolicated crash and scroll fown to the 'Error instance command section. Hit the 'Reprocess' button to start the decoding of the crash report which will eventually show the symbolicated stack trace.  

### Uploading symbols with Raygun CLI

Raygun CLI is a command-line tool for Raygun. You can use this tool to upload symbol files directly from CI.

Install with: 

```
dart pub global activate raygun_cli
```

To upload symbol files to Raygun, navigate to your project root and run the `symbols upload` command with the following parameters:

- `path` location of the symbols file.
- `version` app version.
- `app-id` the Application ID in Raygun.com.
- `token` is an access token from https://app.raygun.com/user/tokens.

```
raygun-cli symbols upload --path=<path to symbols file> --version=<app version> --app-id=APP_ID --token=TOKEN
```

Obtain a list of the uploaded symbol files with the `symbols list` command:

```
raygun-cli symbols list --app-id=APP_ID --token=TOKEN
```

For more information see [raygun-cli on pub.dev](https://pub.dev/packages/raygun_cli).

### Manual processing

To decode obfuscated Flutter stacktraces with Raygun manually, you will have to copy the stacktrace into a file and run the `flutter symbolize` command on your local system.

For example, a file named `stack.txt`. It will look similar to this:

```
at *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** (file:///***:null)
at pid: 29207, tid: 29228, name 1.ui (unparsed:null)
at android arch: arm64 comp: yes sim: no (os::null)
at build_id: '63956a45f09b3f8410d244053eebd180' (unparsed:null)
at isolate_dso_base: 708882d000, vm_dso_base: 708882d000 (unparsed:null)
at isolate_instructions: 7088903b40, vm_instructions: 70888ed000 (unparsed:null)
at #00 abs 00000070889bcc93 virt 000000000018fc93 _kDartIsolateSnapshotInstructions+0xb9153 (unparsed:null)
at #01 abs 00000070889464fb virt 00000000001194fb _kDartIsolateSnapshotInstructions+0x429bb (unparsed:null)
... etc ...
```

Then, run the decode command passing in the copied stacktrace and the symbol file corresponding to the architecture. For example:

```
flutter symbolize -i stack.txt -d out/android/app.android-arm64.symbols
```

The decoded output will be similar to this:

```
at *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** (file:///***:null)
at pid: 29207, tid: 29228, name 1.ui (unparsed:null)
at android arch: arm64 comp: yes sim: no (os::null)
at build_id: '63956a45f09b3f8410d244053eebd180' (unparsed:null)
at isolate_dso_base: 708882d000, vm_dso_base: 708882d000 (unparsed:null)
at isolate_instructions: 7088903b40, vm_instructions: 70888ed000 (unparsed:null)
at #0      _MyAppState.build.<anonymous closure> (/[redacted]/raygun4flutter/example/lib/main.dart:89:17)
at #1      _InkResponseState.handleTap (//[redacted]/flutter/packages/flutter/lib/src/material/ink_well.dart:1170:21)
... etc ...
```

## Flutter web source maps

Flutter web applications use `dart2js` to produce a single JavaScript file `main.dart.js`.

However, when reporting errors to Raygun, the reported stack traces correspond to the JavaScript generated code and not the original Dart code.

Source maps help to convert generated JavaScript code back into Dart source code.
Raygun uses them to take obfuscated stack trace errors that point to generated JavaScript code and translate them to locations in Dart code.

To generate the Flutter web source maps, compile your project with the `--source-maps` option.

For example:

```
flutter build web --source-maps
```

This will generate the source map file, e.g. `main.dart.js.map` inside the `build/web` folder.

Then, upload this file to the **Js Source Map Center** in your Raygun project's **Application Settings** and configure them appropriately.

You can find more information regarding source maps within our documentation site - [Source Maps for JavaScript](https://raygun.com/documentation/language-guides/javascript/crash-reporting/source-maps/).

### Uploading source maps with Raygun CLI

Raygun CLI is a command-line tool for Raygun.

Install with: 

```
dart pub global activate raygun_cli
```

To upload Flutter web sourcemaps to Raygun, navigate to your project root and run the `sourcemap` command with the `platform` armument (`-p`) to `flutter` and set the `uri`, `app-id` and access `token` parameters.

- `uri` is the full URI where your application `main.dart.js` will be installed to.
- `app-id` the Application ID in Raygun.com.
- `token` is an access token from https://app.raygun.com/user/tokens.

```
raygun-cli sourcemap -p flutter --uri=https://example.com/main.dart.js --app-id=APP_ID --token=TOKEN
```

The `input-map` argument is optional for Flutter web projects. `raygun-cli` will try to find the `main.dart.js.map` file in `build/web/main.dart.js.map` automatically.

For more information see [raygun-cli on pub.dev](https://pub.dev/packages/raygun_cli)

## Comprehensive sample app

For a working sample app across multiple platforms, check the Flutter project in the `example` directory.

## Known issues

1. `setMaxReportsStoredOnDevice` is not exposed and is currently set to 64.

