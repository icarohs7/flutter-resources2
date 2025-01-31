// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NWrapper equality with default comparison', () {
    final wrapper1 = NWrapper(10);
    final wrapper2 = NWrapper(10);
    final wrapper3 = NWrapper(20);

    expect(wrapper1, equals(wrapper2));
    expect(wrapper1, isNot(equals(wrapper3)));
  });

  test('NWrapper equality with custom comparison', () {
    final wrapper1 = NWrapper('test', equals: (a, b) => a.length == b.length);
    final wrapper2 = NWrapper('abcd', equals: (a, b) => a.length == b.length);
    final wrapper3 = NWrapper('longer');

    expect(wrapper1, equals(wrapper2));
    expect(wrapper1, isNot(equals(wrapper3)));
  });

  test('NWrapper equality with direct type comparison', () {
    final wrapper = NWrapper(10);
    expect(wrapper == 10, isTrue);
    expect(wrapper == 20, isFalse);
  });

  test('NWrapper hashCode matches value hashCode', () {
    final wrapper = NWrapper(42);
    expect(wrapper.hashCode, equals(42.hashCode));
  });
}
