import 'dart:ui';

extension NColorExtensions on Color {
  /// A 32 bit value representing this color.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  get rgba {
    return _floatToInt8(a) << 24 |
    _floatToInt8(r) << 16 |
    _floatToInt8(g) << 8 |
    _floatToInt8(b) << 0;
  }

  Color withAlphaDecimal(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}