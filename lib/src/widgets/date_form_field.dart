import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import 'text_form_field_button.dart';

class const DateFormField({
  required final DateTime? value,
  required final ValueChanged<DateTime> onChanged,
  final String dateFormat = 'dd/MM/yyyy',
  final InputDecoration? decoration,
  final String? pickerHelpText,
  final String? pickerFieldLabelText,
  required final DateTime pickerInitialDate,
  final DateTime? pickerFirstDate,
  final DateTime? pickerLastDate,
  final Locale? locale,
  final FormFieldValidator<DateTime?>? validator,
  final bool enabled = true,
  super.key,
}) extends StatelessWidget {
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
