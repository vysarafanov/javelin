A identity<A>(A a) => a;

extension FunctionExt<A, B> on B Function(A) {
  B Function(C) compose<C>(A f(C c)) => (c) => this(f(c));
  C Function(A) andThen<C>(C f(B b)) => (a) => f(this(a));
}
