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
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BuildSettingsMixin', () {
    group('iosDefaultBuildSettings', () {
      test('should NOT contain ASSETCATALOG_COMPILER_APPICON_NAME', () {
        // This setting is NOT in defaults - it's added dynamically in
        // IOSBuildConfigurationsTargetsProcessor when an icon is defined.
        // This allows flutter_launcher_icons or other tools to work by
        // simply not defining an icon field in the flavor config.
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings
              .containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
          isFalse,
          reason:
              'ASSETCATALOG_COMPILER_APPICON_NAME is dynamically added when '
              'an icon is defined, not part of default settings',
        );
      });

      test('should contain required build settings', () {
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings
              .containsKey('LD_RUNPATH_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings
              .containsKey('SWIFT_OBJC_BRIDGING_HEADER'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings.containsKey('SWIFT_VERSION'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings
              .containsKey('FRAMEWORK_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings
              .containsKey('LIBRARY_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.iosDefaultBuildSettings.containsKey('INFOPLIST_FILE'),
          isTrue,
        );
      });
    });

    group('macosDefaultBuildSettings', () {
      test('should NOT contain ASSETCATALOG_COMPILER_APPICON_NAME', () {
        // This setting is NOT in defaults - it's added dynamically in
        // MacOSBuildConfigurationsTargetsProcessor when an icon is defined.
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('ASSETCATALOG_COMPILER_APPICON_NAME'),
          isFalse,
          reason:
              'ASSETCATALOG_COMPILER_APPICON_NAME is dynamically added when '
              'an icon is defined, not part of default settings',
        );
      });

      test('should contain required build settings', () {
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('LD_RUNPATH_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('SWIFT_VERSION'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('FRAMEWORK_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('LIBRARY_SEARCH_PATHS'),
          isTrue,
        );
        expect(
          BuildSettingsMixin.macosDefaultBuildSettings
              .containsKey('INFOPLIST_FILE'),
          isTrue,
        );
      });
    });
  });
}

