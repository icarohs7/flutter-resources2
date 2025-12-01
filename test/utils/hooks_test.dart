import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('useAspectRatioHeight', () {
    testWidgets('computes height from width for 16:9 ratio', (tester) async {
      const boxWidth = 160.0; // expected height = 160 * 9 / 16 = 90

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: boxWidth,
              child: HookBuilder(
                builder: (context) {
                  final h = useAspectRatioHeight(16, 9);
                  return Text(h?.toStringAsFixed(2) ?? 'null', textDirection: TextDirection.ltr);
                },
              ),
            ),
          ),
        ),
      );

      // Allow layout to complete.
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.text('90.00'), findsOneWidget);
    });

    testWidgets('recomputes when width changes', (tester) async {
      Future<void> pumpWithWidth(double width) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: width,
                child: HookBuilder(
                  builder: (context) {
                    final h = useAspectRatioHeight(4, 3); // height = width * 3 / 4
                    return Text(h?.toStringAsFixed(2) ?? 'null', textDirection: TextDirection.ltr);
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await pumpWithWidth(200);
      expect(find.text('150.00'), findsOneWidget);

      await pumpWithWidth(120);
      expect(find.text('90.00'), findsOneWidget);
    });
  });

  group('useOnNextFrame', () {
    testWidgets('runs callback on the next frame after build', (tester) async {
      var called = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (_) {
              useOnNextFrame(() {
                called++;
              });
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // In widget tests, pumpWidget already pumps a frame, so the callback
      // scheduled via addPostFrameCallback may have run by now.
      expect(called, 1);

      // Additional pump should not re-run the callback without a new schedule.
      await tester.pump();
      expect(called, 1);
    });

    testWidgets('re-schedules when dependency changes', (tester) async {
      var called = 0;
      int dep = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  TextButton(
                    key: const ValueKey('inc-dep'),
                    onPressed: () => setState(() => dep++),
                    child: const Text('inc'),
                  ),
                  HookBuilder(
                    builder: (_) {
                      useOnNextFrame(() {
                        called++;
                      }, [dep]);
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );

      // First scheduling likely executed during pumpWidget's implicit frame.
      expect(called, 1);

      // Change dependency -> schedules again.
      await tester.tap(find.byKey(const ValueKey('inc-dep')));
      await tester.pump();
      expect(called, 2);
    });

    testWidgets('does not re-schedule if dependency stays the same on rebuild', (tester) async {
      var called = 0;
      int dep = 0;
      bool dummy = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  TextButton(
                    key: const ValueKey('rebuild'),
                    onPressed: () => setState(() => dummy = !dummy),
                    child: const Text('rebuild'),
                  ),
                  HookBuilder(
                    builder: (_) {
                      useOnNextFrame(() {
                        called++;
                      }, [dep]);
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Initial schedule
      await tester.pump();
      expect(called, 1);

      // Rebuild without changing dependency -> should NOT schedule again
      await tester.tap(find.byKey(const ValueKey('rebuild')));
      await tester.pump();
      expect(called, 1);
    });
  });
}
