import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('calls onTap with the toggled value', (tester) async {
    bool? nextValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NChoiceChip(
            checked: false,
            onTap: (value) => nextValue = value,
            child: const Text('Choose'),
          ),
        ),
      ),
    );

    await tester.tap(find.descendant(of: find.byType(NChoiceChip), matching: find.byType(InkWell)));

    expect(nextValue, isTrue);
  });

  testWidgets('shows a progress indicator while loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NChoiceChip(
            checked: true,
            loading: true,
            onTap: (_) {},
            child: const Text('Choose'),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Choose'), findsNothing);
  });
}
