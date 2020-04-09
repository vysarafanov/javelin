part of javelin_typeclass;

mixin MonadError<F, E> on ApplicativeError<F, E>, Monad<F> {
  Kind<F, A> ensure<A>(Kind<F, A> fa, E error(), bool predicate(A a)) =>
      flatMap(
        fa,
        (a) => predicate(a) ? pure(a) : raiseError(error()),
      );

  Kind<F, B> redeemWith<A, B>(
          Kind<F, A> fa, Kind<F, B> fe(E e), Kind<F, B> fb(A a)) =>
      handleErrorWith(
        flatMap(fa, fb),
        fe,
      );

  Kind<F, A> reThrow<A>(Kind<F, Either<E, A>> fEither) =>
      flatMap<Either<E, A>, A>(fEither,
          (either) => either.fold((l) => raiseError<A>(l), (a) => pure(a)));
}
