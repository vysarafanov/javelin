part of javelin_typeclass;

mixin ApplicativeError<F, E> on Applicative<F> {
  Kind<F, A> raiseError<A>(E e);

  Kind<F, A> handleErrorWith<A>(Kind<F, A> fa, Kind<F, A> f(E e));

  ///Extension functions
  Kind<F, A> handleError<A>(Kind<F, A> fa, A f(E e)) =>
      handleErrorWith(fa, (E e) => pure(f(e)));

  Kind<F, B> redeem<A, B>(Kind<F, A> fa, B fe(E e), B fb(A b)) =>
      handleError(map(fa, fb), fe);

  Kind<F, Either<E, A>> attempt<A>(Kind<F, A> fa) => handleErrorWith(
        map(fa, Either.right),
        (e) => pure(Either.left(e)),
      );

  Kind<F, A> tryCatch<A>(A f(), E recover(Exception e)) {
    try {
      return pure(f());
    } catch (e) {
      return raiseError(recover(e));
    }
  }
}
