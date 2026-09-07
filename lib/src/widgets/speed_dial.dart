import 'dart:math' as math;

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// The direction in which a [SpeedDial]'s children are displayed.
enum SpeedDialDirection() {
  up,
  down,
  left,
  right,
}

extension SpeedDialDirectionExtension on SpeedDialDirection {
  bool get isHorizontal => this == SpeedDialDirection.left || this == SpeedDialDirection.right;

  bool get isUp => this == SpeedDialDirection.up;

  bool get isDown => this == SpeedDialDirection.down;

  bool get isLeft => this == SpeedDialDirection.left;

  bool get isRight => this == SpeedDialDirection.right;
}

/// Describes one action button in a [SpeedDial].
class const SpeedDialChild({
  /// The key assigned to the child action button.
  final Key? key,

  /// The text displayed beside the child action button.
  final String? label,

  /// The style applied to [label].
  final TextStyle? labelStyle,

  /// The background color applied to the label container.
  final Color? labelBackgroundColor,

  /// Replaces the default label widget when provided.
  final Widget? labelWidget,

  /// The shadows applied to the label container.
  final List<BoxShadow>? labelShadow,

  /// The widget displayed inside the child action button.
  final Widget? child,

  /// Whether this child is included when the dial is open.
  final bool visible = true,

  /// The background color of the child action button.
  final Color? backgroundColor,

  /// The foreground color of the child action button.
  final Color? foregroundColor,

  /// The elevation of the child action button.
  final double? elevation,

  /// Called after the child action is tapped.
  final VoidCallback? onTap,

  /// Called after the child action is long-pressed.
  final VoidCallback? onLongPress,

  /// The shape of the child action button.
  final ShapeBorder? shape,
}) {
  /// Creates a child action for a [SpeedDial].
  this;
}

/// A floating action button that expands into a group of child actions.
class const SpeedDial({
  super.key,

  /// Child actions, ordered from the lowest to the highest position.
  final List<SpeedDialChild> children = const [],

  /// Whether the dial is shown. When false, the dial shrinks away.
  final bool visible = true,

  /// The curve used by the dial's size animation.
  final Curve curve = Curves.fastOutSlowIn,

  /// The duration used for opening and closing animations.
  final Duration animationDuration = const Duration(milliseconds: 150),

  /// The tooltip of the main action button.
  final String? tooltip,

  /// The hero tag of the main action button. Null disables its hero.
  final Object? heroTag,

  /// The background color of the main action button.
  final Color? backgroundColor,

  /// The foreground color of the main action button.
  final Color? foregroundColor,

  /// The background color of the main action button while open.
  final Color? activeBackgroundColor,

  /// The foreground color of the main action button while open.
  final Color? activeForegroundColor,

  /// The elevation of the main and child action buttons.
  final double elevation = 6,

  /// The size of the main action button.
  final Size buttonSize = const Size(56, 56),

  /// The size of each child action button.
  final Size childrenButtonSize = const Size(56, 56),

  /// The shape of the main action button.
  final ShapeBorder shape = const StadiumBorder(),

  /// Whether the dial starts open.
  final bool isOpenOnStart = false,

  /// Whether back closes an open dial before the route is popped.
  final bool closeDialOnPop = true,

  /// The animated icon shown in the main action button.
  final AnimatedIconData? animatedIcon,

  /// The theme applied to [animatedIcon].
  final IconThemeData? animatedIconTheme,

  /// The closed icon of the main action button.
  final IconData? icon,

  /// The open icon of the main action button.
  final IconData? activeIcon,

  /// Whether icon changes rotate during the transition.
  final bool useRotationAnimation = true,

  /// The rotation angle, in radians, used by icon transitions.
  final double animationAngle = math.pi / 2,

  /// The theme applied to [child], [activeChild], [icon], and [activeIcon].
  final IconThemeData? iconTheme,

  /// The optional label of the main action button.
  final Widget? label,

  /// The optional label shown while the dial is open.
  final Widget? activeLabel,

  /// Called after the dial opens.
  final VoidCallback? onOpen,

  /// Called after the dial closes.
  final VoidCallback? onClose,

  /// Called instead of opening the dial when it is closed.
  final VoidCallback? onPress,

  /// Whether tapping a child leaves the dial open.
  final bool closeManually = false,

  /// Controls the dial from outside the widget.
  final ValueNotifier<bool>? openCloseDial,

  /// The margin around each child action.
  final EdgeInsets childMargin = const EdgeInsets.symmetric(horizontal: 16),

  /// The padding around each child action button.
  final EdgeInsets childPadding = const EdgeInsets.symmetric(vertical: 5),

  /// The space between the main button and the child actions.
  final double? spacing,

  /// The space between child actions.
  final double? spaceBetweenChildren,

  /// The direction in which child actions expand.
  final SpeedDialDirection direction = SpeedDialDirection.up,

  /// The closed widget inside the main action button.
  final Widget? child,

  /// The open widget inside the main action button.
  final Widget? activeChild,

  /// Whether labels are placed after their child buttons.
  final bool switchLabelPosition = false,

  /// The curve used by child scale animations.
  final Curve? animationCurve,

  /// Whether the main action button uses the compact size.
  final bool mini = false,
}) extends HookWidget {
  /// Creates a speed dial.
  this;

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

class const _SpeedDialView({
  required final SpeedDial widget,
  required final AnimationController controller,
  required final bool open,
  required final void Function(bool) setOpen,
}) extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    Widget dial = AnimatedBuilder(
      animation: controller,
      builder: (_, _) => _SpeedDialDial(
        speedDial: widget,
        controller: controller,
        open: open,
        onMainPressed: _handleMainPressed,
        onMainLongPress: _toggle,
        onChildTap: _handleChildTap,
        onChildLongPress: _handleChildLongPress,
      ),
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

class const _SpeedDialChildView({
  required final SpeedDial speedDial,
  required final AnimationController controller,
  required final SpeedDialChild child,
  required final int index,
  required final int count,
  required final void Function(SpeedDialChild) onTap,
  required final void Function(SpeedDialChild) onLongPress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final button = child.child == null
        ? const SizedBox.shrink()
        : Padding(
            padding: speedDial.childPadding,
            child: SizedBox(
              width: speedDial.childrenButtonSize.width,
              height: speedDial.childrenButtonSize.height,
              child: FloatingActionButton(
                key: child.key,
                heroTag: speedDial.heroTag == null ? null : '${speedDial.heroTag}-child-$index',
                onPressed: () => onTap(child),
                backgroundColor: child.backgroundColor,
                foregroundColor: child.foregroundColor,
                elevation: child.elevation ?? speedDial.elevation,
                shape: child.shape,
                child: child.child,
              ),
            ),
          );

    final action = child.onLongPress == null
        ? button
        : GestureDetector(onLongPress: () => onLongPress(child), child: button);
    final label = child.labelWidget != null
        ? GestureDetector(
            onTap: () => onTap(child),
            onLongPress: child.onLongPress == null ? null : () => onLongPress(child),
            child: child.labelWidget,
          )
        : child.label == null
        ? const SizedBox.shrink()
        : _SpeedDialChildLabel(child: child, onTap: onTap, onLongPress: onLongPress);
    final content = speedDial.switchLabelPosition
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
    final begin = count == 1 ? 0.0 : index / count;
    final scale = CurvedAnimation(
      parent: controller,
      curve: Interval(begin, 1, curve: speedDial.animationCurve ?? speedDial.curve),
    );

    return Padding(
      padding: speedDial.childMargin,
      child: ScaleTransition(
        scale: scale,
        child: Row(mainAxisSize: .min, crossAxisAlignment: .center, children: content),
      ),
    );
  }
}

class const _SpeedDialChildLabel({
  required final SpeedDialChild child,
  required final void Function(SpeedDialChild) onTap,
  required final void Function(SpeedDialChild) onLongPress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        type: .transparency,
        borderRadius: borderRadius,
        clipBehavior: .hardEdge,
        child: InkWell(
          onTap: () => onTap(child),
          onLongPress: child.onLongPress == null ? null : () => onLongPress(child),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(child.label!, style: child.labelStyle),
          ),
        ),
      ),
    );
  }
}

class const _SpeedDialChildLayout({
  required final SpeedDial speedDial,
  required final AnimationController controller,
  required final bool open,
  required final void Function(SpeedDialChild) onTap,
  required final void Function(SpeedDialChild) onLongPress,
}) extends StatelessWidget {
  List<SpeedDialChild> get _visibleChildren =>
      speedDial.children.where((child) => child.visible).toList(growable: false);

  EdgeInsets get _padding {
    final spacing = speedDial.spacing ?? 0;
    if (speedDial.direction.isUp) {
      return .only(bottom: spacing);
    }
    if (speedDial.direction.isDown) {
      return .only(top: spacing);
    }
    if (speedDial.direction.isLeft) {
      return .only(right: spacing);
    }
    return .only(left: spacing);
  }

  AlignmentGeometry get _alignment {
    if (speedDial.switchLabelPosition && !speedDial.direction.isHorizontal) {
      return speedDial.direction.isUp
          ? AlignmentDirectional.bottomStart
          : AlignmentDirectional.topStart;
    }
    if (speedDial.direction.isUp) {
      return AlignmentDirectional.bottomEnd;
    }
    if (speedDial.direction.isDown) {
      return AlignmentDirectional.topEnd;
    }
    if (speedDial.direction.isLeft) {
      return AlignmentDirectional.centerEnd;
    }
    return AlignmentDirectional.centerStart;
  }

  @override
  Widget build(BuildContext context) {
    if (!open && !controller.isAnimating) {
      return const SizedBox.shrink();
    }

    final children = _visibleChildren;
    final orderedChildren = speedDial.direction.isUp || speedDial.direction.isLeft
        ? children.reversed.toList(growable: false)
        : children;
    final childWidgets = <Widget>[];
    for (var index = 0; index < orderedChildren.length; index++) {
      if (index > 0 && speedDial.spaceBetweenChildren != null) {
        childWidgets.add(
          SizedBox(
            width: speedDial.direction.isHorizontal ? speedDial.spaceBetweenChildren : null,
            height: speedDial.direction.isHorizontal ? null : speedDial.spaceBetweenChildren,
          ),
        );
      }
      childWidgets.add(
        _SpeedDialChildView(
          speedDial: speedDial,
          controller: controller,
          child: orderedChildren[index],
          index: index,
          count: orderedChildren.length,
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      );
    }

    final layout = speedDial.direction.isHorizontal
        ? Row(mainAxisSize: .min, crossAxisAlignment: .center, children: childWidgets)
        : Column(
            mainAxisSize: .min,
            crossAxisAlignment: speedDial.switchLabelPosition
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: childWidgets,
          );

    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: controller, curve: speedDial.curve),
      axis: speedDial.direction.isHorizontal ? Axis.horizontal : Axis.vertical,
      alignment: _alignment,
      child: Padding(padding: _padding, child: layout),
    );
  }
}

class const _SpeedDialMainButton({
  required final SpeedDial speedDial,
  required final AnimationController controller,
  required final bool open,
  required final VoidCallback onPressed,
  required final VoidCallback onLongPress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainChild = speedDial.animatedIcon != null
        ? AnimatedIcon(
            icon: speedDial.animatedIcon!,
            progress: controller,
            color: speedDial.animatedIconTheme?.color,
            size: speedDial.animatedIconTheme?.size,
          )
        : _SpeedDialMainChild(speedDial: speedDial, controller: controller, open: open);
    final backgroundColor = Color.lerp(
      speedDial.backgroundColor,
      speedDial.activeBackgroundColor ?? speedDial.backgroundColor,
      controller.value,
    );
    final foregroundColor = Color.lerp(
      speedDial.foregroundColor,
      speedDial.activeForegroundColor ?? speedDial.foregroundColor,
      controller.value,
    );
    final hasMainLabel = speedDial.label != null || (speedDial.activeLabel != null && open);
    final button = !hasMainLabel
        ? (speedDial.mini
              ? FloatingActionButton.small(
                  tooltip: speedDial.tooltip,
                  heroTag: speedDial.heroTag,
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  elevation: speedDial.elevation,
                  shape: speedDial.shape,
                  onPressed: onPressed,
                  child: mainChild,
                )
              : FloatingActionButton(
                  tooltip: speedDial.tooltip,
                  heroTag: speedDial.heroTag,
                  backgroundColor: backgroundColor,
                  foregroundColor: foregroundColor,
                  elevation: speedDial.elevation,
                  shape: speedDial.shape,
                  onPressed: onPressed,
                  child: mainChild,
                ))
        : FloatingActionButton.extended(
            tooltip: speedDial.tooltip,
            heroTag: speedDial.heroTag,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: speedDial.elevation,
            shape: speedDial.shape,
            onPressed: onPressed,
            icon: mainChild,
            label: AnimatedSwitcher(
              duration: speedDial.animationDuration,
              child: KeyedSubtree(
                key: ValueKey(open),
                child: open ? (speedDial.activeLabel ?? speedDial.label!) : speedDial.label!,
              ),
            ),
          );

    final sizedButton = !hasMainLabel
        ? SizedBox(
            width: speedDial.mini ? 40 : speedDial.buttonSize.width,
            height: speedDial.mini ? 40 : speedDial.buttonSize.height,
            child: button,
          )
        : button;

    return GestureDetector(onLongPress: onLongPress, child: sizedButton);
  }
}

class const _SpeedDialMainChild({
  required final SpeedDial speedDial,
  required final AnimationController controller,
  required final bool open,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedChild = open ? (speedDial.activeChild ?? speedDial.child) : speedDial.child;
    final iconData = open
        ? (speedDial.activeIcon ?? speedDial.icon ?? Icons.close)
        : (speedDial.icon ?? Icons.add);
    final content = selectedChild ?? Icon(iconData);
    final themedContent = speedDial.iconTheme == null
        ? content
        : IconTheme(data: speedDial.iconTheme!, child: content);
    final switcher = AnimatedSwitcher(
      duration: speedDial.animationDuration,
      child: KeyedSubtree(key: ValueKey(open), child: themedContent),
    );

    return !speedDial.useRotationAnimation ||
            (speedDial.activeChild == null && speedDial.activeIcon == null)
        ? switcher
        : Transform.rotate(angle: controller.value * speedDial.animationAngle, child: switcher);
  }
}

class const _SpeedDialDial({
  required final SpeedDial speedDial,
  required final AnimationController controller,
  required final bool open,
  required final VoidCallback onMainPressed,
  required final VoidCallback onMainLongPress,
  required final void Function(SpeedDialChild) onChildTap,
  required final void Function(SpeedDialChild) onChildLongPress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final childLayout = _SpeedDialChildLayout(
      speedDial: speedDial,
      controller: controller,
      open: open,
      onTap: onChildTap,
      onLongPress: onChildLongPress,
    );
    final mainButton = _SpeedDialMainButton(
      speedDial: speedDial,
      controller: controller,
      open: open,
      onPressed: onMainPressed,
      onLongPress: onMainLongPress,
    );

    return speedDial.direction.isUp || speedDial.direction.isLeft
        ? (speedDial.direction.isUp
              ? Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: speedDial.switchLabelPosition
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [childLayout, mainButton],
                )
              : Row(
                  mainAxisSize: .min,
                  crossAxisAlignment: .center,
                  children: [childLayout, mainButton],
                ))
        : (speedDial.direction.isDown
              ? Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: speedDial.switchLabelPosition
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [mainButton, childLayout],
                )
              : Row(
                  mainAxisSize: .min,
                  crossAxisAlignment: .center,
                  children: [mainButton, childLayout],
                ));
  }
}
