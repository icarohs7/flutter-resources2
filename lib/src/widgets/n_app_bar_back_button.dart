import 'package:material_ui/material_ui.dart';

import '../extensions/extensions.dart';

/// A back or close button that follows the current route's app-bar dismissal semantics.
///
/// The widget renders nothing when the route does not imply app-bar dismissal,
/// uses a [CloseButton] for fullscreen dialog routes, and otherwise uses a
/// [BackButton]. While a flexible app bar is expanded, [expandedForegroundColor]
/// controls the button color.
class const NAppBarBackButton({final Color? expandedForegroundColor, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    if (parentRoute == null || !parentRoute.impliesAppBarDismissal) {
      return const SizedBox.shrink();
    }

    final useCloseButton = parentRoute.fullscreenDialog;
    final isCollapsed = context.isSliverCollapsed;
    final color = isCollapsed ? null : (expandedForegroundColor ?? Colors.white);

    return useCloseButton ? CloseButton(color: color) : BackButton(color: color);
  }
}
