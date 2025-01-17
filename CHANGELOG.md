## 3.2.2

- fix(example): Add Internet permission to Android example project (#219) (2024-12-19)
- docs: Add raygun-cli symbols command to README.md (#225) (2025-01-09)
- docs: Add mobile/native symbols docs (#217) (2024-12-20)
- docs: Update README.md with native plugins links (#211) (2024-11-15)
- chore(deps): bump json_serializable from 6.9.0 to 6.9.2 (#221) (2025-01-06)
- chore(deps): bump device_info_plus from 11.1.0 to 11.2.0 (#222) (2025-01-06)
- chore(deps): bump shared_preferences from 2.3.3 to 2.3.4 (#220) (2025-01-06)
- chore(deps): bump package_info_plus from 8.1.1 to 8.1.2 (#223) (2025-01-06)
- chore(deps): bump connectivity_plus from 6.1.0 to 6.1.1 (#224) (2025-01-06)
- chore(deps): bump network_info_plus from 6.1.0 to 6.1.1 (#214) (2024-12-03)
- chore(deps): bump package_info_plus from 8.1.0 to 8.1.1 (#216) (2024-12-02)
- chore(deps): bump json_serializable from 6.8.0 to 6.9.0 (#215) (2024-12-02)
- chore(deps): bump shared_preferences from 2.3.2 to 2.3.3 (#213) (2024-12-02)
- chore(deps): bump intl from 0.19.0 to 0.20.1 (#212) (2024-12-02)
- ci: fix analyze issue (#218) (2024-12-19)

## 3.2.1

- fix: #29 Package version in client payload (#203) (2024-10-23)
- chore(deps): bump build_runner from 2.4.12 to 2.4.13 (#201) (2024-10-02)
- chore(deps): bump uuid from 4.5.0 to 4.5.1 (#202) (2024-10-02)
- chore(deps): bump connectivity_plus from 6.0.5 to 6.1.0 (#205) (2024-11-02)
- chore(deps): bump network_info_plus from 6.0.1 to 6.1.0 (#207) (2024-11-02)
- chore(deps): bump path_provider from 2.1.4 to 2.1.5 (#206) (2024-11-02)
- chore(deps): bump package_info_plus from 8.0.2 to 8.1.0 (#208) (2024-11-02)
- chore(deps): bump device_info_plus from 10.1.2 to 11.1.0 (#209) (2024-11-02)

## 3.2.0

- feat: #30 add innerError to sendCustom method (#195)
- fix: #31 Improve Environment details (#194)
- docs: add raygun-cli sourcemap to README.md (#196)
- docs: Add Obfuscation to README.md  (#192)
- chore: Upgrade dependencies to fix CI build (#193)
- chore(deps): bump path_provider from 2.1.3 to 2.1.4 (#190)
- chore(deps): bump shared_preferences from 2.2.3 to 2.3.1 (#189)
- chore(deps): bump package_info_plus from 8.0.0 to 8.0.1 (#188)
- chore(deps): bump network_info_plus from 5.0.3 to 6.0.0 (#187)
- chore(deps): bump device_info_plus from 10.1.0 to 10.1.1 (#186)
- chore(deps): bump uuid from 4.4.2 to 4.5.0 (#199)
- chore(deps): bump network_info_plus from 6.0.0 to 6.0.1 (#198)

## 3.1.0

- fix: Add columnNumber to stack trace (#178)
- docs: #61 Add Source Map documentation to README.md (#181)
- docs: fix typo in method doc (#179)
- ci: Set dependabot interval to "monthly" (#182)
- chore(deps): bump http from 1.2.1 to 1.2.2 (#183)
- chore(deps): bump uuid from 4.4.0 to 4.4.2 (#180)
- chore(deps): bump build_runner from 2.4.10 to 2.4.11 (#177)
- chore(deps): bump build_runner from 2.4.9 to 2.4.10 (#176)
- chore: Cleanup example and improve GitHub CI (#175)

## 3.0.2

* chore(deps): bump json_serializable from 6.7.1 to 6.8.0 (#168)
* chore(deps): bump connectivity_plus from 6.0.2 to 6.0.3 (#166)
* chore(deps): bump package_info_plus from 7.0.0 to 8.0.0 (#165)
* chore(deps): bump shared_preferences from 2.2.2 to 2.2.3 (#164)
* chore(deps): bump path_provider from 2.1.2 to 2.1.3 (#163)
* chore(deps): bump connectivity_plus from 6.0.1 to 6.0.2 (#162)

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
