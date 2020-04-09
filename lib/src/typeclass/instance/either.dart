import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';

//final eitherTypeInstance = EitherType<Object>();

class EitherType<L>
    with
        Invariant<Kind<ForEither, L>>,
        Functor<Kind<ForEither, L>>,
        Bifunctor<ForEither>,
        Apply<Kind<ForEither, L>>,
        Applicative<Kind<ForEither, L>>,
        ApplicativeError<Kind<ForEither, L>, L>,
        Monad<Kind<ForEither, L>> {
  ///Applicative
  @override
  Kind<Kind<ForEither, L>, A> pure<A>(A r) => Either.right<L, A>(r);

  ///Bifunctor
  ///
  @override
  Kind<Kind<ForEither, C>, D> bimap<A, B, C, D>(
          Kind<Kind<ForEither, A>, B> fa, C fl(A a), D fr(B b)) =>
      fa.fix().fold((A l) => Either.left<C, D>(fl(l)),
          (B r) => Either.right<C, D>(fr(r)));

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
  String show() => Either.show().show(this);
  bool eq(Either<L, A> other) => Either.eq().eqv(this, other);
}

/*
* Show instance for Either datatype
*/
class EitherShow<L, R> implements Show<Either<L, R>> {
  const EitherShow();

  @override
  String show(Either<L, R> fa) => fa.toString();
}

/*
* Eq instance for Either datatype
*/
class EitherEq<L, R> implements Eq<Either<L, R>> {
  const EitherEq();

  @override
  bool eqv(Either<L, R> fa, Either<L, R> fb) => fa == fb;
}
