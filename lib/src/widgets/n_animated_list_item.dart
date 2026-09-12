import 'dart:async';

import 'package:core_resources/core_resources.dart';
import 'package:material_ui/material_ui.dart';

/// Animates a list item with a staggered fade-in and upward slide.
class const NAnimatedListItem({
  /// The index used to calculate this item's stagger delay.
  required final int index,

  /// The widget to animate.
  required final Widget child,

  /// The delay added for each item index.
  final Duration delayPerItem = const Duration(milliseconds: 40),

  /// The maximum delay before the animation starts.
  final Duration maxDelay = const Duration(milliseconds: 300),

  /// The fade and slide animation duration.
  final Duration duration = const Duration(milliseconds: 375),
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);

    useEffect(() {
      final delayMs = (index * delayPerItem.inMilliseconds).clamp(0, maxDelay.inMilliseconds);
      final timer = Timer(.new(milliseconds: delayMs), () => controller.forward());
      return timer.cancel;
    }, const []);

    final opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
