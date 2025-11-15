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
                  return Text(
                    h?.toStringAsFixed(2) ?? 'null',
                    textDirection: TextDirection.ltr,
                  );
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
                    return Text(
                      h?.toStringAsFixed(2) ?? 'null',
                      textDirection: TextDirection.ltr,
                    );
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
}
