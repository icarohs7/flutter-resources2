import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A themed header used to separate categories in a form.
class const NFormCategoryHeader({required final String title, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(color: context.theme.splashColor.withAlpha(35)),
      child: Text(title, style: context.textTheme.titleLarge),
    );
  }
}
