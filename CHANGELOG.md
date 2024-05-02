## 3.0.1

*  chore(deps): bump device_info_plus from 10.0.1 to 10.1.0 (#160)
*  chore(deps): bump network_info_plus from 5.0.2 to 5.0.3 (#159)
*  chore(deps): bump uuid from 4.3.3 to 4.4.0 (#158)
*  chore(deps): bump build_runner from 2.4.8 to 2.4.9 (#157)
*  chore(deps): bump package_info_plus from 6.0.0 to 7.0.0 (#161)

## 3.0.0

* feat: Support multiple connectivity values in network report.
  * e.g. VPN and WiFi.
* chore: Upgrade major dependencies.
  * `connectivity_plus: ^6.0.1`
  * `device_info_plus: ^10.0.1`
  * `network_info_plus: ^5.0.2`
  * `package_info_plus: ^6.0.0`
* chore: Increase minimum required SDK versions (as required by dependencies).
  * Flutter `>=3.19.0`
  * Dart `>=3.3.0`

## 2.1.2

* chore: upgrade dependencies

## 2.1.1

* chore: upgrade dependencies

## 2.1.0

* chore: upgrade dependencies

## 2.0.0

* chore: upgrade dependencies
* feat: support for Dart 3 and Flutter 3.10

## 1.3.0

* fix: test with Flutter 3.7 compatibility (#101)
* chore: upgrade dependencies (#102)
* fix: revert to intl 0.17.0

## 1.2.4

*  (HEAD -> master, origin/master, origin/HEAD) chore(deps): bump json_serializable from 6.5.3 to 6.6.0 (#92)
*  chore(deps): bump lint from 1.10.0 to 2.0.1 in /example (#91)
*  chore(deps): bump lint from 1.10.0 to 2.0.1 (#90)
*  chore(deps): bump package_info_plus from 3.0.1 to 3.0.2 (#89)
*  chore(deps): bump uuid from 3.0.6 to 3.0.7 (#88)
*  chore(deps): bump device_info_plus from 7.0.1 to 8.0.0 (#86)
*  chore(deps): bump raygun4flutter from 1.2.2 to 1.2.3 in /example (#85)

## 1.2.3

* chore(deps): bump device_info_plus from 6.0.0 to 7.0.1  (2022-10-25)
* chore(deps): bump package_info_plus from 2.0.0 to 3.0.1  (2022-10-25)
* chore(deps): bump build_runner from 2.3.0 to 2.3.2 (#82) (2022-10-25)
* chore(deps): bump json_serializable from 6.5.1 to 6.5.3 (#80) (2022-10-25)
* chore(deps): bump connectivity_plus from 2.3.9 to 3.0.2 (#79) (2022-10-25)
* chore(deps): bump raygun4flutter from 1.2.1 to 1.2.2 in /example (#78) (2022-10-25)
* chore(deps): bump network_info_plus from 2.3.2 to 3.0.1 (#83) (2022-10-25)

## 1.2.2

* chore(deps): upgrade example (#76) (2022-10-14)
* chore(deps): bump network_info_plus from 2.1.3 to 2.3.2 (#73) (2022-10-14)
* chore(deps): bump build_runner from 2.1.11 to 2.3.0 (#72) (2022-10-14)
* chore(deps): upgrade dependencies (#75) (2022-10-14)
* chore(deps): bump connectivity_plus from 2.3.5 to 2.3.9 (#70) (2022-10-14)
* chore(deps): bump http from 0.13.4 to 0.13.5 (#68) (2022-10-14)
* chore(deps): bump json_annotation from 4.5.0 to 4.7.0 (#67) (2022-10-14)
* chore(deps): bump lint from 1.8.2 to 1.10.0 (#71) (2022-10-14)
* chore(deps): bump lint from 1.7.2 to 1.10.0 in /example (#66) (2022-10-14)
* chore(deps): bump json_serializable from 6.2.0 to 6.5.1 (#69) (2022-10-14)
* chore(deps): bump device_info_plus from 4.0.0 to 6.0.0 (#65) (2022-10-14)
* chore(deps): bump raygun4flutter from 1.1.4 to 1.2.1 in /example (#64) (2022-10-14)
* chore(deps): bump subosito/flutter-action from 1 to 2 (#63) (2022-10-14)
* chore(deps): bump actions/checkout from 2 to 3 (#62) (2022-10-14)
* ci: add dependabot config (2022-10-14)

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
