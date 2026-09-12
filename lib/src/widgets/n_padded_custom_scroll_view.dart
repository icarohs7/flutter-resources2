import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// A [CustomScrollView] that automatically appends bottom safe-area padding.
///
/// When [autoBottomPadding] is enabled, the widget appends a [SliverPadding]
/// whose bottom inset is [MediaQuery.paddingOf(context).bottom]. This keeps
/// the final sliver visible above floating navigation bars and other bottom
/// overlays that expose their occupied height through the media query.
///
/// Set [autoBottomPadding] to `false` when the last sliver is a
/// [SliverFillRemaining] with [SliverFillRemaining.hasScrollBody] set to
/// `false`, since a trailing sliver would break its fill-remaining-viewport
/// contract.
class const NPaddedCustomScrollView({
  required final List<Widget> slivers,
  final ScrollController? controller,
  final ScrollPhysics? physics,
  final Axis scrollDirection = Axis.vertical,
  final bool reverse = false,
  final bool shrinkWrap = false,
  final Key? center,
  final double? anchor,
  final ScrollCacheExtent? scrollCacheExtent,
  final int? semanticChildCount,
  final DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
      ScrollViewKeyboardDismissBehavior.manual,
  final String? restorationId,
  final Clip clipBehavior = Clip.hardEdge,

  /// Whether to append bottom padding from [MediaQuery.paddingOf].
  final bool autoBottomPadding = true,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final effectiveSlivers = [...slivers];

    if (autoBottomPadding && effectiveSlivers.isNotEmpty) {
      final last = effectiveSlivers.last;
      final skip = last is SliverFillRemaining && !last.hasScrollBody;

      if (!skip) {
        effectiveSlivers.add(
          SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom)),
        );
      }
    }

    return CustomScrollView(
      scrollCacheExtent: scrollCacheExtent,
      controller: controller,
      physics: physics,
      scrollDirection: scrollDirection,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      center: center,
      anchor: anchor ?? 0.0,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      slivers: effectiveSlivers,
    );
  }
}
