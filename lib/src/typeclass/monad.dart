part of javelin_typeclass;

mixin Monad<F> on Applicative<F> {
  Kind<F, B> flatMap<A, B>(covariant Kind<F, A> fa, Kind<F, B> f(A a));

  @override
  Kind<F, B> ap<A, B>(Kind<F, A> fa, Kind<F, B Function(A)> ff) =>
      flatMap(ff, (f) => map(fa, f));
}
