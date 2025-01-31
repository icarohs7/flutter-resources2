import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('baseUrlFrom', () {
    test('should extract base URL from https URL', () {
      expect(baseUrlFrom('https://github.com/api'), equals('github.com'));
    });

    test('should extract base URL from http URL', () {
      expect(baseUrlFrom('http://github.com/api'), equals('github.com'));
    });

    test('should handle URLs without protocol', () {
      expect(baseUrlFrom('github.com/api'), equals('github.com'));
    });

    test('should handle URLs without path', () {
      expect(baseUrlFrom('https://github.com'), equals('github.com'));
    });

    test('should handle empty URL', () {
      expect(baseUrlFrom(''), equals(''));
    });
  });
}
