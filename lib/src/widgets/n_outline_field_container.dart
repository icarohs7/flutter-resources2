import 'package:material_ui/material_ui.dart';

/// A padded container with an outline for form-field content.
class const NOutlineFieldContainer({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: .new(0xFF808080), style: .solid, width: .8),
      ),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: child),
    );
  }
}
