import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp({Widget? home}) => MaterialApp(
    navigatorKey: NMessenger.navigatorKey,
    scaffoldMessengerKey: NMessenger.scaffoldMessengerKey,
    home: Scaffold(body: home ?? const SizedBox.shrink()),
  );

  group('NMessenger', () {
    test('returns null when keys are not attached to a widget tree', () async {
      // No app pumped yet, so there is no current context/state.
      final snackbarController = NMessenger.showSnackbar(const SnackBar(content: Text('Hello')));
      expect(snackbarController, isNull);

      final dialogResult = await NMessenger.showDialog<int>(
        builder: (context) => const SizedBox.shrink(),
      );
      expect(dialogResult, isNull);
    });

    testWidgets('shows snackbar using global ScaffoldMessenger key', (tester) async {
      await tester.pumpWidget(buildApp());

      final controller = NMessenger.showSnackbar(const SnackBar(content: Text('Snack')));

      expect(controller, isNotNull);

      // Let the snackbar animate in.
      await tester.pump();
      expect(find.text('Snack'), findsOneWidget);
    });

    testWidgets('shows dialog using global Navigator key and returns result', (tester) async {
      await tester.pumpWidget(buildApp());

      final future = NMessenger.showDialog<String>(
        builder: (context) => AlertDialog(
          title: const Text('Title'),
          content: const Text('Body'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop('ok'), child: const Text('OK')),
          ],
        ),
      );

      // Wait for the dialog to appear.
      await tester.pumpAndSettle();
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);

      // Close with a result.
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final result = await future;
      expect(result, 'ok');
    });
  });
}
