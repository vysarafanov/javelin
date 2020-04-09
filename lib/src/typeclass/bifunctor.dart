part of javelin_typeclass;

mixin Bifunctor<F> {
  Kind<Kind<F, C>, D> bimap<A, B, C, D>(
      Kind<Kind<F, A>, B> fa, C fl(A a), D fr(B b));
}
