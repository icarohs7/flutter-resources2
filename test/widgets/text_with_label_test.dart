import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders the label and text value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextWithLabel(text: 'Value', label: 'Label'),
        ),
      ),
    );

    final textField = tester.widget<TextFormField>(find.byType(TextFormField));
    final inputDecorator = tester.widget<InputDecorator>(find.byType(InputDecorator));

    expect(textField.controller?.text, 'Value');
    expect(inputDecorator.decoration.labelText, 'Label');
  });
}
