import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// A padded text form field with a visible label and no character counter.
class const NLabeledTextFormField({
  super.key,

  /// The key applied to the inner form field.
  final Key? fieldKey,

  /// The controller that manages the field's text.
  required final TextEditingController controller,

  /// Whether the field accepts user input.
  required final bool enabled,

  /// The label displayed by the field decoration.
  required final String labelText,

  /// Optional formatters applied to user input.
  final List<TextInputFormatter>? inputFormatters,

  /// The keyboard configuration used by the field.
  final TextInputType? keyboardType,

  /// The validation callback used by the enclosing form.
  final FormFieldValidator<String>? validator,

  /// The maximum number of characters accepted by the field.
  final int? maxLength,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enabled: enabled,
        maxLength: maxLength,
        validator: validator,
        decoration: .new(counterText: '', labelText: labelText),
      ),
    );
  }
}
