part of javelin_typeclass;

mixin Bifunctor<F> {
  Kind<Kind<F, C>, D> bimap<A, B, C, D>(
    Kind<Kind<F, A>, B> fa,
    C fl(A a),
    D fr(B b),
  );

  ///Extension functions
  Kind<Kind<F, C>, D> Function(Kind<Kind<F, A>, B>) lift<A, B, C, D>(
          C fl(A a), D fr(B b)) =>
      (Kind<Kind<F, A>, B> fab) => bimap<A, B, C, D>(fab, fl, fr);

  Kind<Kind<F, C>, B> mapLeft<A, B, C>(Kind<Kind<F, A>, B> fa, C f(A a)) =>
      bimap(fa, f, identity);

  RightFunctor<F, X> rightFunctor<X>() => RightFunctor(this);
}

class RightFunctor<F, X> with Invariant<Kind<F, X>>, Functor<Kind<F, X>> {
  final Bifunctor<F> _f;

  RightFunctor(this._f);

  @override
  Kind<Kind<F, X>, B> map<A, B>(Kind<Kind<F, X>, A> fa, B f(A a)) =>
      _f.bimap(fa, identity, f);
}
