import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

import 'text_form_field_button.dart';

class DateFormField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String dateFormat;
  final InputDecoration? decoration;
  final String? pickerHelpText;
  final String? pickerFieldLabelText;
  final DateTime pickerInitialDate;
  final DateTime? pickerFirstDate;
  final DateTime? pickerLastDate;
  final Locale? locale;
  final FormFieldValidator<DateTime?>? validator;
  final bool enabled;

  const DateFormField({
    required this.value,
    required this.onChanged,
    this.dateFormat = 'dd/MM/yyyy',
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
      final selectedDate = await showDatePicker(
        context: context,
        helpText: pickerHelpText,
        fieldLabelText: pickerFieldLabelText,
        initialDate: value ?? pickerInitialDate,
        firstDate: pickerFirstDate ?? now - 52.weeks,
        lastDate: pickerLastDate ?? now + 52.weeks,
        locale: locale ?? Locale('pt', 'BR'),
      );
      if (selectedDate == null) return;
      onChanged(selectedDate);
    }

    return TextFormFieldButton(
      onTap: onTap,
      value: value?.string(dateFormat),
      validator: validator?.apply(
        (v) =>
            (String? input) => v(value),
      ),
      decoration: decoration,
      enabled: enabled,
    );
  }
}
