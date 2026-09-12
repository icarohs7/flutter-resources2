import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('is hidden when the route does not imply app-bar dismissal', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(leading: const NAppBarBackButton()),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.byType(BackButton), findsNothing);
    expect(find.byType(CloseButton), findsNothing);
  });

  testWidgets('uses a back button on a dismissible route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(appBar: AppBar(leading: const NAppBarBackButton())),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(BackButton), findsOneWidget);
  });
}
