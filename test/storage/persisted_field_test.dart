import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Box<String>>(onMissingStub: OnMissingStub.returnDefault)])
import 'persisted_field_test.mocks.dart';

void main() {
  late MockBox mockUnsafeBox;

  setUp(() async {
    mockUnsafeBox = MockBox();
    await NPersistedField.init(mockUnsafeBox);
  });

  group('PersistedFieldString', () {
    test('get() returns default when no value stored', () async {
      when(mockUnsafeBox.get('key')).thenReturn(null);

      final field = NPersistedFieldString(key: 'key', defaultValue: 'default');

      expect(field.get(), 'default');
    });

    test('set() serializes and writes to box; get() reads it back', () async {
      when(mockUnsafeBox.put('key', 'hello')).thenAnswer((_) async {});
      when(mockUnsafeBox.get('key')).thenReturn('hello');

      final field = NPersistedFieldString(key: 'key');

      await field.set('hello');
      verify(mockUnsafeBox.put('key', 'hello')).called(1);
      expect(field.get(), 'hello');
    });

    test('clear() deletes the key', () async {
      when(mockUnsafeBox.delete('key')).thenAnswer((_) async {});

      final field = NPersistedFieldString(key: 'key');

      await field.clear();
      verify(mockUnsafeBox.delete('key')).called(1);
    });

    test('listenable updates when box.watch emits events', () async {
      final controller = StreamController<BoxEvent>.broadcast();
      addTearDown(() async => controller.close());

      // Seed value
      when(mockUnsafeBox.get('live')).thenReturn('a');
      when(mockUnsafeBox.watch(key: 'live')).thenAnswer((_) => controller.stream);

      final field = NPersistedFieldString(key: 'live');
      listener() {}
      field.listenable.addListener(listener);
      addTearDown(() async => field.listenable.removeListener(listener));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      // initial seeded value via shareValueSeeded
      expect(field(), 'a');

      // Change underlying value and emit a watch event
      when(mockUnsafeBox.get('live')).thenReturn('b');
      controller.add(BoxEvent('live', 'b', false));

      // Allow the stream microtask to propagate
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(field(), 'b');
    });
  });

  group('Typed helpers serialize/deserialize', () {
    test('int field uses tryParse with default fallback', () async {
      when(mockUnsafeBox.get('i')).thenReturn(null);
      final intField = NPersistedFieldInt(key: 'i', defaultValue: 7);
      expect(intField.get(), 7);

      when(mockUnsafeBox.get('i')).thenReturn('42');
      expect(intField.get(), 42);

      when(mockUnsafeBox.put('i', '5')).thenAnswer((_) async {});
      await intField.set(5);
      verify(mockUnsafeBox.put('i', '5')).called(1);
    });

    test('double field uses tryParse with default fallback', () async {
      when(mockUnsafeBox.get('d')).thenReturn(null);
      final doubleField = NPersistedFieldDouble(key: 'd', defaultValue: 3.5);
      expect(doubleField.get(), 3.5);

      when(mockUnsafeBox.get('d')).thenReturn('2.25');
      expect(doubleField.get(), 2.25);
    });

    test('bool field serializes to string true/false', () async {
      when(mockUnsafeBox.get('b')).thenReturn('true');
      final boolField = NPersistedFieldBool(key: 'b');
      expect(boolField.get(), true);

      when(mockUnsafeBox.put('b', 'false')).thenAnswer((_) async {});
      await boolField.set(false);
      verify(mockUnsafeBox.put('b', 'false')).called(1);
    });
  });
}
