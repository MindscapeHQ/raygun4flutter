# AGENTS.md — Raygun4Flutter

## Project overview

Raygun4Flutter is the official Raygun crash reporting provider for Flutter, published on pub.dev as `raygun4flutter`. It captures exceptions and sends them as JSON payloads to the Raygun API.

- **API spec**: https://raygun.com/documentation/product-guides/crash-reporting/api/
- **Reference implementation**: Raygun4JS (`../raygun4js`) — when in doubt about serialisation or payload structure, match what JS does.
- **Repository**: https://github.com/MindscapeHQ/raygun4flutter

## Architecture

```
lib/
  raygun4flutter.dart          # Public API (Raygun class) — the only entry point for consumers
  src/
    raygun_crash_reporting.dart # Builds RaygunMessage and sends it via CrashReportingPostService
    messages/                   # Data models with json_serializable — each has a .g.dart generated counterpart
    services/                   # Settings (global state), HTTP posting, caching
    utils/                      # Device info, machine name helpers
    logging/                    # Internal logger
test/
  raygun4flutter_test.dart     # Single test file using flutter_test + MockClient
example/                       # Example Flutter app
```

## Key conventions

### Dart & Flutter

- **SDK constraint**: `>=3.9.0 <4.0.0`, Flutter `>=3.30.0`
- **Linting**: Uses `package:lint/analysis_options_package.yaml`. Run `flutter analyze`.
- **Formatting**: Run `dart format .`
- **Tests**: Run `flutter test`. Tests use `flutter_test` and `package:http/testing.dart` MockClient to capture sent JSON payloads.

### JSON serialisation (important)

All message models use **`json_annotation`** + **`json_serializable`** with code generation.

- Model files live in `lib/src/messages/` and have a corresponding `.g.dart` file.
- **Never hand-edit `.g.dart` files.** After changing any model or `@JsonValue`/`@JsonKey` annotation, regenerate with:
  ```
  dart run build_runner build --delete-conflicting-outputs
  ```
- Enum values sent to the API **must be strings**, not integers. Use `@JsonValue('stringValue')` on enum members, not numeric indices.
- The `.g.dart` files **must** be committed — they are not gitignored.
- Verify serialisation matches the [Raygun API spec](https://raygun.com/documentation/product-guides/crash-reporting/api/) and the Raygun4JS reference implementation.

### Versioning

The version appears in **two places** that must be kept in sync:

1. `pubspec.yaml` → `version:`
2. `lib/src/services/settings.dart` → `Settings.kVersion`

### Branching & PRs

- Branch off `develop` (not `master`).
- PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) (enforced by CI).
- Release branches are named `release/x.y.z`.
- PRs merge into `develop`; `develop` is periodically merged to `master`.

### CI

- PR workflow validates the PR title follows Conventional Commits.
- No automated test runner in CI currently — run `flutter test` locally before submitting.

## Common tasks

| Task | Command |
|---|---|
| Get dependencies | `flutter pub get` |
| Run tests | `flutter test` |
| Analyse code | `flutter analyze` |
| Format code | `dart format .` |
| Regenerate `.g.dart` files | `dart run build_runner build --delete-conflicting-outputs` |
| Publish dry-run | `flutter pub publish --dry-run` |

## Testing approach

Tests are in a single file `test/raygun4flutter_test.dart`. They:

- Set `Settings.skipIfTest = true` to skip platform-dependent device info.
- Use `MockClient` to intercept HTTP requests and capture the JSON body.
- Assert on the serialised JSON structure (`capturedBody['details'][...]`).

When fixing serialisation bugs, add a test that asserts on the exact JSON value of the affected field.
