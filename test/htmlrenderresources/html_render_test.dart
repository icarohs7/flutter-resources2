import 'package:material_ui/material_ui.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HtmlRender', () {
    testWidgets('renders HTML data correctly', (WidgetTester tester) async {
      const htmlData = '<p>Hello, World!</p>';
      await tester.pumpWidget(MaterialApp(home: HtmlRender(data: htmlData)));
      await tester.pumpAndSettle();

      expect(find.byType(HtmlWidget), findsOneWidget);
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      expect(
        richTexts.any((widget) => widget.text.toPlainText().contains('Hello, World!')),
        isTrue,
      );
    });
  });
}
