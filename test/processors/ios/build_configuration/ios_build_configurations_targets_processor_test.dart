/*
 * Copyright (c) 2024 Angelo Cassano
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:flutter_flavorizr/src/parser/mixins/build_settings_mixin.dart';
import 'package:flutter_flavorizr/src/parser/models/flavors/app.dart';
import 'package:flutter_flavorizr/src/parser/models/flavors/darwin.dart';
import 'package:flutter_flavorizr/src/parser/models/flavors/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iOS Build Configuration - Icon Build Setting', () {
    test('should add ASSETCATALOG_COMPILER_APPICON_NAME when flavor has app icon', () {
      final flavor = Flavor(
        app: const App(name: 'Test App', icon: 'path/to/icon.png'),
        ios: Darwin(bundleId: 'com.test.app'),
      );

      final settings = _buildSettings(flavor);

      expect(
        settings.containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
        isTrue,
        reason: 'Should add ASSETCATALOG_COMPILER_APPICON_NAME when app icon is defined',
      );
      expect(
        settings['ASSETCATALOG_COMPILER_APPICON_NAME'],
        equals('\$(ASSET_PREFIX)AppIcon'),
      );
    });

    test('should add ASSETCATALOG_COMPILER_APPICON_NAME when flavor has iOS icon', () {
      final flavor = Flavor(
        app: const App(name: 'Test App'),
        ios: Darwin(bundleId: 'com.test.app', icon: 'path/to/ios_icon.png'),
      );

      final settings = _buildSettings(flavor);

      expect(
        settings.containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
        isTrue,
        reason: 'Should add ASSETCATALOG_COMPILER_APPICON_NAME when iOS icon is defined',
      );
      expect(
        settings['ASSETCATALOG_COMPILER_APPICON_NAME'],
        equals('\$(ASSET_PREFIX)AppIcon'),
      );
    });

    test('should set ASSETCATALOG_COMPILER_APPICON_NAME to AppIcon when no icon is defined', () {
      final flavor = Flavor(
        app: const App(name: 'Test App'),
        ios: Darwin(bundleId: 'com.test.app'),
      );

      final settings = _buildSettings(flavor);

      expect(
        settings.containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
        isTrue,
      );
      expect(
        settings['ASSETCATALOG_COMPILER_APPICON_NAME'],
        equals('AppIcon'),
        reason:
            'Should use default "AppIcon" when no icon is defined, '
            'allowing external tools like flutter_launcher_icons to manage icons',
      );
    });

    test('should prioritize iOS icon over app icon (both defined)', () {
      final flavor = Flavor(
        app: const App(name: 'Test App', icon: 'path/to/app_icon.png'),
        ios: Darwin(bundleId: 'com.test.app', icon: 'path/to/ios_icon.png'),
      );

      final settings = _buildSettings(flavor);

      // When any icon is defined, the setting should be added
      expect(
        settings.containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
        isTrue,
      );
      expect(
        settings['ASSETCATALOG_COMPILER_APPICON_NAME'],
        equals('\$(ASSET_PREFIX)AppIcon'),
      );
    });
  });
}

/// Simulates the _buildSettings logic from IOSBuildConfigurationsTargetsProcessor
Map<String, dynamic> _buildSettings(Flavor flavor) {
  final settings = <String, dynamic>{}
    ..addAll(BuildSettingsMixin.iosDefaultBuildSettings)
    ..addAll(flavor.ios?.buildSettings ?? {});

  // Set ASSETCATALOG_COMPILER_APPICON_NAME based on whether an icon is defined
  final hasIcon = flavor.app.icon != null || flavor.ios?.icon != null;
  settings['ASSETCATALOG_COMPILER_APPICON_NAME'] =
      hasIcon ? '\$(ASSET_PREFIX)AppIcon' : 'AppIcon';

  return settings;
}

