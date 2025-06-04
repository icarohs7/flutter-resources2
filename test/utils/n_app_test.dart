import 'package:flutter/foundation.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NApp', () {
    test('returns Android when platform is Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final result = NApp.os;

      expect(result, NOS.Android);
    });

    test('returns IOS when platform is IOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      final result = NApp.os;

      expect(result, NOS.IOS);
    });

    test('returns Windows when platform is Windows', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      final result = NApp.os;

      expect(result, NOS.Windows);
    });

    test('returns MacOS when platform is MacOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      final result = NApp.os;

      expect(result, NOS.MacOS);
    });

    test('returns Linux when platform is Linux', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      final result = NApp.os;

      expect(result, NOS.Linux);
    });

    test('returns Unknown when platform is Fuchsia', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

      final result = NApp.os;

      expect(result, NOS.Fuchsia);
    });

    test('returns Unknown when platform is unknown', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      final result = NApp.os;

      expect(result, NOS.Unknown);
    });
  });
}
