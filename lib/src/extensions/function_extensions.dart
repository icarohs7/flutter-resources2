/// Compose this unary function with [fn].
extension NUnaryExtensions<A, B> on B Function(A) {
  /// `pipe(g)` is `(x) => g(this(x))`.
  C Function(A x) pipe<C>(C Function(B y) fn) =>
      (A x) => fn(this(x));
}

/// Function curry helpers adapted from [fpdart](https://pub.dev/packages/fpdart)
/// (MIT, Sandro Maglione). Getters (not dartx's `.curry()` methods).
extension NCurryExtension2<Input1, Input2, Output> on Output Function(Input1, Input2) {
  /// Curry the first parameter: `f.curry(a)(b) == f(a, b)`.
  Output Function(Input2) Function(Input1) get curry =>
      (input1) =>
          (input2) => this(input1, input2);

  /// Curry the last parameter: `f.curryLast(b)(a) == f(a, b)`.
  Output Function(Input1) Function(Input2) get curryLast =>
      (input2) =>
          (input1) => this(input1, input2);
}

/// Ternary curry helpers adapted from [fpdart](https://pub.dev/packages/fpdart)
/// (MIT, Sandro Maglione).
extension NCurryExtension3<Input1, Input2, Input3, Output>
    on Output Function(Input1, Input2, Input3) {
  /// Curry the first parameter: `f.curry(a)(b, c) == f(a, b, c)`.
  Output Function(Input2, Input3) Function(Input1) get curry =>
      (input1) =>
          (input2, input3) => this(input1, input2, input3);

  /// Curry the last parameter: `f.curryLast(c)(a, b) == f(a, b, c)`.
  Output Function(Input1, Input2) Function(Input3) get curryLast =>
      (input3) =>
          (input1, input2) => this(input1, input2, input3);
}
