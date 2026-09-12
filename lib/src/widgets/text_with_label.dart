import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A read-only text field that displays a value with a label.
class const TextWithLabel({
  required final String text,
  required final String label,
  final TextStyle? textStyle,
  final TextStyle? labelStyle,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: text);

    useEffect(() {
      controller.text = text;
      return null;
    }, [text]);

    return IgnorePointer(
      child: TextFormField(
        controller: controller,
        decoration: .new(
          labelText: label,
          border: OutlineInputBorder(borderSide: .none),
          labelStyle: labelStyle,
        ),
        enabled: true,
      ),
    );
  }
}
