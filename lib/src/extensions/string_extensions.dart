import 'package:core_resources/core_resources.dart';

extension NStringExtensions on String {
  /// Capitalize the first letter of each word
  /// of the given string
  ///
  /// 'hello world'.toTitleCase() // Hello World
  /// 'hELLO wORLD'.toTitleCase() // Hello World
  String toTitleCase() => toLowerCase()
      .replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');

  /// Returns whether this string has only digits
  bool get isNumericOnly => hasMatch(r'^\d+$');

  /// Returns whether there's any match of the given [pattern]
  /// on this string
  bool hasMatch(String pattern) {
    return RegExp(pattern).hasMatch(this);
  }
}
