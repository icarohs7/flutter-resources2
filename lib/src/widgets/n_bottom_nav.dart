import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

class NBottomNav extends StatelessWidget {
  const NBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  final int currentIndex;
  final void Function(int index) onTap;
  final List<NBottomNavItem> items;

  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

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
          return NavigationDestination(
            icon: Badge(
              label: item.badge ?? Text(badgeContent),
              isLabelVisible: item.badge != null || badgeContent.isNotBlank,
              child: Icon(item.icon, color: isSelected ? selectedItemColor : unselectedItemColor),
            ),
            label: item.title,
            tooltip: item.title,
          );
        }),
      ],
    );
  }
}

class NBottomNavItem {
  const NBottomNavItem(
    this.title,
    this.icon, {
    this.badgeText,
    this.badge,
    this.childBuilder,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String? badgeText;
  final Widget? badge;
  final VoidCallback? onTap;

  /// When defined, replaces all other parameters as the
  /// widget for the item
  final Widget Function(bool selected, Color backgroundColor, Color textColor)? childBuilder;
}
