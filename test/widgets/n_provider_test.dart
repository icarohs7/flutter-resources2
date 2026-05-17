import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDisposable extends Mock implements Disposable {}

void main() {
  group('NProvider', () {
    testWidgets('builds with provided instance', (WidgetTester tester) async {
      final instance = MockDisposable();
      await tester.pumpWidget(
        NProvider<MockDisposable>(
          instanceFactory: () => instance,
          builder: (context) => Container(),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('calls dispose callback on dispose', (WidgetTester tester) async {
      final instance = MockDisposable();
      var disposed = false;

      await tester.pumpWidget(
        NProvider<MockDisposable>(
          instanceFactory: () => instance,
          dispose: (value) => disposed = true,
          builder: (context) => Container(),
        ),
      );

      await tester.pumpWidget(Container());

      expect(disposed, isTrue);
    });

    testWidgets('calls onDispose if instance is Disposable', (WidgetTester tester) async {
      final instance = MockDisposable();

      await tester.pumpWidget(
        NProvider<MockDisposable>(
          instanceFactory: () => instance,
          builder: (context) => Container(),
        ),
      );

      await tester.pumpWidget(Container());

      verify(instance.onDispose).called(1);
    });

    testWidgets('recreates instance when keys change and disposes old one', (
      WidgetTester tester,
    ) async {
      final instances = <MockDisposable>[];
      var key = 0;

      Widget build() {
        return NProvider<MockDisposable>(
          instanceFactory: () {
            final instance = MockDisposable();
            instances.add(instance);
            return instance;
          },
          keys: [key],
          builder: (context) => Container(),
        );
      }

      await tester.pumpWidget(build());
      expect(instances.length, 1);

      key = 1;
      await tester.pumpWidget(build());
      expect(instances.length, 2);

      verify(instances[0].onDispose).called(1);
      verifyNever(instances[1].onDispose);

      await tester.pumpWidget(Container());
      verify(instances[1].onDispose).called(1);
    });

    testWidgets('does not recreate instance when keys do not change', (WidgetTester tester) async {
      var callCount = 0;
      final instance = MockDisposable();

      Widget build() {
        return NProvider<MockDisposable>(
          instanceFactory: () {
            callCount++;
            return instance;
          },
          builder: (context) => Container(),
        );
      }

      await tester.pumpWidget(build());
      await tester.pumpWidget(build());
      await tester.pumpWidget(build());

      expect(callCount, 1);
    });
  });
}
