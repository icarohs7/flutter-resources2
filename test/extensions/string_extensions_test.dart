
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NStringCasingExtension', () {
    test('toTitleCase capitalizes first letter of each word', () {
      expect('hello world'.toTitleCase(), equals('Hello World'));
      expect('the quick brown fox'.toTitleCase(), equals('The Quick Brown Fox'));
    });

    test('toTitleCase handles single word', () {
      expect('hello'.toTitleCase(), equals('Hello'));
    });

    test('toTitleCase with empty string', () {
      expect(''.toTitleCase(), equals(''));
    });

    test('toTitleCase with numbers and symbols', () {
      expect('123 hello world!'.toTitleCase(), equals('123 Hello World!'));
    });

    test('toTitleCase with mixed case', () {
      expect('hELLO wORLD'.toTitleCase(), equals('Hello World'));
    });

    test('toTitleCase with apostrophes and contractions', () {
      expect("she's got it".toTitleCase(), equals("She's Got It"));
      expect("don't worry".toTitleCase(), equals("Don't Worry"));
    });
  });

  group('NStringExtensions', () {
    test('isNumericOnly returns true for numeric strings', () {
      expect('123456'.isNumericOnly, isTrue);
    });

    test('isNumericOnly returns false for non-numeric strings', () {
      expect('123abc'.isNumericOnly, isFalse);
    });

    test('isNumericOnly returns false for empty string', () {
      expect(''.isNumericOnly, isFalse);
    });

    test('isNumericOnly returns false for strings with spaces', () {
      expect('123 456'.isNumericOnly, isFalse);
    });

    test('hasMatch returns true for matching pattern', () {
      expect('hello world'.hasMatch(r'hello'), isTrue);
    });

    test('hasMatch returns false for non-matching pattern', () {
      expect('hello world'.hasMatch(r'goodbye'), isFalse);
    });

    test('hasMatch returns true for empty pattern', () {
      expect('hello world'.hasMatch(r''), isTrue);
    });

    test('hasMatch returns true for pattern matching entire string', () {
      expect('hello world'.hasMatch(r'^hello world$'), isTrue);
    });
  });
}