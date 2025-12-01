import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import 'text_form_field_button.dart';

class TimeFormField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String timeFormat;
  final InputDecoration? decoration;
  final String? pickerHelpText;
  final String? pickerFieldLabelText;
  final DateTime pickerInitialTime;
  final FormFieldValidator<DateTime?>? validator;
  final bool enabled;

  const TimeFormField({
    required this.value,
    required this.onChanged,
    this.timeFormat = 'HH:mm:ss',
    this.decoration,
    this.pickerHelpText,
    this.pickerFieldLabelText,
    required this.pickerInitialTime,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    onTap() async {
      final selectedTime = await showTimePicker(
        context: context,
        helpText: pickerHelpText,
        initialTime: .fromDateTime(value ?? pickerInitialTime),
      );
      if (selectedTime == null) return;
      onChanged(.now().copyWith(hour: selectedTime.hour, minute: selectedTime.minute, second: 0));
    }

    return TextFormFieldButton(
      onTap: onTap,
      value: value?.string(timeFormat),
      validator: validator?.apply(
        (v) =>
            (String? input) => v(value),
      ),
      decoration: decoration,
      enabled: enabled,
    );
  }
}
