import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// A standard Material [NavigationBar].
///
/// Use [NFloatingBottomNav], [NFilledBottomNav], or [NRoutedBottomNav] when a
/// floating, filled, or route-aware presentation is needed.
class const NBottomNav({
  super.key,
  required final int currentIndex,
  required final void Function(int index) onTap,
  required final List<NBottomNavItem> items,
  final Color? backgroundColor,
  final Color? selectedItemColor,
  final Color? unselectedItemColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = currentIndex >= items.length ? 0 : currentIndex;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      backgroundColor: backgroundColor,
      destinations: [
        ...items.mapIndexed((index, item) {
          final isSelected = selectedIndex == index;
          final badgeContent = item.badgeText ?? '';
          final selectedIcon = item.selectedIcon ?? item.icon;
          final icon = isSelected ? selectedIcon : item.icon;
          return NavigationDestination(
            icon: Badge(
              label: item.badge ?? Text(badgeContent),
              isLabelVisible: item.badge != null || badgeContent.isNotBlank,
              child: Icon(icon, color: isSelected ? selectedItemColor : unselectedItemColor),
            ),
            label: item.title,
            tooltip: item.title,
          );
        }),
      ],
    );
  }
}

/// A destination used by the shared bottom navigation widgets.
class const NBottomNavItem(
  final String title,
  final IconData icon, {
  final IconData? selectedIcon,
  final String? badgeText,
  final Widget? badge,

  /// When defined, replaces all other parameters as the
  /// widget for the item
  final Widget Function(bool selected, Color backgroundColor, Color textColor)? childBuilder,
  final VoidCallback? onTap,
});
