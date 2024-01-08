## Contributing
### Flutter Vietmap GL
- Increase the version number in `pubspec.yaml` according to [semantic versioning](https://semver.org/).
- Update `CHANGELOG.md` with the new version number and changes.
- Change the version of vietmap_gl_platform_interface in `pubspec.yaml` to the lastest version.
- Run the following commands to format and analyze the code:
```bash
dart format . && dart fix --apply && flutter analyze 
```
Make sure that all tests are passing before submitting a pull request.
```bash
No issues found! 
```
- Commit your changes and open a pull request.

- If you are a maintainer, you can publish the package to pub.dev by running the following command:
```bash
flutter pub publish
```
### vietmap_gl_platform_interface
- Increase the version number in `pubspec.yaml` according to [semantic versioning](https://semver.org/).
- Update `CHANGELOG.md` with the new version number and changes.
- Run the following commands to format and analyze the code:
```bash
dart format . && dart fix --apply && flutter analyze 
```
Make sure that all tests are passing before submitting a pull request.
```bash
No issues found! 
```
- Commit your changes and open a pull request.

## Release

Current process: for each release we also create a separate branch (`release-x.y.z`), tag (`x.y.z`) and Github release (`x.y.z`).

This document describes the steps needed to make a release:

For each supported library:
 - `vietmap_gl_platform_interface`
 - `maplibre_gl_web`
 - `flutter-maplibre-gl`

Perform the following actions (these changes should also be on `main`):
 - Update `CHANGELOG.md` with the commits associated since previous release.
 - Update library version in `pubspec.yaml`


**Only on the release branch:** Repeat this action for `flutter-maplibre-gl` and `maplibre_gl_web` for the dependency_overrides:

```
Comment out:
dependency_overrides:
  mapbox_gl_platform_interface:
    path: ../mapbox_gl_platform_interface
```

and for the maplibre git dependencies, change ref from `main` to `release-x.y.z`.

Finally, create a Github release and git tag from the release branch.

The only difference between the release branch and `main` directly after the release are the `dependency_overrides` (these are useful for development and should therefore only be removed in the release branches) and the git ref for the intra-package dependencies.
