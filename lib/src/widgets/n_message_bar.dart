import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A centered message bar that displays inline text and can respond to taps.
class const NMessageBar({
  required final Color backgroundColor,
  final void Function()? onTap,
  required final List<InlineSpan> children,
  final double width = 200,
  final TextStyle? style,
  final EdgeInsets padding = const EdgeInsets.all(4),
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(4),
          child: Container(
            padding: const EdgeInsets.all(8),
            width: width,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: RichText(
              textAlign: .center,
              text: TextSpan(
                style: style ?? context.textTheme.bodyMedium!.copyWith(fontSize: 16),
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
