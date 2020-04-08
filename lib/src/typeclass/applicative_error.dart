part of javelin_typeclass;

mixin ApplicativeError<F, E> on Applicative<F> {
  Kind<F, A> raiseError<A>(E e);

  Kind<F, A> handleErrorWith<A>(Kind<F, A> fa, Kind<F, A> f(E e));
}

extension ApplicationErrorExt<F, E> on ApplicativeError<F, E> {
  Kind<F, A> handleError<A>(Kind<F, A> fa, A f(E e)) =>
      handleErrorWith(fa, ([e]) => pure(f(e)));
}
