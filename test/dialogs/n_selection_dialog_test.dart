import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showSelectionFullscreenDialog', () {
    testWidgets('displays the dialog with given title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showSelectionFullscreenDialog(context,
                title: 'Test Title',
                itemCount: 1,
                itemBuilder: (context, index) => Text('Item $index')),
            child: Text('Show Dialog'),
          ),
        ),
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('displays the correct number of items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showSelectionFullscreenDialog(context,
                itemCount: 3, itemBuilder: (context, index) => Text('Item $index')),
            child: Text('Show Dialog'),
          ),
        ),
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('displays separator between items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showSelectionFullscreenDialog(
              context,
              itemCount: 2,
              itemBuilder: (context, index) => Text('Item $index'),
              separatorBuilder: (context, index) => Divider(),
            ),
            child: Text('Show Dialog'),
          ),
        ),
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('handles null title gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showSelectionFullscreenDialog(context,
                itemCount: 1, itemBuilder: (context, index) => Text('Item $index')),
            child: Text('Show Dialog'),
          ),
        ),
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsNothing);
    });
  });
}
