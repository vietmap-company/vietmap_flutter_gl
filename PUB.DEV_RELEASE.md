## Release documentation for Vietmap library

### 1. Update library version
- Update version in `pubspec.yaml` file

### 2. Update CHANGELOG.md
- Add new version and release date
- Add new features, bug fixes, breaking changes, etc.

### 3. Check format and code problems
- Run `dart format .` to format code
- Run `dart fix --apply` to fix code problems
- Run `flutter analyze` to check code problems

Make sure there are no errors or warnings.

### 4. Commit and push changes
- Commit and push changes to `main` branch

### 5. Create a new release on GitHub
- Create a new release on GitHub with the same version as in `pubspec.yaml` file (e.g. `v0.1.0`)
- Follow the workflow below to monitor the release process
[pub.dev release Github Action](https://github.com/vietmap-company/vietmap_flutter_plugin/actions/workflows/publish.yaml)

Github Action will automatically publish the package to pub.dev when the release is created.


## Follow this [link](https://codingwithtashi.medium.com/publishing-your-flutter-packages-with-github-action-dd89d89f76d) for more information about publishing flutter package with Github Action
