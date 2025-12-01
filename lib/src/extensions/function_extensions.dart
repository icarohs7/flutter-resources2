extension NUnaryExtensions<A, B> on B Function(A) {
  C Function(A x) pipe<C>(C Function(B y) fn) =>
      (A x) => fn(this(x));
}
