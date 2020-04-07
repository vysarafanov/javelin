part of javelin_typeclass;

mixin Monad<F> on Applicative<F> {
  Kind<F, B> flatMap<A, B>(Kind<F, A> fa, Kind<F, B> f(A a));

  @override
  Kind<F, B> ap<A, B>(Kind<F, A> fa, Kind<F, B Function(A)> ff) =>
      flatMap(ff, (f) => map(fa, f));

  @override
  Kind<F, B> map<A, B>(Kind<F, A> fa, B f(A a)) =>
      flatMap(fa, (a) => pure(f(a)));
}
