import 'package:material_ui/material_ui.dart';

/// An alert dialog with a primary-colored header and configurable content.
class const NHeaderAlertDialog({
  super.key,
  required final String title,
  required final Widget child,
  final List<Widget>? actions,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      actions: actions,
      clipBehavior: .antiAlias,
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(8),
            alignment: .center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!
                  .copyWith(color: Colors.white, fontSize: 24),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
