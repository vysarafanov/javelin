import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';

//final eitherTypeInstance = EitherType<Object>();

class EitherType<L>
    with
        Invariant<Kind<ForEither, L>>,
        Functor<Kind<ForEither, L>>,
        Apply<Kind<ForEither, L>>,
        Applicative<Kind<ForEither, L>>,
        ApplicativeError<Kind<ForEither, L>, L>,
        Monad<Kind<ForEither, L>> {
  ///Applicative
  @override
  Kind<Kind<ForEither, L>, A> pure<A>(A r) => Either.right<L, A>(r);

  ///ApplicativeError
  @override
  Kind<Kind<ForEither, L>, A> raiseError<A>(L e) => Either.left<L, A>(e);
  @override
  Kind<Kind<ForEither, L>, A> handleErrorWith<A>(
    Kind<Kind<ForEither, L>, A> fa,
    Kind<Kind<ForEither, L>, A> f(L e),
  ) =>
      fa.fix().fold(f, (r) => fa);

  ///Monad
  @override
  Kind<Kind<ForEither, L>, B> flatMap<A, B>(
    Kind<Kind<ForEither, L>, A> fa,
    Kind<Kind<ForEither, L>, B> f(A a),
  ) =>
      fa.fix().fold((l) => Either.left(l), f);
}

extension EitherExt<L, A> on Either<L, A> {
  Either<L, B> map<B>(B f(A a)) => Either.functor<L>().map(this, f);
  Either<L, B> flatMap<B>(Either<L, B> f(A a)) =>
      Either.monad<L>().flatMap(this, f);
  String show(Show<L> SL, Show<A> SA) => Either.show(SL, SA).show(this);
  bool eq(Eq<L> EQL, Eq<A> EQA, Either<L, A> other) =>
      Either.eq(EQL, EQA).eqv(this, other);
}

/*
* Show instance for Either datatype
*/
class EitherShow<L, R> implements Show<Either<L, R>> {
  final Show<L> SL;
  final Show<R> SR;
  const EitherShow(this.SL, this.SR);

  @override
  String show(Either<L, R> fa) => fa.fold(
        (l) => 'Left(${SL.show(l)})',
        (value) => 'Right(${SR.show(value)})',
      );
}

/*
* Eq instance for Either datatype
*/
class EitherEq<L, R> implements Eq<Either<L, R>> {
  final Eq<L> EQL;
  final Eq<R> EQR;

  const EitherEq(this.EQL, this.EQR);

  @override
  bool eqv(Either<L, R> fa, Either<L, R> fb) => fa.fold(
      (la) => fb.fold(
            (lb) => EQL.eqv(la, lb),
            (_) => false,
          ),
      (ra) => fb.fold(
            (_) => false,
            (rb) => EQR.eqv(ra, rb),
          ));
}
