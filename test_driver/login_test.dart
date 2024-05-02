import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Created by Chandan Jana on 28-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

void main() {
  group('Login Screen ', () {
    final loginButtonFinder = find.byValueKey('login');
    final usernameFieldFinder = find.byValueKey('email');
    final passwordFieldFinder = find.byValueKey('password');
    final forgetPasswordFieldFinder = find.byValueKey('forget_password');

    FlutterDriver? driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });
    test('Login with empty credentials', () async {
      // Enter invalid username
      await driver?.tap(usernameFieldFinder);
      await driver?.enterText('');
      await Future.delayed(const Duration(milliseconds: 800));
      // Enter invalid password
      await driver?.tap(passwordFieldFinder);
      await driver?.enterText('');
      await Future.delayed(const Duration(milliseconds: 800));
      // Tap login button
      await driver?.tap(loginButtonFinder);

      // Wait for error message or check for appropriate behavior
      // Add appropriate checks/assertions here
    });

    test('Invalid email format', () async {
      // Enter invalid username
      await driver?.tap(usernameFieldFinder);
      await driver?.enterText('ajay');
      await Future.delayed(const Duration(milliseconds: 800));
      // Enter invalid password
      await driver?.tap(passwordFieldFinder);
      await driver?.enterText('');
      await Future.delayed(const Duration(milliseconds: 800));
      // Tap login button
      await driver?.tap(loginButtonFinder);

      // Wait for error message or check for appropriate behavior
      // Add appropriate checks/assertions here
    });

    test('Invalid password length', () async {
      // Enter invalid username
      await driver?.tap(usernameFieldFinder);
      await driver?.enterText('aretra.saha@mindteck.com');
      await Future.delayed(const Duration(milliseconds: 800));
      // Enter invalid password
      await driver?.tap(passwordFieldFinder);
      await driver?.enterText('123');
      await Future.delayed(const Duration(milliseconds: 800));
      // Tap login button
      await driver?.tap(loginButtonFinder);

      // Wait for error message or check for appropriate behavior
      // Add appropriate checks/assertions here
    });

    test('Login and Navigate to Main Screen', () async {
      // Find the email and password input fields and login button
      final emailField = find.byValueKey('email');
      final passwordField = find.byValueKey('password');
      final loginButton = find.byValueKey('login');
      await Future.delayed(Duration(milliseconds: 800));
      // Enter credentials
      await driver?.tap(emailField);
      await driver?.enterText('aretra.saha@mindteck.com');
      await driver?.waitFor(find.text('aretra.saha@mindteck.com'));
      await Future.delayed(Duration(milliseconds: 800));
      await driver?.tap(passwordField);
      await driver?.enterText('Mindteck@1234');
      await driver?.waitFor(find.text('Mindteck@1234'));
      await Future.delayed(Duration(milliseconds: 800));
      // Tap on the login button
      await driver?.tap(loginButton);

      // Wait for main screen elements to verify navigation
      final mainScreenTitle = find.text('Dashboard');
      await driver?.waitFor(mainScreenTitle);

      // Verify navigation to the main screen
      expect(await driver?.getText(mainScreenTitle), 'Dashboard');
    });

    test('Scroll Content', () async {
      // Find a scrollable widget. For example, you might find a ListView, SingleChildScrollView, or a ListView.builder.
      final scrollableFinder =
          find.byValueKey('system_screen'); // Adjust this according to your app

      // Scroll by dragging from one location to another.
      // Here, we scroll from the bottom to the top of the widget.
      // Scroll the content down.
      await driver?.scroll(
          scrollableFinder, 0, -500, const Duration(milliseconds: 800));

      // Wait for the scroll to complete.
      //await Future.delayed(Duration(seconds: 500));

      // Scroll the content up.
      await driver?.scroll(
        scrollableFinder,
        0, // dx
        500, // dy (positive for scrolling down)
        const Duration(milliseconds: 800),
      );
    });

    test('Open Navigation Drawer and Dismiss', () async {
      // Find the leading icon by its semantic label.
      final leadingIcon = find.byValueKey('main_menu');
      await Future.delayed(const Duration(milliseconds: 800));
      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(leadingIcon);

      // Wait for the drawer to fully open.
      await Future.delayed(const Duration(milliseconds: 800));

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );

      //await driver?.shellExec('input', ['keyevent', 'KEYCODE_BACK']);
      //await driver?.waitFor(find.byValueKey(Keys.backButton), timeout: Duration(seconds: 5));

      // Find an element inside the navigation drawer to verify it's open.
      final drawerText =
          find.text('Dashboard'); // Change to actual drawer item text

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(drawerText);

      // Verify that the drawer is open by finding an element inside it.
      expect(await driver?.getText(drawerText), 'Dashboard');

      //final backBtn = find.byTooltip('Back');
      // Wait for back button elements to verify navigation
      //await driver?.waitFor(backBtn);
      // Simulate pressing the system back button to close the drawer.
      //await driver?.tap(backBtn);
      //await driver?.tap(find.pageBack());
      //await driver?.tap(Offset(50, 50));

      // Wait for the drawer to close.
      //await Future.delayed(const Duration(seconds: 1));

      //find.pageBack();
    });

    /*test('IconButton find and tap test', () async {
      var findIconButton = find.descendant(of: find.byType("Drawer"), matching: find.byType("IconButton"), firstMatchOnly: true);
      await driver?.waitFor(findIconButton);
      await driver?.tap(findIconButton);

      await Future.delayed(Duration(seconds: 3));
    });*/

    test('Click Drawer Item and Dismiss', () async {
      // Find the leading icon by its semantic label.
      final leadingIcon = find.byValueKey('main_menu');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(leadingIcon);

      // Find the leading icon by its semantic label.
      final deviceIcon = find.text('Device');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(deviceIcon);

      // Wait for main screen elements to verify navigation
      final deviceScreenTitle = find.text('Device');
      await driver?.waitFor(deviceScreenTitle);

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(deviceScreenTitle);

      // Verify navigation to the main screen
      expect(await driver?.getText(deviceScreenTitle), 'Device');
      // Wait for the drawer to fully open.
      await Future.delayed(const Duration(seconds: 1));

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );

      // Find an element inside the navigation drawer to verify it's open.
      final drawerText =
          find.text('Dashboard'); // Change to actual drawer item text

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(drawerText);

      // Verify that the drawer is open by finding an element inside it.
      expect(await driver?.getText(drawerText), 'Dashboard');

      await Future.delayed(const Duration(seconds: 1));

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(leadingIcon);

      // Find the leading icon by its semantic label.
      final siteIcon = find.text('Sites');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(siteIcon);

      // Wait for main screen elements to verify navigation
      final siteScreenTitle = find.text('Sites');
      await driver?.waitFor(siteScreenTitle);

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(siteScreenTitle);

      // Verify navigation to the main screen
      expect(await driver?.getText(siteScreenTitle), 'Sites');
      // Wait for the drawer to fully open.
      await Future.delayed(const Duration(seconds: 1));

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(drawerText);

      // Verify that the drawer is open by finding an element inside it.
      expect(await driver?.getText(drawerText), 'Dashboard');

      await Future.delayed(const Duration(seconds: 1));

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(leadingIcon);

      // Find the leading icon by its semantic label.
      final applicationIcon = find.text('Application');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(applicationIcon);

      // Wait for main screen elements to verify navigation
      final applicationScreenTitle = find.text('Application');
      await driver?.waitFor(applicationScreenTitle);

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(applicationScreenTitle);

      // Verify navigation to the main screen
      expect(await driver?.getText(applicationScreenTitle), 'Application');
      // Wait for the drawer to fully open.
      await Future.delayed(const Duration(seconds: 1));

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(drawerText);

      // Verify that the drawer is open by finding an element inside it.
      expect(await driver?.getText(drawerText), 'Dashboard');

      await Future.delayed(const Duration(seconds: 1));

      final moreIcon = find.byValueKey('more_option');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(moreIcon);

      await Future.delayed(const Duration(seconds: 1));

      // Find the leading icon by its semantic label.
      final logoutIcon = find.text('Logout');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(logoutIcon);

      // Verify navigation to the main screen
      expect(await driver?.getText(logoutIcon), 'Logout');

      await Future.delayed(const Duration(seconds: 1));

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );
      // Find the leading icon by its semantic label.
      final themeIcon = find.byValueKey('theme_change');
      //final leadingIcon = find.byTooltip('Open navigation menu');

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(themeIcon);

      // Tap on the leading icon to open the navigation drawer.
      await driver?.tap(moreIcon);

      await Future.delayed(const Duration(seconds: 1));

      // Wait for main screen elements to verify navigation
      await driver?.waitFor(logoutIcon);

      // Verify navigation to the main screen
      expect(await driver?.getText(logoutIcon), 'Logout');

      await Process.run(
        'adb',
        <String>['shell', 'input', 'keyevent', 'KEYCODE_BACK'],
        runInShell: true,
      );

      await Future.delayed(const Duration(seconds: 1));
    });
  });
}
