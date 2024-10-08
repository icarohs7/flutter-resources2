import 'package:core_resources/core_resources.dart';

extension NStringCasingExtension on String {
  /// Capitalize the first letter of each word
  /// of the given string
  ///
  /// 'hello world'.toTitleCase() // Hello World
  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.capitalize()).join(' ');
}
