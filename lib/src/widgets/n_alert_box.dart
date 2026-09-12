import 'package:material_ui/material_ui.dart';

/// A compact alert box for displaying a description with optional semantic styling.
class const NAlertBox({
  final Color? backgroundColor,
  final Color? foregroundColor,
  final IconData? icon,
  final NAlertBoxVariant? variant,
  required final String description,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final (variantIcon, variantForegroundColor, variantBackgroundColor) = switch (variant) {
      .info => (Icons.info, Colors.blue[700]!, Colors.blue[100]!),
      .positive => (Icons.check_circle, Colors.green[700]!, Colors.green[100]!),
      .warning => (Icons.error, Colors.orange[700]!, Colors.orange[100]!),
      .negative => (Icons.warning_amber, Colors.red[700]!, Colors.red[100]!),
      .muted => (Icons.circle, Colors.grey[700]!, Colors.grey[100]!),
      _ => (null, null, null),
    };

    final (icon, foregroundColor, backgroundColor) = (
      this.icon ?? variantIcon,
      this.foregroundColor ?? variantForegroundColor ?? Colors.grey[700]!,
      this.backgroundColor ?? variantBackgroundColor ?? Colors.grey[100]!,
    );

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: foregroundColor),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: foregroundColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(description, style: .new(color: foregroundColor, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

/// Semantic styles supported by [NAlertBox].
enum NAlertBoxVariant() {
  info,
  positive,
  warning,
  negative,
  muted,
}
