import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('clearFocus does not add a synthetic focus node', (tester) async {
    final scopeNode = FocusScopeNode();
    final textFocusNode = FocusNode();
    late BuildContext clearFocusContext;

    addTearDown(() {
      textFocusNode.dispose();
      scopeNode.dispose();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FocusScope(
            node: scopeNode,
            child: Builder(
              builder: (context) {
                clearFocusContext = context;
                return TextField(focusNode: textFocusNode);
              },
            ),
          ),
        ),
      ),
    );

    textFocusNode.requestFocus();
    await tester.pump();
    final childrenBefore = scopeNode.children.toList();

    clearFocus(clearFocusContext);
    await tester.pump();

    expect(textFocusNode.hasPrimaryFocus, isFalse);
    expect(scopeNode.children.toList(), hasLength(childrenBefore.length));
  });
}
