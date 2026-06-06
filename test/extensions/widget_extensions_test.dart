import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NWidgetExtensions', () {
    const child = Text('child');

    group('withPadding', () {
      test('wraps widget in Padding with all insets', () {
        final result = child.withPadding(all: 8);

        expect(result, isA<Padding>());
        expect((result as Padding).padding, const EdgeInsets.all(8));
        expect(result.child, child);
      });

      test('wraps widget in Padding with individual insets', () {
        final result = child.withPadding(top: 1, right: 2, bottom: 3, left: 4);

        expect(
          (result as Padding).padding,
          const EdgeInsets.only(top: 1, right: 2, bottom: 3, left: 4),
        );
      });

      test('wraps widget in Padding with symmetric insets', () {
        final result = child.withPadding(vertical: 10, horizontal: 20);

        expect(
          (result as Padding).padding,
          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        );
      });

      test('prefers all over other padding parameters', () {
        final result = child.withPadding(all: 5, top: 1, vertical: 10);

        expect((result as Padding).padding, const EdgeInsets.all(5));
      });
    });

    group('withSliverPadding', () {
      test('wraps widget in SliverPadding with all insets', () {
        final result = child.withSliverPadding(all: 8);

        expect(result, isA<SliverPadding>());
        expect((result as SliverPadding).padding, const EdgeInsets.all(8));
        expect(result.child, child);
      });

      test('wraps widget in SliverPadding with individual insets', () {
        final result = child.withSliverPadding(top: 4, left: 6);

        expect(
          (result as SliverPadding).padding,
          const EdgeInsets.only(top: 4, right: 0, bottom: 0, left: 6),
        );
      });

      test('wraps widget in SliverPadding with symmetric insets', () {
        final result = child.withSliverPadding(vertical: 12, horizontal: 16);

        expect(
          (result as SliverPadding).padding,
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        );
      });
    });

    group('toSliver', () {
      test('wraps widget in SliverToBoxAdapter', () {
        final result = child.toSliver();

        expect(result, isA<SliverToBoxAdapter>());
        expect(result.child, child);
      });

      testWidgets('renders inside CustomScrollView', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: CustomScrollView(slivers: [const Text('hello').toSliver()])),
        );

        expect(find.text('hello'), findsOneWidget);
      });
    });
  });
}
