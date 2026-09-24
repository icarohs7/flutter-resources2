import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('hide on scroll', () {
    Widget page({required int itemCount}) {
      return MaterialApp(
        home: Scaffold(
          body: itemCount == 0
              ? const Center(child: Text('empty'))
              : ListView(
                  children: [
                    for (var i = 0; i < itemCount; i++)
                      SizedBox(height: 100, child: Text('item $i')),
                  ],
                ),
          bottomNavigationBar: NFloatingBottomNav(
            currentIndex: 0,
            onTap: (_) {},
            items: const [
              NBottomNavItem('Home', Icons.home),
              NBottomNavItem('Cart', Icons.shopping_cart),
            ],
          ),
        ),
      );
    }

    double navOpacity(WidgetTester tester) {
      final opacity = find.ancestor(
        of: find.byIcon(Icons.home),
        matching: find.byType(AnimatedOpacity),
      );
      return tester.widget<AnimatedOpacity>(opacity.last).opacity;
    }

    testWidgets('hides while scrolling down content taller than the viewport', (tester) async {
      await tester.pumpWidget(page(itemCount: 20));

      await tester.drag(find.text('item 2'), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(navOpacity(tester), 0);
    });

    testWidgets('stays visible when content that fits the viewport bounces', (tester) async {
      await tester.pumpWidget(page(itemCount: 2));

      await tester.drag(find.text('item 1'), const Offset(0, -80));
      await tester.pump();
      expect(navOpacity(tester), 1);

      await tester.pumpAndSettle();
      expect(navOpacity(tester), 1);
    }, variant: const TargetPlatformVariant({TargetPlatform.iOS}));

    testWidgets('reappears when the hidden content is replaced by content that cannot scroll', (
      tester,
    ) async {
      await tester.pumpWidget(page(itemCount: 20));
      await tester.drag(find.text('item 2'), const Offset(0, -200));
      await tester.pumpAndSettle();

      await tester.pumpWidget(page(itemCount: 0));
      await tester.pumpAndSettle();

      expect(navOpacity(tester), 1);
    });
  });

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
