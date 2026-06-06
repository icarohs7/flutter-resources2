import 'package:flutter/material.dart';
import 'package:flutter_resources2/flutter_resources2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeFormField', () {
    final initialDate = DateTime.now().copyWith(
      hour: 14,
      minute: 30,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final pickerFirstDate = DateTime(2020, 1, 1);
    final pickerLastDate = DateTime(2030, 12, 31);

    Future<void> pumpField(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
    }

    Future<void> tapField(WidgetTester tester) async {
      await tester.tap(find.byType(TextFormFieldButton));
      await tester.pump();
    }

    Future<void> closePicker(WidgetTester tester) async {
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    }

    Widget createWidgetUnderTest({
      DateTime? value,
      ValueChanged<DateTime>? onChanged,
      String dateTimeFormat = 'dd/MM/yyyy HH:mm:ss',
      InputDecoration? decoration,
      String? title,
      bool enabled = true,
      FormFieldValidator<DateTime?>? validator,
      GlobalKey<FormState>? formKey,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: DateTimeFormField(
              value: value,
              onChanged: onChanged ?? (_) {},
              dateTimeFormat: dateTimeFormat,
              decoration: decoration,
              title: title,
              enabled: enabled,
              validator: validator,
              pickerInitialDate: initialDate,
              pickerFirstDate: pickerFirstDate,
              pickerLastDate: pickerLastDate,
            ),
          ),
        ),
      );
    }

    testWidgets('displays formatted value when value is set', (tester) async {
      await pumpField(tester, createWidgetUnderTest(value: initialDate));

      expect(find.text(initialDate.string('dd/MM/yyyy HH:mm:ss')), findsOneWidget);
    });

    testWidgets('displays empty field when value is null', (tester) async {
      await pumpField(tester, createWidgetUnderTest(value: null));

      final field = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller?.text, isEmpty);
    });

    testWidgets('uses custom dateTimeFormat', (tester) async {
      await pumpField(
        tester,
        createWidgetUnderTest(value: initialDate, dateTimeFormat: 'yyyy-MM-dd'),
      );

      expect(find.text(initialDate.string('yyyy-MM-dd')), findsOneWidget);
    });

    testWidgets('displays decoration hint when provided', (tester) async {
      await pumpField(
        tester,
        createWidgetUnderTest(
          value: null,
          decoration: const InputDecoration(hintText: 'Select date and time'),
        ),
      );

      expect(find.text('Select date and time'), findsOneWidget);
    });

    testWidgets('disables composer when enabled is false', (tester) async {
      await pumpField(tester, createWidgetUnderTest(value: null, enabled: false));

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('opens datetime picker on tap', (tester) async {
      await pumpField(tester, createWidgetUnderTest(value: initialDate));

      await tapField(tester);

      expect(find.byType(Dialog), findsOneWidget);
      await closePicker(tester);
    });

    testWidgets('shows title in picker when provided', (tester) async {
      await pumpField(
        tester,
        createWidgetUnderTest(value: initialDate, title: 'Pick date and time'),
      );

      await tapField(tester);

      expect(find.text('Pick date and time'), findsOneWidget);
      await closePicker(tester);
    });

    testWidgets('calls onChanged when picker is confirmed', (tester) async {
      DateTime? changed;

      await pumpField(
        tester,
        createWidgetUnderTest(value: initialDate, onChanged: (value) => changed = value),
      );

      await tapField(tester);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final selected = changed;
      expect(selected, isNotNull);
      expect(selected!.year, initialDate.year);
      expect(selected.month, initialDate.month);
      expect(selected.day, initialDate.day);
      expect(selected.hour, initialDate.hour);
      expect(selected.minute, initialDate.minute);
      expect(selected.second, 0);
    });

    testWidgets('does not call onChanged when picker is cancelled', (tester) async {
      var changeCount = 0;

      await pumpField(
        tester,
        createWidgetUnderTest(value: initialDate, onChanged: (_) => changeCount++),
      );

      await tapField(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(changeCount, 0);
    });

    testWidgets('runs validator against the current value', (tester) async {
      final formKey = GlobalKey<FormState>();

      await pumpField(
        tester,
        createWidgetUnderTest(
          formKey: formKey,
          value: null,
          validator: (value) => value == null ? 'Required' : null,
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });
  });
}
