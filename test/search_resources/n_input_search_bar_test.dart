import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NInputSearchBar', () {
    final suggestions = <NSearchSuggestion>[
      NSearchSuggestion(title: 'Suggestion 1', subtitle: '', action: (context) {}),
      NSearchSuggestion(title: 'Suggestion 2', subtitle: '', action: (context) {}),
    ];

    Widget createWidgetUnderTest(
        {String? searchHint, ShapeBorder? shape, double? elevation, Widget? icon}) {
      return MaterialApp(
        home: Scaffold(
          body: NInputSearchBar(
            suggestions: suggestions,
            searchHint: searchHint,
            shape: shape,
            elevation: elevation,
            icon: icon,
          ),
        ),
      );
    }

    testWidgets('displays default search hint when none is provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Pesquisar'), findsOneWidget);
    });

    testWidgets('displays custom search hint when provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(searchHint: 'Search here'));
      expect(find.text('Search here'), findsOneWidget);
    });

    testWidgets('displays default icon when none is provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays custom icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(icon: Icon(Icons.add)));
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('uses default elevation when none is provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final material = tester.widgetList<Material>(find.byType(Material));
      expect(material[1].elevation, 6);
    });

    testWidgets('uses custom elevation when provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(elevation: 10));
      final material = tester.widgetList<Material>(find.byType(Material));
      expect(material[1].elevation, 10);
    });

    testWidgets('uses default shape when none is provided', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final material = tester.widgetList<Material>(find.byType(Material));
      expect(material[1].shape, StadiumBorder());
    });

    testWidgets('uses custom shape when provided', (WidgetTester tester) async {
      final customShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
      await tester.pumpWidget(createWidgetUnderTest(shape: customShape));
      final material = tester.widgetList<Material>(find.byType(Material));
      expect(material[1].shape, customShape);
    });

    testWidgets('triggers search delegate on tap', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(find.byType(NListView), findsOneWidget);
    });
  });
}
