import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisposeAware', () {
    testWidgets('calls onDispose when disposed', (WidgetTester tester) async {
      bool disposed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: DisposeAware(
            onDispose: () => disposed = true,
            child: Container(),
          ),
        ),
      );

      expect(disposed, isFalse);
      await tester.pumpWidget(Container());
      expect(disposed, isTrue);
    });

    testWidgets('renders child widget', (WidgetTester tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        MaterialApp(
          home: DisposeAware(
            onDispose: () {},
            child: Container(key: childKey),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
