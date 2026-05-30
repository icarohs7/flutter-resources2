import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NBasicSearchDelegate', () {
    testWidgets('shows a header when the group changes', (WidgetTester tester) async {
      final suggestions = <NSearchSuggestion>[
        NSearchSuggestion(title: 'Item 1', subtitle: 'Sub 1', group: 'Group A', action: (_) {}),
        NSearchSuggestion(title: 'Item 2', subtitle: 'Sub 2', group: 'Group A', action: (_) {}),
        NSearchSuggestion(title: 'Item 3', subtitle: 'Sub 3', group: 'Group B', action: (_) {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NInputSearchBar(suggestions: suggestions),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('GROUP A'), findsOneWidget);
      expect(find.text('GROUP B'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('does not show headers for suggestions without a group', (WidgetTester tester) async {
      final suggestions = <NSearchSuggestion>[
        NSearchSuggestion(title: 'Ungrouped 1', subtitle: '', action: (_) {}),
        NSearchSuggestion(title: 'Ungrouped 2', subtitle: '', action: (_) {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NInputSearchBar(suggestions: suggestions),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('UNGROUPED'), findsNothing);
    });

    testWidgets('shows the group header again after ungrouped items', (WidgetTester tester) async {
      final suggestions = <NSearchSuggestion>[
        NSearchSuggestion(title: 'Grouped', subtitle: '', group: 'Group A', action: (_) {}),
        NSearchSuggestion(title: 'Ungrouped', subtitle: '', action: (_) {}),
        NSearchSuggestion(title: 'Grouped again', subtitle: '', group: 'Group A', action: (_) {}),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NInputSearchBar(suggestions: suggestions),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('GROUP A'), findsNWidgets(2));
    });
  });
}
