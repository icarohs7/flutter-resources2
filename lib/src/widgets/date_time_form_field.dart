import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import 'text_form_field_button.dart';

/// Read-only date-and-time field that opens [showOmniDateTimePicker] on tap.
///
/// The current [value] is shown through [TextFormFieldButton] using
/// [dateTimeFormat]. Tapping the field presents an Omni date-time picker in
/// 24-hour mode without seconds. When the user confirms a selection,
/// [onChanged] receives [DateTime.now] with the picked calendar date and time
/// (seconds set to zero).
///
/// [pickerInitialDate] is used when [value] is null. [pickerFirstDate] and
/// [pickerLastDate] bound the selectable range; each defaults to one year
/// before and after the current date when omitted.
///
/// [validator] validates the [DateTime?] [value], not the displayed string.
/// When [enabled] is false, the field cannot be opened.
class DateTimeFormField extends StatelessWidget {
  /// Optional title shown at the top of the picker dialog.
  final String? title;

  /// Currently selected date and time, or null when empty.
  final DateTime? value;

  /// Called when the user confirms a new date and time in the picker.
  final ValueChanged<DateTime> onChanged;

  /// Format pattern used to display [value] in the text field.
  final String dateTimeFormat;

  /// Decoration for the underlying [TextFormField].
  final InputDecoration? decoration;

  /// Help text for the picker. Reserved for API parity with [DateFormField].
  final String? pickerHelpText;

  /// Field label text for the picker. Reserved for API parity with [DateFormField].
  final String? pickerFieldLabelText;

  /// Initial picker position when [value] is null.
  final DateTime pickerInitialDate;

  /// Earliest selectable date in the picker.
  final DateTime? pickerFirstDate;

  /// Latest selectable date in the picker.
  final DateTime? pickerLastDate;

  /// Locale for the picker. Reserved for API parity with [DateFormField].
  final Locale? locale;

  /// Validates the current [value] when the parent [Form] is submitted.
  final FormFieldValidator<DateTime?>? validator;

  /// When false, the field is read-only and the picker cannot be opened.
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
