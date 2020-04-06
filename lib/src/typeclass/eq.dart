part of javelin_typeclass;

mixin Eq<F> {
  bool eqv(covariant F a, covariant F b);
}

extension EqExt<F> on Eq<F> {
  bool neqv(F a, F b) => !eqv(a, b);
}
