import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import 'text_form_field_button.dart';

class DateTimeFormField extends StatelessWidget {
  final String? title;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String dateTimeFormat;
  final InputDecoration? decoration;
  final String? pickerHelpText;
  final String? pickerFieldLabelText;
  final DateTime pickerInitialDate;
  final DateTime? pickerFirstDate;
  final DateTime? pickerLastDate;
  final Locale? locale;
  final FormFieldValidator<DateTime?>? validator;
  final bool enabled;

  const DateTimeFormField({
    this.title,
    required this.value,
    required this.onChanged,
    this.dateTimeFormat = 'dd/MM/yyyy HH:mm:ss',
    this.decoration,
    this.pickerHelpText,
    this.pickerFieldLabelText,
    required this.pickerInitialDate,
    this.pickerFirstDate,
    this.pickerLastDate,
    this.locale,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    onTap() async {
      final now = DateTime.now();
      final selectedTime = await showOmniDateTimePicker(
        context: context,
        title: title?.apply((t) => Text(t, style: context.textTheme.titleLarge)),
        padding: .only(top: 8),
        is24HourMode: true,
        isShowSeconds: false,
        initialDate: value ?? pickerInitialDate,
        firstDate: pickerFirstDate ?? now - 52.weeks,
        lastDate: pickerLastDate ?? now + 52.weeks,
      );
      if (selectedTime == null) return;
      onChanged(
        DateTime.now().copyWith(
          day: selectedTime.day,
          month: selectedTime.month,
          year: selectedTime.year,
          hour: selectedTime.hour,
          minute: selectedTime.minute,
          second: 0,
        ),
      );
    }

    return TextFormFieldButton(
      onTap: onTap,
      value: value?.string(dateTimeFormat),
      validator: validator?.apply(
        (v) =>
            (String? input) => v(value),
      ),
      decoration: decoration,
      enabled: enabled,
    );
  }
}
