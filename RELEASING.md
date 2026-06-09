# Releasing Raygun4Flutter

Raygun for Flutter is published on pub.dev as [`raygun4flutter`](https://pub.dev/packages/raygun4flutter).

## Semantic versioning

Flutter and Dart packages published on pub.dev follow semantic versioning,

Given a version number MAJOR.MINOR.PATCH (x.y.z), increment the:

- MAJOR version when you make incompatible changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

To learn more about semantic versioning check: https://semver.org/

## Preparing for release

### Release branch

Create a new branch named `release/x.y.z` 
where `x.y.z` is the Major, Minor and Patch release numbers.

### Update version

Update the `version` in the `pubspec.yaml` file.
As well, update the `kVersion` in `lib/src/services/settings.dart`.

### Update lockfile

Run `flutter pub get` to update the version in `pubspec.lock`, then keep the
updated lockfile in the release PR. CI installs dependencies with
`flutter pub get --enforce-lockfile`, so the release PR must include any
lockfile changes caused by the version update.

### Update CHANGELOG.md

Add a new entry in the `CHANGELOG.md` file.

Obtain a list of changes using the following git command:

```
git log --pretty=format:"- %s (%as)"
```

### Run publish dry-run

Run a publish dry-run from a clean git state to validate the package contents
before review and before publishing:

```
flutter pub publish --dry-run
```

### Commit and open a PR

Commit all the changes into a commit with the message `chore: Release x.y.z`
where `x.y.z` is the Major, Minor and Patch release numbers.

Then push the branch and open a new PR, ask the team to review it.

## Publishing

### PR approval

Once the PR has been approved, you can publish the provider.

### Publish to pub.dev

Run the publish command without `dry-run`.
You will need pub.dev credentials to publish, 
as well as being part of the [Raygun organization](https://pub.dev/publishers/raygun.com/packages).

```
flutter pub publish
```

Now the package is available for customers.

### Merge PR to develop

With the PR approved and the package published, 
squash and merge the PR into `develop`.

### Tag and create Github Release

Go to https://github.com/MindscapeHQ/raygun4flutter/releases and create a new Release.

GitHub will create a tag for you, you don't need to create the tag manually.

You can also generate the release notes automatically.

## Merge to `master`

Once the release process is completed, it would be good to merge `develop` into `master`.

### Create a merge PR

Create a PR manually where `develop` merges into `master`
or by following this link: https://github.com/MindscapeHQ/raygun4flutter/compare/develop...master

You can name the PR `chore: merge to master`.

Then ask for approval by the Raygun team.

### Merge, don't squash

Do not squash this PR, instead, just merge. That will create a merge commit.
