## 1.2.1

* Fix issue with malformed cached files.
  * UUID added to cached files to ensure unique filename.
  * Delete old stored files in case of format exception.

## 1.2.0

* Upgrade dependencies

## 1.1.5

* Add `onBeforeSend` to process error payloads before sending them
* Upgrade dependencies

## 1.1.4

* Upgrade dependencies

## 1.1.3

* Use stubs to enable web support

## 1.1.2

* Upgrade dependencies

## 1.1.1

* Update README

## 1.1.0

* Breadcrumb improvements: timestamps and order
* Change to api.raygun.com

## 1.0.0

* Stable release (no changes)

## 1.0.0-dev.4

* Better Windows support
* use developer.log instead of print for internal logs

## 1.0.0-dev.3

* Better MacOS support

## 1.0.0-dev.2

* Better Flutter for Web support

## 1.0.0-dev.1

* Upcoming version 1.0.0
* Complete rework of the package implementation.
* Pure Dart implementation, no longer depends on Android and iOS plugins.
* Same API as version 0.5.1
* Native Dart stack traces

Potentially breaking API change:

* `Raygun.sendCustom()`: changed argument `message` to `reason`

## 0.5.1

* Formatting fixes

## 0.5.0

* Change `init()` signature to named parameters and added optional `version`.
* Added `setTags()` and `setCustomData()` methods.
* Added `tags` and `customData` to the error sending methods.
* Error sending methods can generate a stacktrace automatically.
* Added `setUser()` method with `RaygunUserInfo`.
* Added `setVersion()` method.
* Renamed breadcrumb method to `recordBreadcrumb()`.
* Added `recordBreadcrumbObject()`.
* Added `clearBreadcrumbs()`.
* Added `setCustomCrashReportingEndpoint()`.

## 0.1.0

* Null safety migration
* BREAKING: setUserId accepts only String or null, Int is not accepted anymore

## 0.0.5

* Updated README.md

## 0.0.4

* Renamed package to raygun4flutter because pub.dev conventions

## 0.0.3

* Updated README.md
* Updated pubspec.yml

## 0.0.2

* Updated README.md
* Updated pubspec.yml

## 0.0.1

* Initial release
