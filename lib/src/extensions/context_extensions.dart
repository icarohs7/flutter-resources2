import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

extension NContextExtensions on BuildContext {
  ColorScheme get colorScheme => theme.colorScheme;

  Color get secondaryColor => colorScheme.secondary;

  /// Checks if the sliver is collapsed by comparing the current extent to the min extent.
  bool get isSliverCollapsed {
    final settings = dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return false;
    return settings.currentExtent <= settings.minExtent + 1;
  }
}
