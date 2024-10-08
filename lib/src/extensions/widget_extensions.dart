import 'package:flutter/material.dart';

extension NWidgetExtensions on Widget {
  Widget withPadding({
    double? all,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? vertical,
    double? horizontal,
  }) =>
      Padding(
        padding: all != null
            ? EdgeInsets.all(all)
            : top != null || right != null || bottom != null || left != null
            ? EdgeInsets.only(
            top: top ?? 0.0, right: right ?? 0.0, bottom: bottom ?? 0.0, left: left ?? 0.0)
            : EdgeInsets.symmetric(vertical: vertical ?? 0.0, horizontal: horizontal ?? 0.0),
        child: this,
      );

  Widget withSliverPadding({
    double? all,
    double? top,
    double? right,
    double? bottom,
    double? left,
    double? vertical,
    double? horizontal,
  }) =>
      SliverPadding(
        padding: all != null
            ? EdgeInsets.all(all)
            : top != null || right != null || bottom != null || left != null
            ? EdgeInsets.only(
            top: top ?? 0.0, right: right ?? 0.0, bottom: bottom ?? 0.0, left: left ?? 0.0)
            : EdgeInsets.symmetric(vertical: vertical ?? 0.0, horizontal: horizontal ?? 0.0),
        sliver: this,
      );
}
