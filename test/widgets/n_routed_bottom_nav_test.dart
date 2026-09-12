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
}
