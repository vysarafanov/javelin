import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class MonadErrorLaws {
  static Iterable<Law> laws<F>(
      MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) sync* {
    yield Law('Monad Error Laws: left zero', () => monadErrorLeftZero(M, EQ));
    yield Law('Monad Error Laws: ensure consistency',
        () => monadErrorEnsureConsistency(M, EQ));
    yield Law('Monad Error Laws: NonFatal is caught',
        () => monadErrorCatchesNonFatalExceptions(M, EQ));
    yield Law(
        'Monad Error Laws: redeemWith is derived from flatMap & HandleErrorWith',
        () => monadErrorDerivesRedeemWith(M, EQ));
    yield Law('Monad Error Laws: redeemWith pure is flatMap',
        () => monadErrorRedeemWithPureIsFlatMap(M, EQ));
  }

  static void monadErrorLeftZero<F>(
          MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(M)),
          Gen.exception(),
          (Kind<F, int> f(int i), Exception e) => M
              .flatMap(M.raiseError<int>(e), f)
              .equalUnderTheLaw(EQ, M.raiseError<int>(e))));

  static void monadErrorEnsureConsistency<F>(
          MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) =>
      check(forall3(
        Gen.integer().apError(M),
        Gen.exception(),
        Gen.functionAtoB<int, bool>(Gen.boolean()),
        (Kind<F, int> fa, Exception e, bool p(int i)) => M
            .ensure(fa, () => e, p)
            .equalUnderTheLaw(
                EQ,
                M.flatMap(fa,
                    (int a) => p(a) ? M.pure<int>(a) : M.raiseError<int>(e))),
      ));

  static void monadErrorCatchesNonFatalExceptions<F>(
          MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) =>
      check(forall(
          Gen.exception(),
          (Exception nonFatal) => M
              .tryCatch<int>(
                () => throw nonFatal,
                identity,
              )
              .equalUnderTheLaw(EQ, M.raiseError<int>(nonFatal))));

  static void monadErrorDerivesRedeemWith<F>(
          MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          Gen.integer().apError(M),
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(M)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(M)),
          (
            Kind<F, int> fa,
            Kind<F, int> fe(Exception e),
            Kind<F, int> fb(int a),
          ) =>
              M.redeemWith(fa, fe, fb).equalUnderTheLaw(
                  EQ, M.handleErrorWith(M.flatMap(fa, fb), fe))));

  static void monadErrorRedeemWithPureIsFlatMap<F>(
          MonadError<F, Exception> M, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          Gen.integer().ap(M),
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(M)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().ap(M)),
          (Kind<F, int> fa, Kind<F, int> fe(Exception e),
                  Kind<F, int> fb(int a)) =>
              M
                  .redeemWith(fa, fe, fb)
                  .equalUnderTheLaw(EQ, M.flatMap(fa, fb))));
  /*

  fun <F> MonadError<F, Throwable>.monadErrorRedeemWithPureIsFlatMap(EQ: Eq<Kind<F, Int>>) =
    forAll(Gen.int().applicative(this),
      Gen.functionAToB<Throwable, Kind<F, Int>>(Gen.int().applicativeError(this)),
      Gen.functionAToB<Int, Kind<F, Int>>(Gen.int().applicative(this))) { fa, fe, fb ->
      fa.redeemWith(fe, fb).equalUnderTheLaw(fa.flatMap(fb), EQ)
    }
    */
}
