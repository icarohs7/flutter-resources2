import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NBasicSearchDelegate', () {
    group('grouping', () {
      testWidgets('shows a header when the group changes', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Item 1', subtitle: 'Sub 1', group: 'Group A', action: (_) {}),
          NSearchSuggestion(title: 'Item 2', subtitle: 'Sub 2', group: 'Group A', action: (_) {}),
          NSearchSuggestion(title: 'Item 3', subtitle: 'Sub 3', group: 'Group B', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);

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

        await _openSearch(tester, suggestions);

        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.text('UNGROUPED'), findsNothing);
      });

      testWidgets('shows the group header again after ungrouped items', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Grouped', subtitle: '', group: 'Group A', action: (_) {}),
          NSearchSuggestion(title: 'Ungrouped', subtitle: '', action: (_) {}),
          NSearchSuggestion(title: 'Grouped again', subtitle: '', group: 'Group A', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);

        expect(find.text('GROUP A'), findsNWidgets(2));
      });

      testWidgets('keeps group header when only some items in the group match', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Alpha', subtitle: 'foo', group: 'Group A', action: (_) {}),
          NSearchSuggestion(title: 'Beta', subtitle: 'bar', group: 'Group A', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'foo');

        expect(find.text('GROUP A'), findsOneWidget);
        expect(find.text('Alpha'), findsOneWidget);
        expect(find.text('Beta'), findsNothing);
      });
    });

    group('default title and subtitle matching', () {
      testWidgets('shows all suggestions when the query is empty', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'One', subtitle: 'a', action: (_) {}),
          NSearchSuggestion(title: 'Two', subtitle: 'b', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);

        expect(find.byType(ListTile), findsNWidgets(2));
      });

      testWidgets('matches when the query is in the title', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Solicitar Servico', subtitle: 'Pedidos', action: (_) {}),
          NSearchSuggestion(title: 'Outro', subtitle: 'Pedidos', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'solicitar');

        expect(find.text('Solicitar Servico'), findsOneWidget);
        expect(find.text('Outro'), findsNothing);
      });

      testWidgets('matches when the query is only in the subtitle', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Menu', subtitle: 'Agendamento online', action: (_) {}),
          NSearchSuggestion(title: 'Menu', subtitle: 'Denuncia', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'agendamento');

        expect(find.text('Agendamento online'), findsOneWidget);
        expect(find.text('Denuncia'), findsNothing);
      });

      testWidgets('is case insensitive', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'SOLICITAR', subtitle: '', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'solicitar');

        expect(find.text('SOLICITAR'), findsOneWidget);
      });

      testWidgets('ignores diacritics in the title', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'São Paulo', subtitle: '', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'sao paulo');

        expect(find.text('São Paulo'), findsOneWidget);
      });

      testWidgets('ignores diacritics in the subtitle', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(title: 'Item', subtitle: 'Açúcar', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'acucar');

        expect(find.text('Açúcar'), findsOneWidget);
      });
    });

    group('custom itemMatches', () {
      testWidgets('uses itemMatches instead of the default rule', (WidgetTester tester) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(
            title: 'Hidden by default',
            subtitle: 'Also hidden',
            itemMatches: (query) => query == 'magic',
            action: (_) {},
          ),
          NSearchSuggestion(title: 'Visible', subtitle: 'magic in subtitle', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'magic');

        expect(find.text('Hidden by default'), findsOneWidget);
        expect(find.text('Visible'), findsOneWidget);
      });

      testWidgets('itemMatches can exclude items that would match title or subtitle', (
        WidgetTester tester,
      ) async {
        final suggestions = <NSearchSuggestion>[
          NSearchSuggestion(
            title: 'Solicitar',
            subtitle: '',
            itemMatches: (_) => false,
            action: (_) {},
          ),
          NSearchSuggestion(title: 'Solicitar outro', subtitle: '', action: (_) {}),
        ];

        await _openSearch(tester, suggestions);
        await _enterSearchQuery(tester, 'solicitar');

        expect(find.text('Solicitar'), findsNothing);
        expect(find.text('Solicitar outro'), findsOneWidget);
      });
    });
  });
}

Future<void> _openSearch(WidgetTester tester, Iterable<NSearchSuggestion> suggestions) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: NInputSearchBar(suggestions: suggestions),
      ),
    ),
  );

  await tester.tap(find.byType(InkWell));
  await tester.pumpAndSettle();
}

Future<void> _enterSearchQuery(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.pumpAndSettle();
}

