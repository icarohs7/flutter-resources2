import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('docks the center action into the navigation pill and reserves its space', (
    tester,
  ) async {
    const actionKey = Key('center-action');
    var actionTaps = 0;
    final navigationTaps = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: NFloatingBottomNav(
              currentIndex: 0,
              onTap: navigationTaps.add,
              items: const [
                NBottomNavItem('Cadastros', Icons.home),
                NBottomNavItem('Perfil', Icons.person),
              ],
              centerAction: FloatingActionButton(
                key: actionKey,
                onPressed: () => actionTaps++,
                child: const Icon(Icons.add),
              ),
              hideOnScroll: false,
              collapsible: false,
            ),
          ),
        ),
      ),
    );

    final actionRect = tester.getRect(find.byKey(actionKey));
    final pillRect = tester.getRect(find.byType(BackdropFilter));
    final firstItemRect = tester.getRect(find.byIcon(Icons.home));
    final secondItemRect = tester.getRect(find.byIcon(Icons.person));

    expect(actionRect.size, const Size.square(88));
    expect(actionRect.center.dy, closeTo(pillRect.top, 0.01));
    expect(firstItemRect.right, lessThan(actionRect.left));
    expect(secondItemRect.left, greaterThan(actionRect.right));

    await tester.tapAt(Offset(actionRect.center.dx, actionRect.top + 8));
    await tester.tap(find.byKey(actionKey));
    await tester.tap(find.byIcon(Icons.home));
    await tester.tap(find.byIcon(Icons.person));

    expect(actionTaps, 2);
    expect(navigationTaps, [0, 1]);
  });
}
