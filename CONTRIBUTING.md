# Contributing to Raygun4Flutter

## Project and library organisation

Building the project requires the [Flutter SDK](https://docs.flutter.dev/get-started/install).
The minimum version requirement is specified in the `pubspec.yaml`.

The `raygun4flutter` package is at the repository root.

The `example` folder contains an example app showing the provider capabilities.

## Building and running

The recommended IDE for working on this project is Visual Studio Code.

You should install the official Flutter plugin as well.

### Tests

To run tests, run `flutter test` or run all tests from VSCode.

### Code analysis

To check the code, run `flutter analyze`.

### Formatting

To format the code, run `dart format .` (note the `.` at the end).

### Dependency and generated file policy

The root package and example app both commit their `pubspec.lock` files. CI
installs dependencies with `flutter pub get --enforce-lockfile`, so update the
matching lockfile whenever changing a `pubspec.yaml` or intentionally refreshing
dependencies.

Dependency updates should usually be isolated to dependency-specific PRs, either
from Dependabot or from running `flutter pub upgrade` deliberately. Review the
lockfile diff alongside any manifest change so transitive dependency changes are
visible.

Message models under `lib/src/messages/` use `json_serializable` and commit their
generated `.g.dart` files. After changing a model or JSON annotation, regenerate
the files with:

```
dart run build_runner build
```

Before release or when changing package metadata, validate the package contents
with:

```
flutter pub publish --dry-run
```

### Running from Visual Code

Run the example project directly from VSCode by opening the `example/lib/main.dart`
and clicking on "Start Debugging"

### Running from command-line

Run the example from command line by running `flutter run` inside the `example` folder.

## How to contribute?

This section is intended for external contributors not part of the Raygun team.

Before you undertake any work, please create a ticket with your proposal,
so that it can be coordinated with what we're doing.

If you're interested in contributing on a regular basis,
please get in touch with the Raygun team.

### Fork the repository

Please fork the main repository from https://github.com/MindscapeHQ/raygun4flutter
into your own GitHub account.

### Create a new branch

Create a local branch off `develop` in your fork,
named so that it explains the work in the branch.

Do not submit a PR directly from your `develop` branch.

### Open a pull request

Submit a pull request against the main repositories' `develop` branch. 

Fill the PR template and give it a title that follows the [Conventional Commits guidelines](https://www.conventionalcommits.org/en/v1.0.0/).

### Wait for a review

Wait for a review by the Raygun team.
The team will leave you feedback and might ask you to do changes in your code.

Once the PR is approved, the team will merge it.
