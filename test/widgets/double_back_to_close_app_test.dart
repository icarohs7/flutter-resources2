import 'package:flutter/foundation.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  final snackBarFinder = find.byType(SnackBar);
  final scaffoldFinder = find.byType(Scaffold);

  group('DoubleBackToCloseApp', () {
    testWidgets('first Android back shows snackbar and does not pop', (tester) async {
      await tester.pumpWidget(const _TestApp());

      final eventHandler = _PopRouteCounter();
      tester.binding.addObserver(eventHandler);
      addTearDown(() => tester.binding.removeObserver(eventHandler));

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(snackBarFinder, findsOneWidget);
      expect(eventHandler.didPopRouteCount, 0);
    });

    testWidgets('throws FlutterError when not wrapped in a Scaffold', (tester) async {
      await tester.pumpWidget(const _TestApp(withScaffold: false));

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (error) => error.message,
          'message',
          '`DoubleBackToCloseApp` must be wrapped in a `Scaffold`.',
        ),
      );
    });

    testWidgets('second Android back pops after snackbar is shown', (tester) async {
      await tester.pumpWidget(const _TestApp());

      final eventHandler = _PopRouteCounter();
      tester.binding.addObserver(eventHandler);
      addTearDown(() => tester.binding.removeObserver(eventHandler));

      await tester.binding.handlePopRoute();
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(snackBarFinder, findsOneWidget);
      expect(eventHandler.didPopRouteCount, 1);
    });

    testWidgets('non-Android back pops immediately', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(const _TestApp());

        final eventHandler = _PopRouteCounter();
        tester.binding.addObserver(eventHandler);
        addTearDown(() => tester.binding.removeObserver(eventHandler));

        await tester.binding.handlePopRoute();
        await tester.pump();

        expect(eventHandler.didPopRouteCount, 1);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('back after snackbar is dismissed shows snackbar again', (tester) async {
      await tester.pumpWidget(const _TestApp());

      final eventHandler = _PopRouteCounter();
      tester.binding.addObserver(eventHandler);
      addTearDown(() => tester.binding.removeObserver(eventHandler));

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(snackBarFinder, findsOneWidget);

      ScaffoldMessenger.of(tester.element(scaffoldFinder)).hideCurrentSnackBar();
      await tester.pump();
      expect(snackBarFinder, findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(snackBarFinder, findsOneWidget);
      expect(eventHandler.didPopRouteCount, 0);
    });

    testWidgets('open Drawer consumes back without snackbar', (tester) async {
      await tester.pumpWidget(const _TestApp(withDrawer: true));

      final eventHandler = _PopRouteCounter();
      tester.binding.addObserver(eventHandler);
      addTearDown(() => tester.binding.removeObserver(eventHandler));

      final scaffoldState = tester.state<ScaffoldState>(scaffoldFinder);
      scaffoldState.openDrawer();
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(scaffoldState.isDrawerOpen, isFalse);
      expect(snackBarFinder, findsNothing);
      expect(eventHandler.didPopRouteCount, 0);
    });

    testWidgets('back after closing Drawer shows snackbar', (tester) async {
      await tester.pumpWidget(const _TestApp(withDrawer: true));

      final eventHandler = _PopRouteCounter();
      tester.binding.addObserver(eventHandler);
      addTearDown(() => tester.binding.removeObserver(eventHandler));

      final scaffoldState = tester.state<ScaffoldState>(scaffoldFinder);
      scaffoldState.openDrawer();
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(snackBarFinder, findsOneWidget);
      expect(eventHandler.didPopRouteCount, 0);
    });

    testWidgets('replaces a currently visible snackbar', (tester) async {
      final previousSnackBarFinder = find.widgetWithText(SnackBar, 'Hey!');
      final nextSnackBarFinder = find.widgetWithText(SnackBar, 'Press back again to leave');

      await tester.pumpWidget(const _TestApp());

      ScaffoldMessenger.of(tester.element(scaffoldFinder))
          .showSnackBar(const SnackBar(content: Text('Hey!')));
      await tester.pump();
      expect(previousSnackBarFinder, findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(previousSnackBarFinder, findsNothing);
      expect(nextSnackBarFinder, findsOneWidget);
    });
  });
}

class _PopRouteCounter extends WidgetsBindingObserver {
  int didPopRouteCount = 0;

  @override
  Future<bool> didPopRoute() {
    didPopRouteCount++;
    return super.didPopRoute();
  }
}

class _TestApp extends StatelessWidget {
  final bool withScaffold;
  final bool withDrawer;

  const _TestApp({this.withScaffold = true, this.withDrawer = false});

  @override
  Widget build(BuildContext context) {
    const doubleBackToCloseApp = DoubleBackToCloseApp(
      snackBar: SnackBar(content: Text('Press back again to leave')),
      child: Center(child: Text('Hi there!')),
    );

    return MaterialApp(
      home: withScaffold
          ? Scaffold(drawer: withDrawer ? const Drawer() : null, body: doubleBackToCloseApp)
          : doubleBackToCloseApp,
    );
  }
}
