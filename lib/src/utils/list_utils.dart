import 'package:core_resources/core_resources.dart';

/// Return a list composed by non-nullable
/// items from the given iterable
List<T> notNullListFrom<T>(Iterable<T?> items) {
  return items.whereNotNull().toList();
}
