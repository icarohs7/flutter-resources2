import 'dart:async';

import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Box<String>>(onMissingStub: OnMissingStub.returnDefault)])
import 'secure_persisted_field_test.mocks.dart';

void main() {
  late MockBox mockSafeBox;

  setUp(() async {
    mockSafeBox = MockBox();
    await NSecurePersistedField.init(mockSafeBox);
  });

  group('SecurePersistedFieldString', () {
    test('get() returns default when no value stored', () async {
      when(mockSafeBox.get('key')).thenReturn(null);
      final field = NSecurePersistedFieldString(key: 'key', defaultValue: 'def');
      expect(field.get(), 'def');
    });

    test('set/get works with serialization', () async {
      when(mockSafeBox.put('k', 'v')).thenAnswer((_) async {});
      when(mockSafeBox.get('k')).thenReturn('v');

      final field = NSecurePersistedFieldString(key: 'k');
      await field.set('v');
      verify(mockSafeBox.put('k', 'v')).called(1);
      expect(field.get(), 'v');
    });

    test('clear deletes key', () async {
      when(mockSafeBox.delete('k2')).thenAnswer((_) async {});
      final field = NSecurePersistedFieldString(key: 'k2');
      await field.clear();
      verify(mockSafeBox.delete('k2')).called(1);
    });

    test('listenable updates from watch', () async {
      final controller = StreamController<BoxEvent>.broadcast();
      addTearDown(() async => controller.close());

      when(mockSafeBox.get('live')).thenReturn('x');
      when(mockSafeBox.watch(key: 'live')).thenAnswer((_) => controller.stream);

      final field = NSecurePersistedFieldString(key: 'live');
      listener() {}
      field.listenable.addListener(listener);
      addTearDown(() async => field.listenable.removeListener(listener));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(field(), 'x');

      when(mockSafeBox.get('live')).thenReturn('y');
      controller.add(BoxEvent('live', 'y', false));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(field(), 'y');
    });
  });

  group('Typed helpers serialize/deserialize', () {
    test('int', () async {
      when(mockSafeBox.get('i')).thenReturn('10');
      final f = NSecurePersistedFieldInt(key: 'i');
      expect(f.get(), 10);
      when(mockSafeBox.put('i', '3')).thenAnswer((_) async {});
      await f.set(3);
      verify(mockSafeBox.put('i', '3')).called(1);
    });

    test('double', () async {
      when(mockSafeBox.get('d')).thenReturn('1.5');
      final f = NSecurePersistedFieldDouble(key: 'd');
      expect(f.get(), 1.5);
    });

    test('bool', () async {
      when(mockSafeBox.get('b')).thenReturn('false');
      final f = NSecurePersistedFieldBool(key: 'b');
      expect(f.get(), false);
      when(mockSafeBox.put('b', 'true')).thenAnswer((_) async {});
      await f.set(true);
      verify(mockSafeBox.put('b', 'true')).called(1);
    });
  });
}
