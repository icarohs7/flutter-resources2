import 'dart:math' as math;

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// The direction in which a [SpeedDial]'s children are displayed.
enum SpeedDialDirection { up, down, left, right }

extension SpeedDialDirectionExtension on SpeedDialDirection {
  bool get isHorizontal => this == SpeedDialDirection.left || this == SpeedDialDirection.right;

  bool get isUp => this == SpeedDialDirection.up;

  bool get isDown => this == SpeedDialDirection.down;

  bool get isLeft => this == SpeedDialDirection.left;

  bool get isRight => this == SpeedDialDirection.right;
}

/// Describes one action button in a [SpeedDial].
class SpeedDialChild {
  /// Creates a child action for a [SpeedDial].
  const SpeedDialChild({
    this.key,
    this.label,
    this.labelStyle,
    this.labelBackgroundColor,
    this.labelWidget,
    this.labelShadow,
    this.child,
    this.visible = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.onTap,
    this.onLongPress,
    this.shape,
  });

  /// The key assigned to the child action button.
  final Key? key;

  /// The text displayed beside the child action button.
  final String? label;

  /// The style applied to [label].
  final TextStyle? labelStyle;

  /// The background color applied to the label container.
  final Color? labelBackgroundColor;

  /// Replaces the default label widget when provided.
  final Widget? labelWidget;

  /// The shadows applied to the label container.
  final List<BoxShadow>? labelShadow;

  /// The widget displayed inside the child action button.
  final Widget? child;

  /// Whether this child is included when the dial is open.
  final bool visible;

  /// The background color of the child action button.
  final Color? backgroundColor;

  /// The foreground color of the child action button.
  final Color? foregroundColor;

  /// The elevation of the child action button.
  final double? elevation;

  /// Called after the child action is tapped.
  final VoidCallback? onTap;

  /// Called after the child action is long-pressed.
  final VoidCallback? onLongPress;

  /// The shape of the child action button.
  final ShapeBorder? shape;
}

/// A floating action button that expands into a group of child actions.
class SpeedDial extends HookWidget {
  /// Creates a speed dial.
  const SpeedDial({
    super.key,
    this.children = const [],
    this.visible = true,
    this.curve = Curves.fastOutSlowIn,
    this.animationDuration = const Duration(milliseconds: 150),
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.activeBackgroundColor,
    this.activeForegroundColor,
    this.elevation = 6,
    this.buttonSize = const Size(56, 56),
    this.childrenButtonSize = const Size(56, 56),
    this.shape = const StadiumBorder(),
    this.isOpenOnStart = false,
    this.closeDialOnPop = true,
    this.animatedIcon,
    this.animatedIconTheme,
    this.icon,
    this.activeIcon,
    this.useRotationAnimation = true,
    this.animationAngle = math.pi / 2,
    this.iconTheme,
    this.label,
    this.activeLabel,
    this.onOpen,
    this.onClose,
    this.onPress,
    this.closeManually = false,
    this.openCloseDial,
    this.childMargin = const EdgeInsets.symmetric(horizontal: 16),
    this.childPadding = const EdgeInsets.symmetric(vertical: 5),
    this.spacing,
    this.spaceBetweenChildren,
    this.direction = SpeedDialDirection.up,
    this.child,
    this.activeChild,
    this.switchLabelPosition = false,
    this.animationCurve,
    this.mini = false,
  });

  /// Child actions, ordered from the lowest to the highest position.
  final List<SpeedDialChild> children;

  /// Whether the dial is shown. When false, the dial shrinks away.
  final bool visible;

  /// The curve used by the dial's size animation.
  final Curve curve;

  /// The duration used for opening and closing animations.
  final Duration animationDuration;

  /// The tooltip of the main action button.
  final String? tooltip;

  /// The hero tag of the main action button. Null disables its hero.
  final Object? heroTag;

  /// The background color of the main action button.
  final Color? backgroundColor;

  /// The foreground color of the main action button.
  final Color? foregroundColor;

  /// The background color of the main action button while open.
  final Color? activeBackgroundColor;

  /// The foreground color of the main action button while open.
  final Color? activeForegroundColor;

  /// The elevation of the main and child action buttons.
  final double elevation;

  /// The size of the main action button.
  final Size buttonSize;

  /// The size of each child action button.
  final Size childrenButtonSize;

  /// The shape of the main action button.
  final ShapeBorder shape;

  /// Whether the dial starts open.
  final bool isOpenOnStart;

  /// Whether back closes an open dial before the route is popped.
  final bool closeDialOnPop;

  /// The animated icon shown in the main action button.
  final AnimatedIconData? animatedIcon;

  /// The theme applied to [animatedIcon].
  final IconThemeData? animatedIconTheme;

  /// The closed icon of the main action button.
  final IconData? icon;

  /// The open icon of the main action button.
  final IconData? activeIcon;

  /// Whether icon changes rotate during the transition.
  final bool useRotationAnimation;

  /// The rotation angle, in radians, used by icon transitions.
  final double animationAngle;

  /// The theme applied to [child], [activeChild], [icon], and [activeIcon].
  final IconThemeData? iconTheme;

  /// The optional label of the main action button.
  final Widget? label;

  /// The optional label shown while the dial is open.
  final Widget? activeLabel;

  /// Called after the dial opens.
  final VoidCallback? onOpen;

  /// Called after the dial closes.
  final VoidCallback? onClose;

  /// Called instead of opening the dial when it is closed.
  final VoidCallback? onPress;

  /// Whether tapping a child leaves the dial open.
  final bool closeManually;

  /// Controls the dial from outside the widget.
  final ValueNotifier<bool>? openCloseDial;

  /// The margin around each child action.
  final EdgeInsets childMargin;

  /// The padding around each child action button.
  final EdgeInsets childPadding;

  /// The space between the main button and the child actions.
  final double? spacing;

  /// The space between child actions.
  final double? spaceBetweenChildren;

  /// The direction in which child actions expand.
  final SpeedDialDirection direction;

  /// The closed widget inside the main action button.
  final Widget? child;

  /// The open widget inside the main action button.
  final Widget? activeChild;

  /// Whether labels are placed after their child buttons.
  final bool switchLabelPosition;

  /// The curve used by child scale animations.
  final Curve? animationCurve;

  /// Whether the main action button uses the compact size.
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final hasVisibleChildren = children.any((child) => child.visible);
    final open = useState((openCloseDial?.value ?? isOpenOnStart) && hasVisibleChildren);
    final controller = useAnimationController(
      duration: animationDuration,
      initialValue: open.value ? 1 : 0,
    );

    void setOpen(bool value) {
      if (value == open.value || (value && !hasVisibleChildren)) {
        return;
      }

      open.value = value;
      if (value) {
        controller.forward();
        onOpen?.call();
      } else {
        controller.reverse();
        onClose?.call();
      }

      if (openCloseDial?.value != value) {
        openCloseDial?.value = value;
      }
    }

    useEffect(() {
      final notifier = openCloseDial;

      void listener() {
        final value = notifier?.value ?? false;
        if (value != open.value) {
          setOpen(value);
        }
      }

      if (notifier != null) {
        notifier.addListener(listener);
        listener();
      }
      return () => notifier?.removeListener(listener);
    }, [openCloseDial, onOpen, onClose, children]);

    return _SpeedDialView(widget: this, controller: controller, open: open.value, setOpen: setOpen);
  }
}

class _SpeedDialView extends StatelessWidget {
  final SpeedDial widget;
  final AnimationController controller;
  final bool open;
  final void Function(bool) setOpen;

  const _SpeedDialView({
    required this.widget,
    required this.controller,
    required this.open,
    required this.setOpen,
  });

  List<SpeedDialChild> get _visibleChildren =>
      widget.children.where((child) => child.visible).toList(growable: false);

  void _toggle() => setOpen(!open);

  void _handleMainPressed() {
    if (!open && widget.onPress != null) {
      widget.onPress!();
      return;
    }
    _toggle();
  }

  void _handleChildTap(SpeedDialChild child) {
    if (!widget.closeManually) {
      setOpen(false);
    }
    child.onTap?.call();
  }

  void _handleChildLongPress(SpeedDialChild child) {
    if (!widget.closeManually) {
      setOpen(false);
    }
    child.onLongPress?.call();
  }

  Animation<double> _childAnimation(int index, int count) {
    final begin = count == 1 ? 0.0 : index / count;
    return CurvedAnimation(
      parent: controller,
      curve: Interval(begin, 1, curve: widget.animationCurve ?? widget.curve),
    );
  }

  Widget _buildLabel(BuildContext context, SpeedDialChild child) {
    if (child.labelWidget != null) {
      return GestureDetector(
        onTap: () => _handleChildTap(child),
        onLongPress: child.onLongPress == null ? null : () => _handleChildLongPress(child),
        child: child.labelWidget,
      );
    }
    if (child.label == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(6);
    final labelBackgroundColor =
        child.labelBackgroundColor ?? (isDark ? Colors.grey[800] : Colors.grey[50]);
    final labelShadow =
        child.labelShadow ??
        [
          BoxShadow(
            color: (isDark ? Colors.grey[900]! : Colors.grey).withValues(alpha: 0.7),
            offset: const Offset(0.8, 0.8),
            blurRadius: 2.4,
          ),
        ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: labelBackgroundColor,
        borderRadius: borderRadius,
        boxShadow: labelShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _handleChildTap(child),
          onLongPress: child.onLongPress == null ? null : () => _handleChildLongPress(child),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(child.label!, style: child.labelStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, SpeedDialChild child, int index, int count) {
    final button = child.child == null
        ? const SizedBox.shrink()
        : Padding(
            padding: widget.childPadding,
            child: SizedBox(
              width: widget.childrenButtonSize.width,
              height: widget.childrenButtonSize.height,
              child: FloatingActionButton(
                key: child.key,
                heroTag: widget.heroTag == null ? null : '${widget.heroTag}-child-$index',
                onPressed: () => _handleChildTap(child),
                backgroundColor: child.backgroundColor,
                foregroundColor: child.foregroundColor,
                elevation: child.elevation ?? widget.elevation,
                shape: child.shape,
                child: child.child,
              ),
            ),
          );

    final action = child.onLongPress == null
        ? button
        : GestureDetector(onLongPress: () => _handleChildLongPress(child), child: button);
    final label = _buildLabel(context, child);
    final content = widget.switchLabelPosition
        ? <Widget>[
            action,
            if (child.label != null || child.labelWidget != null) const SizedBox(width: 8),
            label,
          ]
        : <Widget>[
            label,
            if (child.label != null || child.labelWidget != null) const SizedBox(width: 8),
            action,
          ];

    final childContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );

    return Padding(
      padding: widget.childMargin,
      child: ScaleTransition(scale: _childAnimation(index, count), child: childContent),
    );
  }

  Widget _buildChildLayout(BuildContext context) {
    if (!open && !controller.isAnimating) {
      return const SizedBox.shrink();
    }

    final children = _visibleChildren;
    final orderedChildren = widget.direction.isUp || widget.direction.isLeft
        ? children.reversed.toList(growable: false)
        : children;
    final childWidgets = <Widget>[];
    for (var index = 0; index < orderedChildren.length; index++) {
      if (index > 0 && widget.spaceBetweenChildren != null) {
        childWidgets.add(
          SizedBox(
            width: widget.direction.isHorizontal ? widget.spaceBetweenChildren : null,
            height: widget.direction.isHorizontal ? null : widget.spaceBetweenChildren,
          ),
        );
      }
      childWidgets.add(_buildChild(context, orderedChildren[index], index, orderedChildren.length));
    }

    final layout = widget.direction.isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: childWidgets,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: widget.switchLabelPosition
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: childWidgets,
          );
    final spacing = widget.spacing ?? 0;
    final padding = widget.direction.isUp
        ? EdgeInsets.only(bottom: spacing)
        : widget.direction.isDown
        ? EdgeInsets.only(top: spacing)
        : widget.direction.isLeft
        ? EdgeInsets.only(right: spacing)
        : EdgeInsets.only(left: spacing);

    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: controller, curve: widget.curve),
      axis: widget.direction.isHorizontal ? Axis.horizontal : Axis.vertical,
      alignment: widget.switchLabelPosition && !widget.direction.isHorizontal
          ? widget.direction.isUp
                ? AlignmentDirectional.bottomStart
                : AlignmentDirectional.topStart
          : widget.direction.isUp
          ? AlignmentDirectional.bottomEnd
          : widget.direction.isDown
          ? AlignmentDirectional.topEnd
          : widget.direction.isLeft
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Padding(padding: padding, child: layout),
    );
  }

  Widget _buildMainChild() {
    if (widget.animatedIcon != null) {
      return AnimatedIcon(
        icon: widget.animatedIcon!,
        progress: controller,
        color: widget.animatedIconTheme?.color,
        size: widget.animatedIconTheme?.size,
      );
    }

    final selectedChild = open ? (widget.activeChild ?? widget.child) : widget.child;
    final iconData = open
        ? (widget.activeIcon ?? widget.icon ?? Icons.close)
        : (widget.icon ?? Icons.add);
    final content = selectedChild ?? Icon(iconData);
    final themedContent = widget.iconTheme == null
        ? content
        : IconTheme(data: widget.iconTheme!, child: content);

    if (!widget.useRotationAnimation || (widget.activeChild == null && widget.activeIcon == null)) {
      return AnimatedSwitcher(
        duration: widget.animationDuration,
        child: KeyedSubtree(key: ValueKey(open), child: themedContent),
      );
    }

    return Transform.rotate(
      angle: controller.value * widget.animationAngle,
      child: AnimatedSwitcher(
        duration: widget.animationDuration,
        child: KeyedSubtree(key: ValueKey(open), child: themedContent),
      ),
    );
  }

  Widget _buildMainButton() {
    final backgroundColor = Color.lerp(
      widget.backgroundColor,
      widget.activeBackgroundColor ?? widget.backgroundColor,
      controller.value,
    );
    final foregroundColor = Color.lerp(
      widget.foregroundColor,
      widget.activeForegroundColor ?? widget.foregroundColor,
      controller.value,
    );
    final mainChild = _buildMainChild();
    final hasMainLabel = widget.label != null || (widget.activeLabel != null && open);
    final button = !hasMainLabel
        ? (widget.mini
              ? FloatingActionButton.small(
                  tooltip: widget.tooltip,
                  heroTag: widget.heroTag,
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  elevation: widget.elevation,
                  shape: widget.shape,
                  onPressed: _handleMainPressed,
                  child: mainChild,
                )
              : FloatingActionButton(
                  tooltip: widget.tooltip,
                  heroTag: widget.heroTag,
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  elevation: widget.elevation,
                  shape: widget.shape,
                  onPressed: _handleMainPressed,
                  child: mainChild,
                ))
        : FloatingActionButton.extended(
            tooltip: widget.tooltip,
            heroTag: widget.heroTag,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: widget.elevation,
            shape: widget.shape,
            onPressed: _handleMainPressed,
            icon: mainChild,
            label: AnimatedSwitcher(
              duration: widget.animationDuration,
              child: KeyedSubtree(
                key: ValueKey(open),
                child: open ? (widget.activeLabel ?? widget.label!) : widget.label!,
              ),
            ),
          );

    final sizedButton = !hasMainLabel
        ? SizedBox(
            width: widget.mini ? 40 : widget.buttonSize.width,
            height: widget.mini ? 40 : widget.buttonSize.height,
            child: button,
          )
        : button;

    return GestureDetector(onLongPress: _toggle, child: sizedButton);
  }

  Widget _buildDial(BuildContext context) {
    return widget.direction.isUp || widget.direction.isLeft
        ? (widget.direction.isUp
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.switchLabelPosition
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [_buildChildLayout(context), _buildMainButton()],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_buildChildLayout(context), _buildMainButton()],
                ))
        : (widget.direction.isDown
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.switchLabelPosition
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [_buildMainButton(), _buildChildLayout(context)],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_buildMainButton(), _buildChildLayout(context)],
                ));
  }

  @override
  Widget build(BuildContext context) {
    Widget dial = AnimatedBuilder(
      animation: controller,
      builder: (context, _) => _buildDial(context),
    );
    if (widget.closeDialOnPop) {
      dial = PopScope(
        canPop: !open,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && open) {
            setOpen(false);
          }
        },
        child: dial,
      );
    }

    return AnimatedSize(
      duration: widget.animationDuration,
      curve: widget.curve,
      alignment: Alignment.bottomRight,
      child: widget.visible ? dial : const SizedBox.shrink(),
    );
  }
}
