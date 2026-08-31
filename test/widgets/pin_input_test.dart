import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders one cell per PIN digit and reacts to controller changes', (tester) async {
    final controller = TextEditingController(text: '12');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: PinInput(
          controller: controller,
          length: 4,
          obscureText: true,
          obscuringWidget: const Icon(Icons.circle),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('pin-input-cell-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('pin-input-cell-3')), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsNWidgets(2));

    controller.text = '1234';
    await tester.pump();

    expect(find.byIcon(Icons.circle), findsNWidgets(4));
  });

  testWidgets('uses the configured cell size and decoration', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    const decoration = BoxDecoration(color: Color(0xff123456));

    await tester.pumpWidget(
      MaterialApp(
        home: PinInput(controller: controller, length: 2, cellSize: 40, decoration: decoration),
      ),
    );

    final cell = tester.widget<SizedBox>(find.byKey(const ValueKey('pin-input-cell-0')));

    expect(cell.width, 40);
    expect(cell.height, 40);
    expect(
      tester
          .widget<DecoratedBox>(
            find.descendant(
              of: find.byKey(const ValueKey('pin-input-cell-0')),
              matching: find.byType(DecoratedBox),
            ),
          )
          .decoration,
      decoration,
    );
  });
}
