import 'package:material_ui/material_ui.dart';

import '../dialogs/dialogs.dart';
import 'text_form_field_button.dart';

class const ItemSelectFormField({
  final String? selectionPageTitle,
  required final int itemCount,
  required final NullableIndexedWidgetBuilder itemBuilder,
  final IndexedWidgetBuilder? separatorBuilder,
  final void Function(dynamic item)? onDialogResult,
  final String? value,
  final InputDecoration? decoration,
  final bool? enabled,
  final FormFieldValidator<String>? validator,
  super.key,
}) extends StatelessWidget {
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
