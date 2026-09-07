import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

class const TextFormFieldButton({
  final String? value,
  final FormFieldValidator<String?>? validator,
  final InputDecoration? decoration,
  final VoidCallback? onTap,
  final VoidCallback? onLongPress,
  final Widget Function(TextEditingController controller)? fieldBuilder,
  final bool? enabled,
  super.key,
}) extends HookWidget {
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
