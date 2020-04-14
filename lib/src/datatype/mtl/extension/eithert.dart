import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_mtl.dart';
import 'package:javelin/src/typeclass.dart';

class EitherTFunctor<F, L>
    with
        Invariant<Kind<Kind<ForEitherT, F>, L>>,
        Functor<Kind<Kind<ForEitherT, F>, L>> {
  final Functor<F> FF;

  EitherTFunctor(this.FF);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> map<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa, B f(A a)) =>
      fa.fix().map(FF, f);
}

class EitherTMonadError<F, L>
    with
        Invariant<Kind<Kind<ForEitherT, F>, L>>,
        Functor<Kind<Kind<ForEitherT, F>, L>>,
        Apply<Kind<Kind<ForEitherT, F>, L>>,
        Applicative<Kind<Kind<ForEitherT, F>, L>>,
        ApplicativeError<Kind<Kind<ForEitherT, F>, L>, L>,
        Monad<Kind<Kind<ForEitherT, F>, L>>,
        MonadError<Kind<Kind<ForEitherT, F>, L>, L> {
  final Monad<F> MF;
  EitherTMonadError(this.MF);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, A> pure<A>(A a) =>
      EitherT(MF.pure(Either.right(a)));

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> flatMap<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, B> f(A a)) =>
      fa.fix().flatMap(MF, f);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, R> raiseError<R>(L e) =>
      EitherT.left(MF, e);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, R> handleErrorWith<R>(
          Kind<Kind<Kind<ForEitherT, F>, L>, R> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, R> f(L e)) =>
      EitherT(
        MF.flatMap(
            fa.fix().value,
            (Either<L, R> either) => either.fold(
                  (l) => f(l).fix().value,
                  (r) => fa.fix().value,
                )),
      );
}

class EitherTMonadErrorF<F, L, E>
    with
        Invariant<Kind<Kind<ForEitherT, F>, L>>,
        Functor<Kind<Kind<ForEitherT, F>, L>>,
        Apply<Kind<Kind<ForEitherT, F>, L>>,
        Applicative<Kind<Kind<ForEitherT, F>, L>>,
        ApplicativeError<Kind<Kind<ForEitherT, F>, L>, E>,
        Monad<Kind<Kind<ForEitherT, F>, L>>,
        MonadError<Kind<Kind<ForEitherT, F>, L>, E> {
  final MonadError<F, E> ME;
  EitherTMonadErrorF(this.ME);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, A> pure<A>(A a) =>
      EitherT(ME.pure(Either.right(a)));

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> flatMap<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, B> f(A a)) =>
      fa.fix().flatMap(ME, f);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, R> raiseError<R>(E e) =>
      EitherT(ME.raiseError(e));

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, R> handleErrorWith<R>(
          Kind<Kind<Kind<ForEitherT, F>, L>, R> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, R> f(E e)) =>
      EitherT(ME.handleErrorWith(fa.fix().value, (e) => f(e).fix().value));
}

class EitherTShow<F, L, R> implements Show<EitherT<F, L, R>> {
  const EitherTShow();

  @override
  String show(EitherT<F, L, R> fa) => fa.toString();
}

class EitherTEq<F, L, R> implements Eq<EitherT<F, L, R>> {
  const EitherTEq();

  @override
  bool eqv(EitherT<F, L, R> fa, EitherT<F, L, R> fb) => fa == fb;
}

/*
class EitherTApplicative<F, L>
    with
        Invariant<Kind<Kind<ForEitherT, F>, L>>,
        Functor<Kind<Kind<ForEitherT, F>, L>>,
        Apply<Kind<Kind<ForEitherT, F>, L>>,
        Applicative<Kind<Kind<ForEitherT, F>, L>> {
  final Monad<F> MF;
  EitherTApplicative(this.MF);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> map<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa, B f(A a)) =>
      fa.fix().map(MF, f);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, A> pure<A>(A a) =>
      EitherT(MF.pure(Either.right(a)));

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> ap<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, B Function(A)> ff) =>
      fa.fix().ap(MF, ff);
}

class EitherTMonad<F, L>
    with
        Invariant<Kind<Kind<ForEitherT, F>, L>>,
        Functor<Kind<Kind<ForEitherT, F>, L>>,
        Apply<Kind<Kind<ForEitherT, F>, L>>,
        Applicative<Kind<Kind<ForEitherT, F>, L>>,
        Monad<Kind<Kind<ForEitherT, F>, L>> {
  final Monad<F> MF;
  EitherTMonad(this.MF);

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, A> pure<A>(A a) =>
      EitherT(MF.pure(Either.right(a)));

  @override
  Kind<Kind<Kind<ForEitherT, F>, L>, B> flatMap<A, B>(
          Kind<Kind<Kind<ForEitherT, F>, L>, A> fa,
          Kind<Kind<Kind<ForEitherT, F>, L>, B> f(A a)) =>
      fa.fix().flatMap(MF, f);
}

*/
