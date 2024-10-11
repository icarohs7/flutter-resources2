/// Simple wrapper used mainly
/// to override the equals implementation
/// of some type without changing the type itself
class NWrapper<T> {
  final T value;
  final bool Function(T thisV, T other)? equals;

  const NWrapper(this.value, {this.equals});

  @override
  bool operator ==(Object other) {
    final compare = (equals ?? (a, b) => a == b);

    return switch (other) {
      NWrapper<T> other => compare(value, other.value),
      T other => compare(value, other),
      _ => false,
    };
  }

  @override
  int get hashCode => value.hashCode;
}
