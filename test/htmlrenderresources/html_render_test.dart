import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HtmlRender', () {
    testWidgets('renders HTML data correctly', (WidgetTester tester) async {
      const htmlData = '<p>Hello, World!</p>';
      await tester.pumpWidget(MaterialApp(
        home: HtmlRender(data: htmlData),
      ));

      expect(find.text('Hello, World!'), findsOneWidget);
    });
  });
}
