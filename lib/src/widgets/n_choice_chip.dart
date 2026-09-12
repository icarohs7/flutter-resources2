import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A compact selectable chip with optional loading feedback.
class const NChoiceChip({
  super.key,
  required final bool checked,
  required final void Function(bool) onTap,
  required final Widget child,
  final bool? loading,
  final void Function(bool)? afterTapHandled,
  final Color? textColor,
  final Color? backgroundColor,
  final double? borderRadius,
  final BoxBorder? border,
}) extends StatelessWidget {
  void check() {
    onTap(!checked);
    afterTapHandled?.call(checked);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor ?? Colors.white;
    final textColor = this.textColor ?? context.primaryColor;
    return InkWell(
      onTap: check,
      child: AnimatedContainer(
        duration: .new(milliseconds: 250),
        height: 30,
        decoration: BoxDecoration(
          color: checked ? textColor : backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          border: border,
        ),
        child: Center(
          child: (loading ?? false)
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      checked ? backgroundColor : textColor,
                    ),
                  ),
                )
              : IconTheme.merge(
                  data: .new(color: checked ? backgroundColor : textColor),
                  child: DefaultTextStyle(
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: checked ? backgroundColor : textColor,
                    ),
                    child: child,
                  ),
                ),
        ),
      ),
    );
  }
}
