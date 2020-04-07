import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/typeclass/instance/either.dart';

class ForEither {
  ForEither._();
}

abstract class Either<L, R> implements Kind<Kind<ForEither, L>, R> {
  static Either<L, R> right<L, R>(R r) => _Right._(r);
  static Either<L, R> left<L, R>(L l) => _Left._(l);

  B fold<B>(B ifLeft(L l), B ifRight(R r));

  static Invariant<Kind<ForEither, L>> invariant<L>() => EitherType<L>();
  static Functor<Kind<ForEither, L>> functor<L>() => EitherType<L>();
  static Applicative<Kind<ForEither, L>> applicative<L>() => EitherType<L>();
  static Monad<Kind<ForEither, L>> monad<L>() => EitherType<L>();

  static Show<Either<L, R>> show<L, R>(Show<L> SL, Show<R> SR) =>
      EitherShow(SL, SR);
  static Eq<Either<L, R>> eq<L, R>(Eq<L> EQL, Eq<R> EQR) => EitherEq(EQL, EQR);
}

extension EitherK<L, R> on Kind<Kind<ForEither, L>, R> {
  Either<L, R> fix() => this as Either<L, R>;
}

class _Left<L, R> extends Either<L, R> {
  final L _l;
  _Left._(this._l);
  L get value => _l;

  @override
  B fold<B>(B ifLeft(L l), B ifRight(R r)) => ifLeft(_l);
}

class _Right<L, R> extends Either<L, R> {
  final R _r;
  _Right._(this._r);
  R get value => _r;

  @override
  B fold<B>(B ifLeft(L l), B ifRight(R r)) => ifRight(_r);
}
