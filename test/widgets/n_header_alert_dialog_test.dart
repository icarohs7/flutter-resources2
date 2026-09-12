import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders the header, content, and actions', (tester) async {
    var actionPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NHeaderAlertDialog(
            title: 'Title',
            actions: [
              TextButton(onPressed: () => actionPressed = true, child: const Text('Close')),
            ],
            child: const Text('Content'),
          ),
        ),
      ),
    );

    final title = tester.widget<Text>(find.text('Title'));
    expect(title.style?.color, Colors.white);
    expect(title.style?.fontSize, 24);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.text('Close'));

    expect(actionPressed, isTrue);
  });
}
