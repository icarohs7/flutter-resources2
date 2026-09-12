import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('forwards field configuration and hides the character counter', (tester) async {
    final controller = TextEditingController();
    final formatter = FilteringTextInputFormatter.digitsOnly;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NLabeledTextFormField(
            controller: controller,
            enabled: false,
            labelText: 'Código',
            keyboardType: TextInputType.number,
            inputFormatters: [formatter],
            maxLength: 6,
          ),
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller, same(controller));
    expect(field.enabled, isFalse);
    expect(field.keyboardType, TextInputType.number);
    expect(field.inputFormatters, [formatter]);
    expect(field.maxLength, 6);
    expect(field.decoration?.labelText, 'Código');
    expect(field.decoration?.counterText, '');

    controller.dispose();
  });
}
