import 'package:flutter/material.dart';

import '../dialogs/dialogs.dart';
import 'text_form_field_button.dart';

class ItemSelectFormField extends StatelessWidget {
  final String? selectionPageTitle;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final String? value;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final bool? enabled;
  final void Function(dynamic item)? onDialogResult;

  const ItemSelectFormField({
    this.selectionPageTitle,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.onDialogResult,
    this.value,
    this.decoration,
    this.enabled,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    selectItem() async {
      final result = await showSelectionFullscreenDialog(
        context,
        title: selectionPageTitle,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
      );
      onDialogResult?.call(result);
    }

    return TextFormFieldButton(
      value: value ?? '',
      decoration: decoration,
      enabled: enabled,
      validator: validator,
      onTap: selectItem,
    );
  }
}
