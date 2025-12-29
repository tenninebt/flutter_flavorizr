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

import 'package:flutter_flavorizr/src/processors/processor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pattern Matching Tests', () {
    test('Test exact match pattern', () {
      expect(Processor.matchesPattern('flutter:main', 'flutter:main'), isTrue);
      expect(Processor.matchesPattern('flutter:main', 'flutter:flavors'), isFalse);
      expect(Processor.matchesPattern('ios:xcconfig', 'ios:xcconfig'), isTrue);
    });

    test('Test wildcard prefix pattern', () {
      expect(Processor.matchesPattern('flutter:main', 'flutter:*'), isTrue);
      expect(Processor.matchesPattern('flutter:flavors', 'flutter:*'), isTrue);
      expect(Processor.matchesPattern('flutter:app', 'flutter:*'), isTrue);
      expect(Processor.matchesPattern('ios:xcconfig', 'flutter:*'), isFalse);
    });

    test('Test wildcard suffix pattern', () {
      expect(Processor.matchesPattern('android:icons', '*:icons'), isTrue);
      expect(Processor.matchesPattern('ios:icons', '*:icons'), isTrue);
      expect(Processor.matchesPattern('macos:icons', '*:icons'), isTrue);
      expect(Processor.matchesPattern('android:xcconfig', '*:icons'), isFalse);
    });

    test('Test wildcard both sides pattern', () {
      expect(Processor.matchesPattern('android:dummyAssets', '*:dummyAssets'), isTrue);
      expect(Processor.matchesPattern('ios:dummyAssets', '*:dummyAssets'), isTrue);
      expect(Processor.matchesPattern('macos:dummyAssets', '*:dummyAssets'), isTrue);
      expect(Processor.matchesPattern('android:icons', '*:dummyAssets'), isFalse);
    });

    test('Test complex patterns', () {
      // Test platform wildcard
      expect(Processor.matchesPattern('android:icons', 'android:*'), isTrue);
      expect(Processor.matchesPattern('android:dummyAssets', 'android:*'), isTrue);
      expect(Processor.matchesPattern('ios:icons', 'android:*'), isFalse);
      
      // Test full wildcard
      expect(Processor.matchesPattern('anything:anything', '*'), isTrue);
      expect(Processor.matchesPattern('flutter:main', '*'), isTrue);
    });

    test('Test pattern with special characters in instruction names', () {
      // Test that special regex characters are properly escaped
      expect(Processor.matchesPattern('test:config.file', 'test:config.file'), isTrue);
      expect(Processor.matchesPattern('test:config-file', 'test:config-file'), isTrue);
    });

    test('Test case sensitivity', () {
      // Patterns should be case-sensitive
      expect(Processor.matchesPattern('Flutter:Main', 'flutter:*'), isFalse);
      expect(Processor.matchesPattern('flutter:main', 'Flutter:*'), isFalse);
      expect(Processor.matchesPattern('flutter:main', 'flutter:main'), isTrue);
    });

    test('Test multiple wildcards in pattern', () {
      expect(Processor.matchesPattern('android:google:firebase', 'android:*:*'), isTrue);
      expect(Processor.matchesPattern('android:google', 'android:*:*'), isFalse);
    });

    test('Test empty and null patterns', () {
      expect(Processor.matchesPattern('flutter:main', ''), isFalse);
      expect(Processor.matchesPattern('', 'flutter:main'), isFalse);
      expect(Processor.matchesPattern('', ''), isTrue);
    });
  });
}

