import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('SpeedDial is a HookWidget', () {
    expect(const SpeedDial(), isA<HookWidget>());
  });

  testWidgets('opens children in lowest-to-highest order', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        children: [
          SpeedDialChild(label: 'First', child: Icon(Icons.looks_one)),
          SpeedDialChild(label: 'Second', child: Icon(Icons.looks_two)),
        ],
      ),
    );

    expect(find.text('First'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byTooltip('Actions'));
    await tester.pumpAndSettle();

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNWidgets(3));
    expect(
      tester.getCenter(find.text('Second')).dy,
      lessThan(tester.getCenter(find.text('First')).dy),
    );
  });

  testWidgets('child action closes the dial', (tester) async {
    var tapped = 0;

    await tester.pumpWidget(
      _TestApp(
        children: [
          SpeedDialChild(label: 'Action', child: const Icon(Icons.done), onTap: () => tapped++),
        ],
      ),
    );

    await tester.tap(find.byTooltip('Actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Action'));
    await tester.pumpAndSettle();

    expect(tapped, 1);
    expect(find.text('Action'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('external notifier opens and closes the dial', (tester) async {
    final openCloseDial = ValueNotifier(false);
    addTearDown(openCloseDial.dispose);

    await tester.pumpWidget(
      _TestApp(
        openCloseDial: openCloseDial,
        children: const [SpeedDialChild(label: 'Action', child: Icon(Icons.done))],
      ),
    );

    openCloseDial.value = true;
    await tester.pumpAndSettle();
    expect(find.text('Action'), findsOneWidget);

    openCloseDial.value = false;
    await tester.pumpAndSettle();
    expect(find.text('Action'), findsNothing);
  });

  testWidgets('initial external notifier value opens the dial', (tester) async {
    final openCloseDial = ValueNotifier(true);
    addTearDown(openCloseDial.dispose);

    await tester.pumpWidget(
      _TestApp(
        openCloseDial: openCloseDial,
        children: const [SpeedDialChild(label: 'Action', child: Icon(Icons.done))],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('current external notifier value is synchronized when notifier changes', (
    tester,
  ) async {
    final firstNotifier = ValueNotifier(false);
    final secondNotifier = ValueNotifier(true);
    addTearDown(firstNotifier.dispose);
    addTearDown(secondNotifier.dispose);
    const children = [SpeedDialChild(label: 'Action', child: Icon(Icons.done))];

    await tester.pumpWidget(_TestApp(openCloseDial: firstNotifier, children: children));
    await tester.pumpWidget(_TestApp(openCloseDial: secondNotifier, children: children));
    await tester.pumpAndSettle();

    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('current external notifier value is synchronized when children appear', (
    tester,
  ) async {
    final openCloseDial = ValueNotifier(true);
    addTearDown(openCloseDial.dispose);

    await tester.pumpWidget(_TestApp(openCloseDial: openCloseDial, children: const []));
    await tester.pumpWidget(
      _TestApp(
        openCloseDial: openCloseDial,
        children: const [SpeedDialChild(label: 'Action', child: Icon(Icons.done))],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('switching label position keeps child buttons aligned', (tester) async {
    const childKey = ValueKey('child');

    await tester.pumpWidget(
      const _TestApp(
        switchLabelPosition: true,
        children: [SpeedDialChild(key: childKey, label: 'Action', child: Icon(Icons.done))],
      ),
    );
    await tester.tap(find.byTooltip('Actions'));
    await tester.pumpAndSettle();

    final mainButtonCenter = tester.getCenter(find.byTooltip('Actions'));
    final childButtonCenter = tester.getCenter(find.byKey(childKey));
    expect(childButtonCenter.dx, closeTo(mainButtonCenter.dx + 16, 0.1));
  });

  testWidgets('animated icon and shape are forwarded to the main button', (tester) async {
    await tester.pumpWidget(
      const _TestApp(
        shape: RoundedRectangleBorder(),
        children: [SpeedDialChild(child: Icon(Icons.add))],
      ),
    );

    expect(find.byType(AnimatedIcon), findsOneWidget);
    final button = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    expect(button.shape, isA<RoundedRectangleBorder>());
  });
}

class _TestApp extends StatelessWidget {
  final List<SpeedDialChild> children;
  final ShapeBorder? shape;
  final ValueNotifier<bool>? openCloseDial;
  final bool switchLabelPosition;

  const _TestApp({
    required this.children,
    this.shape,
    this.openCloseDial,
    this.switchLabelPosition = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: SpeedDial(
          tooltip: 'Actions',
          animatedIcon: AnimatedIcons.menu_close,
          shape: shape ?? const StadiumBorder(),
          children: children,
          openCloseDial: openCloseDial,
          switchLabelPosition: switchLabelPosition,
        ),
      ),
    );
  }
}
