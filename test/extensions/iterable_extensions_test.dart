import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NIterableExtensions', () {
    test('operator [] works correctly', () {
      var list = [1, 2, 3, 4];
      expect(list[0], equals(1));
      expect(list[3], equals(4));
      expect(() => list[4], throwsRangeError);
    });
  });

  group('NNullableIterableExtensions', () {
    test('orEmpty returns an empty iterable if null', () {
      Iterable<int>? nullIterable;
      expect(nullIterable.orEmpty(), isEmpty);
    });

    test('orEmpty returns the iterable if not null', () {
      Iterable<int> someList = [1, 2, 3];
      expect(someList.orEmpty(), equals(someList));
    });

    test('ifEmpty provides a default when iterable is null', () {
      Iterable<int>? nullIterable;
      expect(nullIterable.ifEmpty(() => [1, 2, 3]), equals([1, 2, 3]));
    });

    test('ifEmpty provides a default when iterable is empty', () {
      Iterable<int> emptyList = [];
      expect(emptyList.ifEmpty(() => [1, 2, 3]), equals([1, 2, 3]));
    });

    test('ifEmpty does not provide default if iterable has items', () {
      Iterable<int> someList = [1, 2, 3];
      expect(someList.ifEmpty(() => [4, 5, 6]), equals(someList));
    });
  });
}
