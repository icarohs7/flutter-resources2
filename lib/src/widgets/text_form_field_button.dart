import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class TextFormFieldButton extends HookWidget {
  final String? value;
  final FormFieldValidator<String?>? validator;
  final InputDecoration? decoration;
  final VoidCallback? onTap;
  final Widget Function(TextEditingController controller)? fieldBuilder;

  const TextFormFieldButton({
    this.value,
    this.validator,
    this.decoration,
    this.onTap,
    this.fieldBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    useEffect(() {
      Future(() => controller.text = value ?? '');

      return null;
    }, [value]);

    return InkWell(
      onTap: onTap,
      child: AbsorbPointer(
        child: fieldBuilder?.call(controller) ??
            TextFormField(
              controller: controller,
              validator: validator,
              decoration: decoration,
              enabled: onTap != null,
            ),
      ),
    );
  }
}
