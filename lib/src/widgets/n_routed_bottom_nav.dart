import 'package:material_ui/material_ui.dart';

import 'n_bottom_nav.dart';
import 'n_filled_bottom_nav.dart';
import 'n_floating_bottom_nav.dart';

/// A route-aware bottom navigation bar.
///
/// [routes] and [children] are paired by index. [currentRoute] selects the
/// active item; when it is not present, [fallbackIndex] selects an item or
/// [fallback] is rendered. The widget does not depend on a router package:
/// route changes are reported through [onNavigate].
class const NRoutedBottomNav({
  super.key,

  /// List of routes used by the buttons, in order.
  required final List<String> routes,

  /// Items linked to [routes] by index.
  required final List<NBottomNavItem> children,

  /// Current route used to select the active item.
  final String? currentRoute,

  /// Index selected when [currentRoute] is not present in [routes].
  final int? fallbackIndex,

  /// Widget rendered when no current route or fallback index is available.
  final Widget fallback = const SizedBox(),

  /// Predicate that can force [fallback] for a resolved route index.
  final bool Function(int? index)? fallbackCondition,

  /// Callback invoked when a navigation item is tapped.
  final void Function(int index)? onTap,

  /// Called with the route associated with a tapped item when that item does
  /// not provide its own [NBottomNavItem.onTap].
  required final void Function(BuildContext context, String route) onNavigate,

  /// Color of the navigation bar surface.
  final Color? backgroundColor,

  /// Color of the selected navigation item.
  final Color? selectedItemColor,

  /// Color of unselected navigation items.
  final Color? unselectedItemColor,

  /// Whether to use the floating pill style instead of [NBottomNav].
  final bool isFloatingStyle = true,

  /// Whether to use the inverse filled style instead of [NBottomNav].
  final bool isCustomStyle = false,

  /// Whether the floating style can collapse into a compact indicator.
  final bool collapsible = true,

  /// Optional action docked into the center of the floating navigation pill.
  final Widget? centerAction,

  /// Layout size reserved for [centerAction].
  final Size centerActionSize = const .square(88),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();
    final fallbackConditionResult = fallbackCondition?.call(currentIndex);
    final useFallback = fallbackConditionResult ?? (currentIndex == null && fallbackIndex == null);

    if (useFallback) return fallback;

    final resolvedBackgroundColor =
        backgroundColor ??
        Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
        Theme.of(context).canvasColor;
    final resolvedSelectedItemColor =
        selectedItemColor ??
        Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
        Theme.of(context).colorScheme.primary;
    final resolvedUnselectedItemColor =
        unselectedItemColor ??
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
        Theme.of(context).textTheme.bodySmall?.color;
    final resolvedIndex = currentIndex ?? fallbackIndex ?? 0;

    final onItemTap = _resolveOnTap(context);
    if (isCustomStyle) {
      return NFilledBottomNav(
        selectedItemColor: resolvedSelectedItemColor,
        unselectedItemColor: resolvedUnselectedItemColor ?? resolvedBackgroundColor,
        currentIndex: resolvedIndex,
        onTap: onItemTap,
        items: children,
      );
    }

    if (isFloatingStyle) {
      return NFloatingBottomNav(
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        currentIndex: resolvedIndex,
        onTap: onItemTap,
        items: children,
        collapsible: collapsible,
        centerAction: centerAction,
        centerActionSize: centerActionSize,
      );
    }

    return NBottomNav(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      currentIndex: resolvedIndex,
      onTap: onItemTap,
      items: children,
    );
  }

  int? _getCurrentIndex() {
    final routeName = currentRoute;
    if (routeName == null) return null;

    final index = routes.indexOf(_normalizeRoute(routeName)!);
    return index == -1 ? null : index;
  }

  void Function(int) _resolveOnTap(BuildContext context) {
    return onTap ??
        (index) {
          final childOnTap = index < children.length ? children[index].onTap : null;
          if (childOnTap != null) {
            childOnTap();
            return;
          }

          final route = routes[index];
          if (route != _normalizeRoute(currentRoute)) {
            onNavigate(context, route);
          }
        };
  }

  static String? _normalizeRoute(String? route) {
    if (route == null || route == '/') return route;
    return route.endsWith('/') ? route.substring(0, route.length - 1) : route;
  }
}
