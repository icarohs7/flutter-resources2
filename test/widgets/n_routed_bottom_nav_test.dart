import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('reports the selected item route without a router dependency', (tester) async {
    String? navigatedRoute;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NRoutedBottomNav(
            currentRoute: '/home',
            routes: const ['/home', '/settings'],
            children: const [
              NBottomNavItem('Home', Icons.home),
              NBottomNavItem('Settings', Icons.settings),
            ],
            isFloatingStyle: false,
            onNavigate: (_, route) => navigatedRoute = route,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Settings').last);

    expect(navigatedRoute, '/settings');
  });

  testWidgets('can keep the floating bar on screen while the content scrolls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [for (var i = 0; i < 20; i++) SizedBox(height: 100, child: Text('item $i'))],
          ),
          bottomNavigationBar: NRoutedBottomNav(
            currentRoute: '/home',
            routes: const ['/home', '/cart'],
            children: const [
              NBottomNavItem('Home', Icons.home),
              NBottomNavItem('Cart', Icons.shopping_cart),
            ],
            hideOnScroll: false,
            onNavigate: (_, _) {},
          ),
        ),
      ),
    );

    await tester.drag(find.text('item 2'), const Offset(0, -200));
    await tester.pumpAndSettle();

    final screen = Offset.zero & tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(screen.contains(tester.getRect(find.byIcon(Icons.shopping_cart)).bottomCenter), isTrue);
  });
}
