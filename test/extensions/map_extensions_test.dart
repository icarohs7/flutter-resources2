
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NMapExtensions', () {
    test('getValues yields correct values for existing keys', () {
      var map = {'a': 1, 'b': 2, 'c': 3};
      var keys = ['a', 'b'];
      expect(map.getValues(keys), equals([1, 2]));
    });

    test('getValues ignores non-existent keys', () {
      var map = {'a': 1, 'b': 2, 'c': 3};
      var keys = ['a', 'd'];
      expect(map.getValues(keys), equals([1]));
    });

    test('getValues works with empty keys', () {
      var map = {'a': 1, 'b': 2, 'c': 3};
      var keys = <String>[];
      expect(map.getValues(keys), isEmpty);
    });

    test('getValues works with an empty map', () {
      var map = <String, int>{};
      var keys = ['a', 'b'];
      expect(map.getValues(keys), isEmpty);
    });

    test('getValues handles mixed type keys', () {
      var map = {1: 'one', 'two': 2, true: 'bool'};
      var keys = [1, 'two', false];
      expect(map.getValues(keys), equals(['one', 2]));
    });
  });
}