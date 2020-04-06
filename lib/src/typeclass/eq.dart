part of javelin_typeclass;

mixin Eq<F> {
  bool eqv<A>(covariant Kind<F, A> a, covariant Kind<F, A> b);
}

extension EqExt<F> on Eq<F> {
  bool neqv<A>(Kind<F, A> a, Kind<F, A> b) => !eqv(a, b);
}
