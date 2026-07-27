import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NException.eventId', () {
    test('is null by default', () {
      final exception = NException('test');

      expect(exception.eventId, isNull);
    });

    test('can be set via constructor', () {
      final exception = NException('test', null, null, 'evt-1');

      expect(exception.eventId, 'evt-1');
    });

    test('copies eventId from parentError when wrapping', () {
      const parentId = '018e8f2a-7b3c-7f4a-9c1d-2a3b4c5d6e7f';
      final parent = NException('root', null, null, parentId);
      final wrapped = NException('wrapped', parent);

      expect(wrapped.eventId, parentId);
    });

    test('equality includes eventId', () {
      const stack = StackTrace.empty;
      expect(
        NException('a', null, stack, 'evt-1'),
        isNot(equals(NException('a', null, stack, 'evt-2'))),
      );
      expect(NException('a', null, stack, 'evt-1'), equals(NException('a', null, stack, 'evt-1')));
    });

    test('round-trips eventId through json', () {
      const stack = StackTrace.empty;
      final original = NException('msg', null, stack, 'evt-json');
      final restored = NException.fromJson(original.toJson());

      expect(restored.eventId, 'evt-json');
      expect(restored.message, original.message);
    });
  });
}
