import 'package:material_ui/material_ui.dart';

import 'n_bottom_nav.dart';

/// A bottom navigation bar with an inverse filled selected item.
///
/// The selected item uses [selectedItemColor] as its background and the
/// unselected color for its foreground. An item's [NBottomNavItem.childBuilder]
/// can provide a fully custom selected/unselected presentation.
class const NFilledBottomNav({
  super.key,
  required final List<NBottomNavItem> items,
  final ValueChanged<int>? onTap,
  final int? currentIndex = 0,
  final Duration animationDuration = const Duration(milliseconds: 300),
  final Color? selectedItemColor,
  final Color? unselectedItemColor,
}) extends StatelessWidget {
  this : assert(items.length >= 2);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = unselectedItemColor ?? Theme.of(context).scaffoldBackgroundColor;
    final iconsColor = selectedItemColor ?? Theme.of(context).iconTheme.color!;

    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          ...items.indexed.map((entry) {
            final (index, item) = entry;
            final selected = index == currentIndex;

            final itemWidget = AnimatedContainer(
              duration: animationDuration,
              height: 64.0,
              decoration: BoxDecoration(color: selected ? iconsColor : backgroundColor),
              child: AnimatedTheme(
                data: Theme.of(context).copyWith(
                  iconTheme: Theme.of(context).iconTheme
                      .copyWith(color: selected ? backgroundColor : iconsColor),
                ),
                child: item.childBuilder != null
                    ? item.childBuilder!(selected, backgroundColor, iconsColor)
                    : Column(
                        mainAxisSize: .min,
                        mainAxisAlignment: .center,
                        children: [
                          Icon(item.icon),
                          Text(
                            item.title,
                            style: .new(color: selected ? backgroundColor : iconsColor),
                          ),
                        ],
                      ),
              ),
            );

            return Expanded(
              child: GestureDetector(
                behavior: .opaque,
                onTap: () => onTap?.call(index),
                child: Tooltip(message: item.title, child: itemWidget),
              ),
            );
          }),
        ],
      ),
    );
  }
}
