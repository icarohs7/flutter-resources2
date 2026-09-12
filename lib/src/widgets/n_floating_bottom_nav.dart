import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

import 'n_bottom_nav.dart';

const _kPillBgAlpha = 0.72;
const _kUnselectedAlpha = 0.50;
const _kSelectedHighlightAlpha = 0.15;
const _kLabelFontSize = 11.0;
const _kLabelLineHeight = 1.2;
const _kItemHorizontalPadding = 16.0;
const _kItemVerticalPadding = 4.0;
const _kIconLabelGap = 4.0;
const _kSelectionPillRadius = 20.0;

const _kItemAnimDuration = Duration(milliseconds: 200);
const _kVisibilityAnimDuration = Duration(milliseconds: 250);
const _kHideSlideOffset = Offset(0, 1.5);

const _kCollapsedHeight = 36.0;
const _kCollapsedWidthFactor = 1.8;
const _kCollapseDragVelocity = 150.0;

/// A floating, pill-shaped bottom navigation bar.
///
/// The bar can hide while its scroll controller moves down and collapse into a
/// compact indicator when dragged. [items] can also provide badges and a
/// selected icon through [NBottomNavItem].
class const NFloatingBottomNav({
  super.key,

  /// The index of the currently selected item.
  required final int currentIndex,

  /// Called when an item is tapped, with its index as argument.
  required final void Function(int index) onTap,

  /// Navigation items displayed in the bar.
  required final List<NBottomNavItem> items,

  /// Optional action docked into the center of the navigation pill.
  final Widget? centerAction,

  /// Layout size reserved for [centerAction].
  final Size centerActionSize = const .square(88),

  /// Background color of the pill. Defaults to a semi-transparent surface color.
  final Color? backgroundColor,

  /// Icon and label color for the selected item. Defaults to [ColorScheme.primary].
  final Color? selectedItemColor,

  /// Icon and label color for unselected items. Defaults to [ColorScheme.onSurface] at 50% opacity.
  final Color? unselectedItemColor,

  /// Outer margin around the floating pill.
  final EdgeInsets margin = const .fromLTRB(48, 0, 48, 16),

  /// Corner radius of the pill shape.
  final double borderRadius = 40.0,

  /// Gaussian blur sigma for the acrylic backdrop.
  final double blurSigma = 24.0,

  /// Shadow elevation under the pill.
  final double elevation = 4.0,

  /// Total height of the nav bar.
  final double height = 64.0,

  /// Icon size for nav items.
  final double iconSize = 22.0,

  /// Text style for unselected labels.
  final TextStyle? labelStyle,

  /// Text style for the selected label.
  final TextStyle? selectedLabelStyle,

  /// When true, the nav bar slides out of view on scroll-down and reappears on
  /// scroll-up. Uses [scrollController] when provided, otherwise falls back to
  /// [PrimaryScrollController] — which is the controller automatically used by
  /// any uncontrolled [ListView] or [CustomScrollView] in the [Scaffold] body.
  final bool hideOnScroll = true,

  /// Explicit scroll controller to observe. Only relevant when [hideOnScroll]
  /// is true. Defaults to [PrimaryScrollController] when omitted.
  final ScrollController? scrollController,

  /// When true, the user can drag the nav bar downward to collapse it into a
  /// small indicator pill. Tapping the indicator or dragging it upward expands
  /// the bar back.
  final bool collapsible = true,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    assert(
      currentIndex < items.length,
      'currentIndex ($currentIndex) must be less than items.length (${items.length})',
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedIndex = currentIndex >= items.length ? 0 : currentIndex;

    final resolvedBg = _resolveBackgroundColor(theme, colorScheme);
    final resolvedSelected = selectedItemColor ?? colorScheme.primary;
    final resolvedUnselected =
        unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: _kUnselectedAlpha);

    final TextStyle defaultLabelStyle = .new(
      fontSize: _kLabelFontSize,
      fontWeight: FontWeight.w500,
      color: resolvedUnselected,
      height: _kLabelLineHeight,
    );
    final defaultSelectedLabelStyle = defaultLabelStyle.copyWith(
      fontWeight: .w600,
      color: resolvedSelected,
    );

    final isVisible = useState(true);
    final isCollapsed = useState(false);
    final resolvedController = scrollController ?? PrimaryScrollController.maybeOf(context);
    final action = centerAction;

    useEffect(() {
      if (!hideOnScroll || resolvedController == null) return null;
      final controller = resolvedController;
      void onScroll() => _updateScrollVisibility(controller, isVisible);
      controller.addListener(onScroll);
      return () => controller.removeListener(onScroll);
    }, [hideOnScroll, resolvedController]);

    final pill = _NavPill(
      items: items,
      selectedIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: resolvedBg,
      selectedColor: resolvedSelected,
      unselectedColor: resolvedUnselected,
      margin: margin,
      borderRadius: borderRadius,
      blurSigma: blurSigma,
      elevation: elevation,
      height: height,
      iconSize: iconSize,
      labelStyle: labelStyle ?? defaultLabelStyle,
      selectedLabelStyle: selectedLabelStyle ?? defaultSelectedLabelStyle,
      centerGapWidth: centerAction == null ? 0 : centerActionSize.width,
    );
    final content = _FloatingNavContent(
      pill: action == null
          ? pill
          : _NavWithCenterAction(
              action: action,
              actionSize: centerActionSize,
              pillMarginTop: margin.top,
              child: pill,
            ),
      collapsible: collapsible,
      item: items[selectedIndex],
      backgroundColor: resolvedBg,
      selectedColor: resolvedSelected,
      margin: margin,
      borderRadius: borderRadius,
      blurSigma: blurSigma,
      elevation: elevation,
      height: _kCollapsedHeight,
      iconSize: iconSize,
      isCollapsed: isCollapsed,
    );
    return _FloatingNavVisibility(
      hideOnScroll: hideOnScroll,
      isVisible: isVisible,
      content: content,
    );
  }

  Color _resolveBackgroundColor(ThemeData theme, ColorScheme colorScheme) {
    return backgroundColor ??
        (theme.brightness == .light
            ? Colors.white.withValues(alpha: _kPillBgAlpha)
            : colorScheme.surfaceContainer.withValues(alpha: _kPillBgAlpha));
  }

  void _updateScrollVisibility(ScrollController controller, ValueNotifier<bool> isVisible) {
    if (!controller.hasClients) return;
    final direction = controller.positions.firstOrNull?.userScrollDirection;
    if (direction == .reverse) {
      isVisible.value = false;
    } else if (direction == .forward) {
      isVisible.value = true;
    }
  }
}

class const _FloatingNavContent({
  required final Widget pill,
  required final bool collapsible,
  required final NBottomNavItem item,
  required final Color backgroundColor,
  required final Color selectedColor,
  required final EdgeInsets margin,
  required final double borderRadius,
  required final double blurSigma,
  required final double elevation,
  required final double height,
  required final double iconSize,
  required final ValueNotifier<bool> isCollapsed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!collapsible) return pill;

    return GestureDetector(
      behavior: .translucent,
      onVerticalDragEnd: _handleVerticalDrag,
      child: AnimatedCrossFade(
        firstChild: pill,
        secondChild: _CollapsedIndicator(
          item: item,
          onTap: () => isCollapsed.value = false,
          backgroundColor: backgroundColor,
          selectedColor: selectedColor,
          margin: margin,
          borderRadius: borderRadius,
          blurSigma: blurSigma,
          elevation: elevation,
          height: height,
          iconSize: iconSize,
        ),
        crossFadeState: isCollapsed.value ? .showSecond : .showFirst,
        duration: _kVisibilityAnimDuration,
        sizeCurve: Curves.easeInOut,
      ),
    );
  }

  void _handleVerticalDrag(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > _kCollapseDragVelocity) {
      isCollapsed.value = true;
    } else if (velocity < -_kCollapseDragVelocity) {
      isCollapsed.value = false;
    }
  }
}

class const _FloatingNavVisibility({
  required final bool hideOnScroll,
  required final ValueNotifier<bool> isVisible,
  required final Widget content,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!hideOnScroll) return content;

    return AnimatedSlide(
      offset: isVisible.value ? .zero : _kHideSlideOffset,
      duration: _kVisibilityAnimDuration,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isVisible.value ? 1.0 : 0.0,
        duration: _kVisibilityAnimDuration,
        curve: Curves.easeInOut,
        child: content,
      ),
    );
  }
}

class const _NavWithCenterAction({
  required final Widget action,
  required final Size actionSize,
  required final double pillMarginTop,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final overlap = actionSize.height / 2;

    return Stack(
      clipBehavior: .none,
      children: [
        Padding(
          padding: .only(top: overlap),
          child: child,
        ),
        Positioned(
          top: pillMarginTop,
          left: 0,
          right: 0,
          child: Align(
            alignment: .topCenter,
            child: SizedBox.fromSize(size: actionSize, child: action),
          ),
        ),
      ],
    );
  }
}

class const _NavPill({
  required final List<NBottomNavItem> items,
  required final int selectedIndex,
  required final void Function(int) onTap,
  required final Color backgroundColor,
  required final Color selectedColor,
  required final Color unselectedColor,
  required final EdgeInsets margin,
  required final double borderRadius,
  required final double blurSigma,
  required final double elevation,
  required final double height,
  required final double iconSize,
  required final TextStyle labelStyle,
  required final TextStyle selectedLabelStyle,
  required final double centerGapWidth,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navItems = List<Widget>.generate(items.length, (index) {
      final item = items[index];
      return Expanded(
        child: _NavItem(
          item: item,
          index: index,
          isSelected: selectedIndex == index,
          onTap: onTap,
          iconSize: iconSize,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
          labelStyle: labelStyle,
          selectedLabelStyle: selectedLabelStyle,
        ),
      );
    });
    if (centerGapWidth > 0) {
      navItems.insert((navItems.length + 1) ~/ 2, SizedBox(width: centerGapWidth));
    }

    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: .circular(borderRadius),
        child: BackdropFilter(
          filter: .blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Material(
            elevation: elevation,
            shadowColor: Colors.black26,
            color: backgroundColor,
            borderRadius: .circular(borderRadius),
            child: SizedBox(
              height: height,
              child: Row(children: navItems),
            ),
          ),
        ),
      ),
    );
  }
}

class const _CollapsedIndicator({
  required final NBottomNavItem item,
  required final VoidCallback onTap,
  required final Color backgroundColor,
  required final Color selectedColor,
  required final EdgeInsets margin,
  required final double borderRadius,
  required final double blurSigma,
  required final double elevation,
  required final double height,
  required final double iconSize,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: .circular(borderRadius),
        child: BackdropFilter(
          filter: .blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Material(
            elevation: elevation,
            shadowColor: Colors.black26,
            color: backgroundColor,
            borderRadius: .circular(borderRadius),
            child: InkWell(
              onTap: onTap,
              customBorder: const StadiumBorder(),
              child: SizedBox(
                height: height,
                width: height * _kCollapsedWidthFactor,
                child: Center(
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(
                        item.selectedIcon ?? item.icon,
                        size: iconSize * 0.85,
                        color: selectedColor,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_up,
                        size: iconSize * 0.7,
                        color: selectedColor.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _NavItem({
  required final NBottomNavItem item,
  required final int index,
  required final bool isSelected,
  required final void Function(int) onTap,
  required final double iconSize,
  required final Color selectedColor,
  required final Color unselectedColor,
  required final TextStyle labelStyle,
  required final TextStyle selectedLabelStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final badgeContent = item.badgeText ?? '';
    final hasBadge = item.badge != null || badgeContent.isNotBlank;

    return Tooltip(
      message: item.title,
      child: InkWell(
        onTap: () => onTap(index),
        customBorder: const StadiumBorder(),
        child: Center(
          child: AnimatedContainer(
            duration: _kItemAnimDuration,
            curve: Curves.easeInOut,
            padding: const .symmetric(
              horizontal: _kItemHorizontalPadding,
              vertical: _kItemVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withValues(alpha: _kSelectedHighlightAlpha)
                  : Colors.transparent,
              borderRadius: .circular(_kSelectionPillRadius),
            ),
            child: Column(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              children: [
                Badge(
                  label: item.badge ?? Text(badgeContent),
                  isLabelVisible: hasBadge,
                  child: Icon(
                    isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
                    size: iconSize,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                ),
                const SizedBox(height: _kIconLabelGap),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: isSelected ? selectedLabelStyle : labelStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
