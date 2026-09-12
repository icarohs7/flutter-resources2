import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders its message and handles taps', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NMessageBar(
            backgroundColor: Colors.amber,
            onTap: () => tapped = true,
            children: const [TextSpan(text: 'Message')],
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(of: find.byType(NMessageBar), matching: find.byType(Container)),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.amber);
    final richText = tester.widget<RichText>(find.byType(RichText));
    expect(richText.text.toPlainText(), 'Message');

    await tester.tap(find.byType(RichText));

    expect(tapped, isTrue);
  });
}
