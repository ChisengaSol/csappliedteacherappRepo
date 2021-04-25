// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Nearby Teacher Finder', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailFinder = find.byValueKey('userEmail');
    final passwordFinder = find.byValueKey('password');
    final loginButtonFinder = find.byValueKey('Login');
    final subjectsFinder = find.byValueKey('subjectsKey"');
    final teachersFinder = find.byValueKey('teachersKey');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Login', () async {
      await driver.tap(emailFinder);
      await driver.enterText("njwaki@gmail.com");

      await driver.tap(passwordFinder);
      await driver.enterText("njwaki1234");

      await driver.tap(loginButtonFinder);
      await driver.waitFor(find.text("search for subject"));

      // await driver.tap(subjectsFinder);
      // await driver.waitFor(find.text("Available teachers..."));

      // await driver.tap(teachersFinder);
      // await driver.waitFor(find.text("About"));
      
    });
  });
}
