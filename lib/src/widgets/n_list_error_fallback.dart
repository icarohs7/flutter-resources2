import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// Displays an error message and an explicit retry action for a list.
class const NListErrorFallback({
  super.key,
  required final String message,
  required final Future<void> Function() onRetry,
  required final String retryLabel,
  final bool showAsError = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messageStyle = showAsError
        ? context.textTheme.bodyMedium?.copyWith(color: context.theme.colorScheme.error)
        : context.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(message, textAlign: .center, style: messageStyle),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
