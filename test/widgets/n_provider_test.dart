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
        NProvider<MockDisposable>(instance: instance, builder: (context) => Container()),
      );

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('calls dispose callback on dispose', (WidgetTester tester) async {
      final instance = MockDisposable();
      var disposed = false;

      await tester.pumpWidget(
        NProvider<MockDisposable>(
          instance: instance,
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
        NProvider<MockDisposable>(instance: instance, builder: (context) => Container()),
      );

      await tester.pumpWidget(Container());

      verify(instance.onDispose).called(1);
    });
  });
}
