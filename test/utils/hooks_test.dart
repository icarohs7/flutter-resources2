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

  group('useCurrentDateTime', () {
    testWidgets('returns current date time initially', (tester) async {
      late DateTime currentTime;
      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            currentTime = useCurrentDateTime();
            return Container();
          },
        ),
      );

      final now = DateTime.now();
      // Allow for a small difference due to execution time
      expect(currentTime.difference(now).inMilliseconds.abs(), lessThan(100));
    });

    testWidgets('updates periodically', (tester) async {
      DateTime? time1;
      DateTime? time2;

      await tester.runAsync(() async {
        await tester.pumpWidget(
          HookBuilder(
            builder: (context) {
              final time = useCurrentDateTime(interval: const Duration(milliseconds: 100));
              time1 ??= time;
              time2 = time;
              return Container();
            },
          ),
        );

        expect(time1, isNotNull);
        expect(time2, equals(time1));

        await Future.delayed(const Duration(milliseconds: 150));
        await tester.pump();

        expect(time2!.isAfter(time1!), isTrue);
      });
    });

    testWidgets('updates interval correctly', (tester) async {
      Duration interval = const Duration(milliseconds: 200);
      int rebuildCount = 0;

      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextButton(
                        key: const ValueKey('change-interval'),
                        onPressed: () => setState(() => interval = const Duration(milliseconds: 50)),
                        child: const Text('change'),
                      ),
                      HookBuilder(
                        builder: (context) {
                          useCurrentDateTime(interval: interval);
                          rebuildCount++;
                          return Container();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        final initialRebuilds = rebuildCount;

        await Future.delayed(const Duration(milliseconds: 250));
        await tester.pump();
        expect(rebuildCount, greaterThan(initialRebuilds));

        final countAfterFirstInterval = rebuildCount;

        await tester.tap(find.byKey(const ValueKey('change-interval')));
        await tester.pump();

        await Future.delayed(const Duration(milliseconds: 100));
        await tester.pump();
        expect(rebuildCount, greaterThan(countAfterFirstInterval));
      });
    });

    testWidgets('cancels timer on unmount', (tester) async {
      bool mounted = true;
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextButton(
                        key: const ValueKey('unmount'),
                        onPressed: () => setState(() => mounted = false),
                        child: const Text('unmount'),
                      ),
                      if (mounted)
                        HookBuilder(
                          builder: (context) {
                            useCurrentDateTime(interval: const Duration(milliseconds: 50));
                            return Container();
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const ValueKey('unmount')));
        await tester.pump();

        // If timer wasn't cancelled, it might still try to trigger a rebuild or cause issues
        // Though in tests it's hard to prove it's NOT running without checking internal state
        // but we can at least ensure no errors occur after unmount when time passes.
        await Future.delayed(const Duration(milliseconds: 100));
        await tester.pump();
      });
    });
  });
}
