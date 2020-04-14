part of datatype_mtl;

class ForEitherT {
  ForEitherT._();
}

class EitherT<F, L, R> implements Kind<Kind<Kind<ForEitherT, F>, L>, R> {
  final Kind<F, Either<L, R>> value;

  EitherT(this.value);

  static EitherT<F, L, R> right<F, L, R>(Applicative<F> AF, R r) =>
      EitherT(AF.pure(Either.right(r)));

  static EitherT<F, L, R> left<F, L, R>(Applicative<F> AF, L l) =>
      EitherT(AF.pure(Either.left(l)));

  EitherT<F, L, B> map<B>(Functor<F> FF, B f(R a)) =>
      EitherT(FF.map(value, (Either<L, R> a) => a.map(f)));

  EitherT<F, L, B> ap<B>(
          Monad<F> MF, Kind<Kind<Kind<ForEitherT, F>, L>, B Function(R)> ff) =>
      flatMap(MF, (R a) => ff.fix().map(MF, (f) => f(a)));

  EitherT<F, L, B> flatMap<B>(
          Monad<F> MF, Kind<Kind<Kind<ForEitherT, F>, L>, B> f(R a)) =>
      flatMapF(MF, (a) => f(a).fix().value);

  EitherT<F, L, B> flatMapF<B>(Monad<F> MF, Kind<F, Either<L, B>> f(R a)) =>
      EitherT(MF.flatMap(
          value,
          (Either<L, R> either) => either.fold(
                (l) => MF.pure(Either.left(l)),
                f,
              )));

  @override
  String toString() => value.toString();
  @override
  bool operator ==(other) => other is EitherT<F, L, R> && value == other.value;
  @override
  int get hashCode => value.hashCode;

  static Functor<Kind<Kind<ForEitherT, F>, L>> functor<F, L>(Functor<F> FF) =>
      EitherTFunctor(FF);

  static Applicative<Kind<Kind<ForEitherT, F>, L>> applicative<F, L>(
          Monad<F> MF) =>
      EitherTMonadError(MF);
  static ApplicativeError<Kind<Kind<ForEitherT, F>, L>, L>
      applicativeError<F, L>(Monad<F> MF) => EitherTMonadError(MF);
  static Monad<Kind<Kind<ForEitherT, F>, L>> monad<F, L>(Monad<F> MF) =>
      EitherTMonadError(MF);
  static MonadError<Kind<Kind<ForEitherT, F>, L>, L> monadError<F, L>(
          Monad<F> MF) =>
      EitherTMonadError(MF);

  static ApplicativeError<Kind<Kind<ForEitherT, F>, L>, E>
      applicativeErrorF<F, L, E>(MonadError<F, E> ME) => EitherTMonadErrorF(ME);
  static MonadError<Kind<Kind<ForEitherT, F>, L>, E> monadErrorF<F, L, E>(
          MonadError<F, E> ME) =>
      EitherTMonadErrorF(ME);

  static Show<EitherT<F, L, R>> show<F, L, R>() => EitherTShow();
  static Eq<EitherT<F, L, R>> eq<F, L, R>() => EitherTEq();
}

extension EitherTK<F, L, R> on Kind<Kind<Kind<ForEitherT, F>, L>, R> {
  EitherT<F, L, R> fix() => this as EitherT<F, L, R>;
}
