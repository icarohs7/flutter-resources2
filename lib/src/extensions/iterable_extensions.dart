extension NIterableExtensions<T> on Iterable<T> {
  /// Index into this iterable (`this[i]` == [elementAt]).
  T operator [](int index) => elementAt(index);

  /// For each element apply [toElements] and flatten the result.
  ///
  /// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
  Iterable<B> flatMap<B>(Iterable<B> Function(T t) toElements) => expand(toElements);

  /// Whether every element satisfies [test].
  ///
  /// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
  bool all(bool Function(T t) test) => every(test);

  /// Split into (false matches, true matches).
  ///
  /// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
  /// Prefer this over dartx's [Iterable.partition], which returns `List<List>`.
  (Iterable<T>, Iterable<T>) partition(bool Function(T t) test) =>
      (where((e) => !test(e)), where(test));

  /// Insert all elements of [other] at the beginning of this iterable.
  ///
  /// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
  Iterable<T> prependAll(Iterable<T> other) => other.followedBy(this);

  /// Remove the first occurrence of [element].
  ///
  /// Adapted from [fpdart](https://pub.dev/packages/fpdart) (MIT, Sandro Maglione).
  Iterable<T> delete(T element) sync* {
    var deleted = false;
    for (final current in this) {
      if (deleted || current != element) {
        yield current;
      } else {
        deleted = true;
      }
    }
  }
}

extension NNullableIterableExtensions<T> on Iterable<T>? {
  /// This iterable, or an empty one when `null`.
  Iterable<T> orEmpty() => this ?? <T>[];

  /// This iterable when non-null and non-empty; otherwise [value].
  Iterable<T> ifEmpty(Iterable<T> Function() value) {
    final thiss = this;
    if (thiss != null && thiss.isNotEmpty) return thiss;
    return value();
  }
}
