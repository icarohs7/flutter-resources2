import 'package:flutter/material.dart';

/// Padding and sliver helpers for any [Widget].
extension NWidgetExtensions on Widget {
  /// Wraps this widget in [Padding].
  ///
  /// Inset resolution order:
  /// 1. [all] — [EdgeInsets.all]
  /// 2. any of [top], [right], [bottom], [left] — [EdgeInsets.only] (unset sides are zero)
  /// 3. otherwise — [EdgeInsets.symmetric] with [vertical] and [horizontal] (default zero)
  Widget withPadding({
    double? all,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? vertical,
    double? horizontal,
  }) => Padding(
    padding: all != null
        ? .all(all)
        : top != null || right != null || bottom != null || left != null
        ? .only(top: top ?? 0.0, right: right ?? 0.0, bottom: bottom ?? 0.0, left: left ?? 0.0)
        : .symmetric(vertical: vertical ?? 0.0, horizontal: horizontal ?? 0.0),
    child: this,
  );

  /// Wraps this widget in [SliverPadding] using the same inset rules as [withPadding].
  ///
  /// The receiver should already be a sliver widget (for example [SliverList]).
  Widget withSliverPadding({
    double? all,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? vertical,
    double? horizontal,
  }) => SliverPadding(
    padding: all != null
        ? .all(all)
        : top != null || right != null || bottom != null || left != null
        ? .only(top: top ?? 0.0, right: right ?? 0.0, bottom: bottom ?? 0.0, left: left ?? 0.0)
        : .symmetric(vertical: vertical ?? 0.0, horizontal: horizontal ?? 0.0),
    sliver: this,
  );

  /// Wraps this widget in [SliverToBoxAdapter] for use in a [CustomScrollView].
  SliverToBoxAdapter toSliver() => SliverToBoxAdapter(child: this);
}
