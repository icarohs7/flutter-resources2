import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('notNullListFrom', () {
    test('returns a list with non-null items', () {
      final items = [1, null, 2, null, 3];
      final result = notNullListFrom(items);
      expect(result, [1, 2, 3]);
    });

    test('returns an empty list when all items are null', () {
      final items = [null, null, null];
      final result = notNullListFrom(items);
      expect(result, []);
    });

    test('returns an empty list when input is empty', () {
      final items = <int?>[];
      final result = notNullListFrom(items);
      expect(result, []);
    });

    test('returns the same list when there are no null items', () {
      final items = [1, 2, 3];
      final result = notNullListFrom(items);
      expect(result, [1, 2, 3]);
    });
  });
}
