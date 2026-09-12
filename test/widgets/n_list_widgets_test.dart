import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders a header and striped table rows', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NSimpleTable(
          shrinkWrap: true,
          columns: const [NTableColumn(title: 'Name', size: 1)],
          rowCount: 2,
          rowBuilder: (_, index) => [Text('Row $index')],
        ),
      ),
    );

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Row 0'), findsOneWidget);
    expect(find.text('Row 1'), findsOneWidget);

    final rows = tester
        .widgetList<Container>(find.byType(Container))
        .where((row) => row.color != null)
        .toList();
    expect(rows, hasLength(3));
    expect(rows[0].color, isNot(rows[1].color));
    expect(rows[1].color, isNot(rows[2].color));
  });

  testWidgets('renders empty and error fallbacks', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NNoItemsTile(noItemsText: 'Nothing here')));

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.byIcon(Icons.search_off), findsOneWidget);

    var retryCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: NListErrorFallback(
          message: 'Could not load items',
          retryLabel: 'Retry',
          onRetry: () async {
            retryCount++;
          },
        ),
      ),
    );

    expect(find.text('Could not load items'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 1));
    expect(retryCount, 1);
  });

  testWidgets('animated list item becomes visible after its animation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NAnimatedListItem(
          index: 0,
          delayPerItem: Duration.zero,
          duration: Duration(milliseconds: 100),
          child: Text('Animated item'),
        ),
      ),
    );

    final fade = find.descendant(
      of: find.byType(NAnimatedListItem),
      matching: find.byType(FadeTransition),
    );
    final initialOpacity = tester.widget<FadeTransition>(fade).opacity.value;
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 100));
    final finalOpacity = tester.widget<FadeTransition>(fade).opacity.value;

    expect(finalOpacity, greaterThan(initialOpacity));
    expect(finalOpacity, closeTo(1, 0.01));
    expect(find.text('Animated item'), findsOneWidget);
  });
}
