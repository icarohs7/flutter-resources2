import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  const navigationKey = Key('floating-navigation');
  const actionKey = Key('floating-action');

  testWidgets('overlays the bottom navigation and exposes its height to the body', (tester) async {
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

    expect(
      find.ancestor(of: find.byKey(navigationKey), matching: find.byType(Stack)),
      findsOneWidget,
    );
    expect(bodyBottomPadding, 40);
  });

  testWidgets('keeps the overlay and the body insets above the system bottom inset', (
    tester,
  ) async {
    const bodyKey = Key('body');
    var bodyPadding = EdgeInsets.zero;
    var bodyViewPadding = EdgeInsets.zero;

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(bottom: 24),
            viewPadding: EdgeInsets.only(bottom: 24),
          ),
          child: NSimpleScaffold(
            body: Builder(
              builder: (context) {
                bodyPadding = MediaQuery.paddingOf(context);
                bodyViewPadding = MediaQuery.viewPaddingOf(context);
                return const SizedBox.expand(key: bodyKey);
              },
            ),
            floatingActionButton: const SizedBox(key: actionKey, width: 56, height: 56),
            bottomNavigationBar: const SizedBox(key: navigationKey, height: 40),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getRect(find.byKey(bodyKey)).bottom, 600);
    expect(tester.getRect(find.byKey(navigationKey)).bottom, 600 - 24);
    expect(tester.getRect(find.byKey(actionKey)).bottom, 600 - 24 - 40 - 8);
    expect(bodyPadding.bottom, 24 + 40 + 56 + 8);
    expect(bodyViewPadding.bottom, 24);
  });

  testWidgets('shows a snackbar above the floating bottom navigation', (tester) async {
    final messengerKey = GlobalKey<ScaffoldMessengerState>();

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: messengerKey,
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600), padding: EdgeInsets.only(bottom: 24)),
          child: NSimpleScaffold(
            body: const SizedBox.expand(),
            floatingActionButton: const SizedBox(key: actionKey, width: 56, height: 56),
            bottomNavigationBar: const SizedBox(key: navigationKey, height: 40),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    messengerKey.currentState!.showSnackBar(const SnackBar(content: Text('saved')));
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byType(SnackBar)).bottom,
      tester.getRect(find.byKey(navigationKey)).top,
    );
  });

  for (final keyboardHeight in [20.0, 300.0]) {
    testWidgets('keeps the floating bottom navigation above a $keyboardHeight tall keyboard', (
      tester,
    ) async {
      const bodyKey = Key('body');

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(
              size: const Size(800, 600),
              viewInsets: EdgeInsets.only(bottom: keyboardHeight),
              viewPadding: const EdgeInsets.only(bottom: 24),
            ),
            child: NSimpleScaffold(
              body: const SizedBox.expand(key: bodyKey),
              bottomNavigationBar: const SizedBox(key: navigationKey, height: 40),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byKey(bodyKey)).bottom, 600 - keyboardHeight);
      expect(tester.getRect(find.byKey(navigationKey)).bottom, 600 - keyboardHeight);
    });
  }
}
