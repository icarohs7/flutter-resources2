import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';

extension NContextExtensions on BuildContext {
  ColorScheme get colorScheme => theme.colorScheme;

  Color get secondaryColor => colorScheme.secondary;
}
