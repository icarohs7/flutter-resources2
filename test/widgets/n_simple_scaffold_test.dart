import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('overlays the bottom navigation and exposes its height to the body', (tester) async {
    const navigationKey = Key('floating-navigation');
    var bodyBottomPadding = 0.0;

    await tester.pumpWidget(
      MaterialApp(
        home: NSimpleScaffold(
          body: Builder(
            builder: (context) {
              bodyBottomPadding = MediaQuery.paddingOf(context).bottom;
              return const SizedBox();
            },
          ),
          bottomNavigationBar: const SizedBox(key: navigationKey, height: 40),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.bottomNavigationBar, isNull);
    expect(
      find.ancestor(of: find.byKey(navigationKey), matching: find.byType(Stack)),
      findsOneWidget,
    );
    expect(bodyBottomPadding, 40);
  });
}
