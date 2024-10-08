import 'package:flutter/material.dart';

extension NContextExtensions on BuildContext {
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
