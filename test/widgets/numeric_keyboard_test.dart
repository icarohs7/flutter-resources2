import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders every digit and reports the tapped value', (tester) async {
    String? tappedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NumericKeyboard(onKeyboardTap: (value) => tappedValue = value)),
      ),
    );

    for (final digit in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) {
      expect(find.text(digit), findsOneWidget);
    }

    await tester.tap(find.text('7'));

    expect(tappedValue, '7');
  });

  testWidgets('reports taps on the optional action buttons', (tester) async {
    var leftTaps = 0;
    var rightTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NumericKeyboard(
            onKeyboardTap: (_) {},
            leftButtonFn: () => leftTaps++,
            leftIcon: const Icon(Icons.check),
            rightButtonFn: () => rightTaps++,
            rightIcon: const Icon(Icons.backspace),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.check));
    await tester.tap(find.byIcon(Icons.backspace));

    expect(leftTaps, 1);
    expect(rightTaps, 1);
  });

  testWidgets('forwards text color and row alignment', (tester) async {
    const textColor = Color(0xff123456);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NumericKeyboard(
            onKeyboardTap: (_) {},
            textColor: textColor,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );

    final overflowBars = tester.widgetList<OverflowBar>(find.byType(OverflowBar));
    expect(overflowBars, hasLength(4));
    expect(
      overflowBars.every((overflowBar) => overflowBar.alignment == MainAxisAlignment.spaceBetween),
      isTrue,
    );
    expect(tester.widget<Text>(find.text('1')).style?.color, textColor);
  });
}
