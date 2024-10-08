extension NMapExtensions<K, V> on Map<K, V> {
  /// Returns a lazy iterable with a list of all
  /// elements contained within each key in [keys]
  Iterable<V> getValues(Iterable<K> keys) sync* {
    for (final key in keys) {
      final value = this[key];
      if (value != null) yield value;
    }
  }
}
