extension NIterableExtensions<T> on Iterable<T> {
  T operator [](int index) => elementAt(index);
}

extension NNullableIterableExtensions<T> on Iterable<T>? {
  Iterable<T> orEmpty() => this ?? <T>[];

  Iterable<T> ifEmpty(Iterable<T> Function() value) {
    final thiss = this;
    if (thiss != null && thiss.isNotEmpty) return thiss;
    return value();
  }
}