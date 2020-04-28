part of datatype_core;

class ForEither {
  ForEither._();
}

abstract class Either<L, R> implements Kind<Kind<ForEither, L>, R> {
  static Either<L, R> right<L, R>(R r) => _Right._(r);
  static Either<L, R> left<L, R>(L l) => _Left._(l);
  static Either<Exception, R> tryCatch<R>(R f()) {
    try {
      return Either.right(f());
    } catch (e) {
      return Either.left(e);
    }
  }

  B fold<B>(B ifLeft(L l), B ifRight(R r));

  static Invariant<Kind<ForEither, L>> invariant<L>() => EitherType<L>();
  static Functor<Kind<ForEither, L>> functor<L>() => EitherType<L>();
  static Bifunctor<ForEither> bifunctor<L>() => EitherType<L>();
  static Applicative<Kind<ForEither, L>> applicative<L>() => EitherType<L>();
  static ApplicativeError<Kind<ForEither, L>, L> applicativeError<L>() =>
      EitherType<L>();
  static Monad<Kind<ForEither, L>> monad<L>() => EitherType<L>();
  static MonadError<Kind<ForEither, L>, L> monadError<L>() => EitherType<L>();
  static Foldable<Kind<ForEither, L>> foldable<L>() => EitherType<L>();
  static Traverse<Kind<ForEither, L>> traverse<L>() => EitherType<L>();
  static Show<Either<L, R>> show<L, R>() => EitherShow();
  static Eq<Either<L, R>> eq<L, R>() => EitherEq();
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

  @override
  String toString() => 'Left($_l)';
  @override
  bool operator ==(other) => other is _Left<L, R> && other._l == _l;
  @override
  int get hashCode => _l.hashCode;
}

class _Right<L, R> extends Either<L, R> {
  final R _r;
  _Right._(this._r);
  R get value => _r;

  @override
  B fold<B>(B ifLeft(L l), B ifRight(R r)) => ifRight(_r);

  @override
  String toString() => 'Right($_r)';
  @override
  bool operator ==(other) => other is _Right<L, R> && other._r == _r;
  @override
  int get hashCode => _r.hashCode;
}

extension EitherExt<L, A> on Either<L, A> {
  Either<L, B> map<B>(B f(A a)) => Either.functor<L>().map(this, f);
  Either<L, B> flatMap<B>(Either<L, B> f(A a)) =>
      Either.monad<L>().flatMap(this, f);
  String show() => Either.show().show(this);
  bool eq(Either<L, A> other) => Either.eq().eqv(this, other);
  // Kind<F, Either<L, B>> traverse<F, B>(Applicative<F> AF, Kind<F, B> f(A a)) =>
  //     Either.traverse().traverse(this, AF, f);
}
