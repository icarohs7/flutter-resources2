import 'package:flutter/material.dart';

class NTransitions {
  static Widget scale(child, value, {Alignment alignment = Alignment.center}) {
    return ScaleTransition(
      scale: value,
      child: child,
      alignment: alignment,
    );
  }

  static Widget fade(child, value) {
    return FadeTransition(
      opacity: value,
      child: child,
    );
  }

  static Widget topToBottomExpansion(child, value) {
    return SizeTransition(
      sizeFactor: value,
      axis: Axis.vertical,
      axisAlignment: -1,
      child: child,
    );
  }
}
