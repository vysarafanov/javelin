part of typeclass;

mixin Foldable<F> {
  B foldLeft<A, B>(
    Kind<F, A> fa,
    B b,
    B f(B b, A a),
  );

  B foldRight<A, B>(
    Kind<F, A> fa,
    B b,
    B f(A a, B b),
  );
}

extension FoldableExt<F> on Foldable<F> {
  A fold<A>(Kind<F, A> fa, Monoid<A> MN) =>
      foldLeft(fa, MN.empty(), (acc, a) => MN.combine(acc, a));

  B foldMap<A, B>(Kind<F, A> fa, Monoid<B> MN, B f(A a)) =>
      foldLeft(fa, MN.empty(), (b, a) => MN.combine(b, f(a)));
}
