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

import 'package:flutter_flavorizr/src/parser/models/flavorizr.dart';
import 'package:flutter_flavorizr/src/parser/parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Flavorizr flavorizr;

  test('Test processor exclusion with exact match', () {
    Parser parser = const Parser(
      pubspecPath:
          'test_resources/processor_exclusion_test/pubspec_with_exact_exclusion',
      flavorizrPath: 'test_resources/non_existent',
    );

    try {
      flavorizr = parser.parse();
    } catch (e) {
      fail(e.toString());
    }

    expect(flavorizr.excludeInstructions, isNotNull);
    expect(flavorizr.excludeInstructions, contains('flutter:main'));
    expect(flavorizr.excludeInstructions, contains('flutter:flavors'));
  });

  test('Test processor exclusion with glob patterns', () {
    Parser parser = const Parser(
      pubspecPath:
          'test_resources/processor_exclusion_test/pubspec_with_glob_exclusion',
      flavorizrPath: 'test_resources/non_existent',
    );

    try {
      flavorizr = parser.parse();
    } catch (e) {
      fail(e.toString());
    }

    expect(flavorizr.excludeInstructions, isNotNull);
    expect(flavorizr.excludeInstructions, contains('*:icons'));
    expect(flavorizr.excludeInstructions, contains('flutter:*'));
    expect(flavorizr.excludeInstructions, contains('*:dummyAssets'));
  });

  test('Test processor exclusion without exclusion list', () {
    Parser parser = const Parser(
      pubspecPath: 'test_resources/pubspec',
      flavorizrPath: 'test_resources/non_existent',
    );

    try {
      flavorizr = parser.parse();
    } catch (e) {
      fail(e.toString());
    }

    expect(flavorizr.excludeInstructions, isNull);
  });

  test(
      'Test that both instructions and excludeInstructions can be parsed (validation happens at execution)',
      () {
    Parser parser = const Parser(
      pubspecPath:
          'test_resources/processor_exclusion_test/pubspec_with_both_instructions_and_exclusions',
      flavorizrPath: 'test_resources/non_existent',
    );

    try {
      flavorizr = parser.parse();
    } catch (e) {
      fail(e.toString());
    }

    // Both should be present (parsing allows it, execution will validate)
    expect(flavorizr.instructions, isNotNull);
    expect(flavorizr.instructions, isNotEmpty);
    expect(flavorizr.excludeInstructions, isNotNull);
    expect(flavorizr.excludeInstructions, isNotEmpty);
  });
}
