import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('showDateTimePicker', () {
    final initialDate = DateTime(2026, 8, 14, 14, 30);
    final firstDate = DateTime(2020, 1, 1);
    final lastDate = DateTime(2030, 12, 31);

    Future<DateTime?>? selected;

    Future<void> openPicker(WidgetTester tester, {Widget? title, DateTime? initial}) async {
      selected = null;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                selected = showDateTimePicker(
                  context: context,
                  title: title,
                  initialDate: initial ?? initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
    }

    Future<DateTime?> closePicker(WidgetTester tester, String action) async {
      await tester.tap(find.text(action));
      await tester.pumpAndSettle();
      return await selected;
    }

    testWidgets('shows calendar and 24-hour minute wheels', (tester) async {
      await openPicker(tester);

      expect(find.byType(CalendarDatePicker), findsOneWidget);
      expect(find.byType(CupertinoPicker), findsNWidgets(2));
      expect(find.text('AM'), findsNothing);
      expect(find.text('PM'), findsNothing);
    });

    testWidgets('shows title when provided', (tester) async {
      await openPicker(tester, title: const Text('Data e hora'));

      expect(find.text('Data e hora'), findsOneWidget);
    });

    testWidgets('returns null when cancelled', (tester) async {
      await openPicker(tester);

      expect(await closePicker(tester, 'Cancel'), isNull);
    });

    testWidgets('returns the initial date and time when confirmed', (tester) async {
      await openPicker(tester);

      expect(await closePicker(tester, 'OK'), DateTime(2026, 8, 14, 14, 30));
    });

    testWidgets('confirms the tapped calendar day with the current time', (tester) async {
      await openPicker(tester);
      await tester.tap(find.text('25'));
      await tester.pumpAndSettle();

      expect(await closePicker(tester, 'OK'), DateTime(2026, 8, 25, 14, 30));
    });

    testWidgets('confirms a time change from the hour wheel', (tester) async {
      await openPicker(tester);
      final hourPicker = tester.widget<CupertinoPicker>(find.byType(CupertinoPicker).first);
      hourPicker.scrollController!.jumpToItem(18);
      await tester.pump();

      expect(await closePicker(tester, 'OK'), DateTime(2026, 8, 14, 18, 30));
    });

    testWidgets('keeps MaterialLocalizations when shown from a nested MaterialApp', (tester) async {
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF000000),
          pageRouteBuilder: <T>(settings, builder) {
            return PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => builder(context),
            );
          },
          home: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDateTimePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CalendarDatePicker), findsOneWidget);
    });
  });
}
