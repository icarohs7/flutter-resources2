import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class TextFormFieldButton extends HookWidget {
  final String? value;
  final FormFieldValidator<String?>? validator;
  final InputDecoration? decoration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget Function(TextEditingController controller)? fieldBuilder;
  final bool? enabled;

  const TextFormFieldButton({
    this.value,
    this.validator,
    this.decoration,
    this.onTap,
    this.onLongPress,
    this.fieldBuilder,
    this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final enabled = onTap != null && this.enabled != false;

    useEffect(() {
      Future(() => controller.text = value ?? '');

      return null;
    }, [value]);

    return InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      child: AbsorbPointer(
        child:
            fieldBuilder?.call(controller) ??
            TextFormField(
              controller: controller,
              validator: validator,
              decoration: decoration,
              enabled: enabled,
            ),
      ),
    );
  }
}
