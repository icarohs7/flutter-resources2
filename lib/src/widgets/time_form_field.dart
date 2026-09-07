import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import 'text_form_field_button.dart';

class const TimeFormField({
  required final DateTime? value,
  required final ValueChanged<DateTime> onChanged,
  final String timeFormat = 'HH:mm:ss',
  final InputDecoration? decoration,
  final String? pickerHelpText,
  final String? pickerFieldLabelText,
  required final DateTime pickerInitialTime,
  final FormFieldValidator<DateTime?>? validator,
  final bool enabled = true,
  super.key,
}) extends StatelessWidget {
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
