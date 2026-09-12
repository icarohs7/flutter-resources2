import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// Displays an icon and caller-provided copy for an empty list.
class const NNoItemsTile({super.key, required final String noItemsText}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          Icon(Icons.search_off, color: context.primaryColor, size: 48),
          Text(
            noItemsText,
            style: context.textTheme.headlineSmall?.copyWith(color: context.primaryColor),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
