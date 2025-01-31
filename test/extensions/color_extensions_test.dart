import 'package:flutter/material.dart';
import 'package:flutter_resources2/src/extensions/color_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NColorExtensions', () {
    test('rgba returns correct 32-bit value', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      expect(color.rgba, 0xFF804020);
    });

    test('rgba handles minimum values', () {
      final color = Color.fromARGB(0, 0, 0, 0);
      expect(color.rgba, 0x00000000);
    });

    test('rgba handles maximum values', () {
      final color = Color.fromARGB(255, 255, 255, 255);
      expect(color.rgba, 0xFFFFFFFF);
    });

    test('withAlphaDecimal sets correct alpha value', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      final newColor = color.withAlphaDecimal(0.5);
      expect(newColor.a * 255, 128);
    });

    test('withAlphaDecimal handles minimum opacity', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      final newColor = color.withAlphaDecimal(0.0);
      expect(newColor.a, 0);
    });

    test('withAlphaDecimal handles maximum opacity', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      final newColor = color.withAlphaDecimal(1.0);
      expect(newColor.a * 255, 255);
    });

    test('withAlphaDecimal throws assertion error for negative opacity', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      expect(() => color.withAlphaDecimal(-0.1), throwsAssertionError);
    });

    test('withAlphaDecimal throws assertion error for opacity greater than 1', () {
      final color = Color.fromARGB(255, 128, 64, 32);
      expect(() => color.withAlphaDecimal(1.1), throwsAssertionError);
    });
  });
}
