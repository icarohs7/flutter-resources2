import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  group('ExtendedImageUtils', () {
    test('switchProvider returns whenTrue when condition is true', () {
      final whenTrue = AssetImage('assets/true.png');
      final whenFalse = AssetImage('assets/false.png');
      final result = ExtendedImageUtils.switchProvider(true, whenTrue, whenFalse);
      expect(result, equals(whenTrue));
    });

    test('switchProvider returns whenFalse when condition is false', () {
      final whenTrue = AssetImage('assets/true.png');
      final whenFalse = AssetImage('assets/false.png');
      final result = ExtendedImageUtils.switchProvider(false, whenTrue, whenFalse);
      expect(result, equals(whenFalse));
    });
  });
}
