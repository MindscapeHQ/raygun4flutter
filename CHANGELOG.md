## 1.0.0

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
