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

    final rows = tester.widgetList<Row>(
      find.descendant(of: find.byType(NumericKeyboard), matching: find.byType(Row)),
    );
    expect(rows, hasLength(4));
    expect(rows.every((row) => row.mainAxisAlignment == MainAxisAlignment.spaceBetween), isTrue);
    expect(tester.widget<Text>(find.text('1')).style?.color, textColor);
  });

  testWidgets('digit hit target fills the grid cell beyond the glyph', (tester) async {
    String? tappedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: NumericKeyboard(onKeyboardTap: (value) => tappedValue = value),
            ),
          ),
        ),
      ),
    );

    final hitTarget = find.ancestor(of: find.text('5'), matching: find.byType(InkWell));
    final hitSize = tester.getSize(hitTarget);
    expect(hitSize.width, greaterThan(50));
    expect(hitSize.height, greaterThanOrEqualTo(72));

    final digitCenter = tester.getCenter(find.text('5'));
    await tester.tapAt(digitCenter + const Offset(36, 18));

    expect(tappedValue, '5');
  });
}
