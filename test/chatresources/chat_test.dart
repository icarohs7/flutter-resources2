import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Chat', () {
    Widget createWidgetUnderTest({
      int? messageCount = 0,
      ChatMessage Function(BuildContext, int)? messageBuilder,
      void Function(String)? onSubmit,
      bool Function(String?)? validator,
      String? fieldHint,
      String? messageWhenEmpty,
      bool enabled = true,
      bool isLoading = false,
      TextEditingController? messageController,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 600,
            child: Chat(
              messageCount: messageCount,
              messageBuilder:
                  messageBuilder ?? (context, index) => ChatMessage(message: 'Message $index'),
              onSubmit: onSubmit,
              validator: validator,
              fieldHint: fieldHint,
              messageWhenEmpty: messageWhenEmpty,
              enabled: enabled,
              isLoading: isLoading,
              messageController: messageController,
            ),
          ),
        ),
      );
    }

    testWidgets('renders messages from messageBuilder', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(messageCount: 2));

      expect(find.text('Message 0'), findsOneWidget);
      expect(find.text('Message 1'), findsOneWidget);
      expect(find.byType(ChatBubble), findsNWidgets(2));
    });

    testWidgets('shows empty state when messageCount is zero', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(messageCount: 0, messageWhenEmpty: 'No messages yet'),
      );

      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('hides empty state when messages are present', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(messageCount: 1, messageWhenEmpty: 'No messages yet'),
      );

      expect(find.text('No messages yet'), findsNothing);
      expect(find.text('Message 0'), findsOneWidget);
    });

    testWidgets('hides composer when onSubmit is null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: null));

      expect(find.byType(TextFormField), findsNothing);
      expect(find.byIcon(Icons.send), findsNothing);
    });

    testWidgets('shows composer when onSubmit is provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('displays field hint when provided', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}, fieldHint: 'Type a message'));

      expect(find.text('Type a message'), findsOneWidget);
    });

    testWidgets('calls onSubmit with composer text when send is tapped', (tester) async {
      String? submitted;

      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (message) => submitted = message));

      await tester.enterText(find.byType(TextFormField), 'Hello');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(submitted, 'Hello');
    });

    testWidgets('does not call onSubmit when validator returns false', (tester) async {
      var submitCount = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSubmit: (_) => submitCount++,
          validator: (message) => message != 'blocked',
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'blocked');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(submitCount, 0);
    });

    testWidgets('disables composer when enabled is false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}, enabled: false));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('disables composer while loading', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}, isLoading: true));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('uses provided messageController for composer text', (tester) async {
      final controller = TextEditingController(text: 'Preset text');

      await tester.pumpWidget(
        createWidgetUnderTest(onSubmit: (_) {}, messageController: controller),
      );

      expect(find.text('Preset text'), findsOneWidget);
    });
  });
}
