import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('applies variant colors and icons', (tester) async {
    final cases = [
      (
        variant: NAlertBoxVariant.info,
        foreground: Colors.blue[700]!,
        background: Colors.blue[100]!,
        icon: Icons.info,
      ),
      (
        variant: NAlertBoxVariant.positive,
        foreground: Colors.green[700]!,
        background: Colors.green[100]!,
        icon: Icons.check_circle,
      ),
      (
        variant: NAlertBoxVariant.warning,
        foreground: Colors.orange[700]!,
        background: Colors.orange[100]!,
        icon: Icons.error,
      ),
      (
        variant: NAlertBoxVariant.negative,
        foreground: Colors.red[700]!,
        background: Colors.red[100]!,
        icon: Icons.warning_amber,
      ),
      (
        variant: NAlertBoxVariant.muted,
        foreground: Colors.grey[700]!,
        background: Colors.grey[100]!,
        icon: Icons.circle,
      ),
    ];

    for (final testCase in cases) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NAlertBox(description: 'Description', variant: testCase.variant),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(of: find.byType(NAlertBox), matching: find.byType(Container)),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, testCase.background);
      expect(tester.widget<Icon>(find.byIcon(testCase.icon)).color, testCase.foreground);
    }
  });
}
