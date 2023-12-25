# Contributing

We welcome contributions to this repository. Please follow these steps if you're interested in making contributions:

1. Please familiarize yourself with the [process of running the example app](https://github.com/vietmap-company/flutter-map-sdk#running-the-example-app).
2. Ensure that existing [pull requests](https://github.com/vietmap-company/flutter-map-sdk/pulls) and [issues](https://github.com/vietmap-company/flutter-map-sdk/issues) don’t already cover your contribution or question.

3. Create a new branch that will contain your contributed code. Along with your contribution you should also adapt the example app to showcase any new features or APIs you have developed. This also makes testing your contribution much easier. Eventually create a pull request once you're done making changes.

4. If there are any changes that developers should be aware of, please update the [changelog](https://github.com/vietmap-company/flutter-map-sdk/blob/master/CHANGELOG.md) once your pull request has been merged to the `master` branch.

## Contributing
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

- If you are a maintainer, you can publish the package to pub.dev by running the following command:
```bash
flutter pub publish
```
## Release
