import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HtmlRenderExtension', () {
    test('htmlUnescaped should convert HTML entities to their corresponding characters', () {
      expect('&lt;div&gt;Hello&lt;/div&gt;'.htmlUnescaped, '<div>Hello</div>');
    });

    test('htmlUnescaped should return the same string if there are no HTML entities', () {
      expect('Hello World'.htmlUnescaped, 'Hello World');
    });

    test('htmlUnescaped should handle empty strings', () {
      expect(''.htmlUnescaped, '');
    });

    test('htmlUnescaped should handle strings with only HTML entities', () {
      expect('&amp;&lt;&gt;'.htmlUnescaped, '&<>');
    });

    test('htmlUnescaped should handle strings with mixed content', () {
      expect('Hello &amp; Welcome to &lt;Dart&gt;'.htmlUnescaped, 'Hello & Welcome to <Dart>');
    });
  });
}
