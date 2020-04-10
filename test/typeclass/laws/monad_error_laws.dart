import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class MonadErrorLaws {
  static Iterable<Law> laws<F>(
      MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) sync* {
    yield Law('Monad Error Laws: left zero', () => monadErrorLeftZero(ME, EQ));
    yield Law('Monad Error Laws: ensure consistency',
        () => monadErrorEnsureConsistency(ME, EQ));
    yield Law('Monad Error Laws: NonFatal is caught',
        () => monadErrorCatchesNonFatalExceptions(ME, EQ));
    yield Law(
        'Monad Error Laws: redeemWith is derived from flatMap & HandleErrorWith',
        () => monadErrorDerivesRedeemWith(ME, EQ));
    yield Law('Monad Error Laws: redeemWith pure is flatMap',
        () => monadErrorRedeemWithPureIsFlatMap(ME, EQ));
  }

  static void monadErrorLeftZero<F>(
          MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(ME)),
          Gen.exception(),
          (Kind<F, int> f(int i), Exception e) => ME
              .flatMap(ME.raiseError<int>(e), f)
              .equalUnderTheLaw(EQ, ME.raiseError<int>(e))));

  static void monadErrorEnsureConsistency<F>(
          MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) =>
      check(forall3(
        Gen.integer().apError(ME),
        Gen.exception(),
        Gen.functionAtoB<int, bool>(Gen.boolean()),
        (Kind<F, int> fa, Exception e, bool p(int i)) => ME
            .ensure(fa, () => e, p)
            .equalUnderTheLaw(
                EQ,
                ME.flatMap(fa,
                    (int a) => p(a) ? ME.pure<int>(a) : ME.raiseError<int>(e))),
      ));

  static void monadErrorCatchesNonFatalExceptions<F>(
          MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) =>
      check(forall(
          Gen.exception(),
          (Exception nonFatal) => ME
              .tryCatch<int>(
                () => throw nonFatal,
                identity,
              )
              .equalUnderTheLaw(EQ, ME.raiseError<int>(nonFatal))));

  static void monadErrorDerivesRedeemWith<F>(
          MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          Gen.integer().apError(ME),
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(ME)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(ME)),
          (
            Kind<F, int> fa,
            Kind<F, int> fe(Exception e),
            Kind<F, int> fb(int a),
          ) =>
              ME.redeemWith(fa, fe, fb).equalUnderTheLaw(
                  EQ, ME.handleErrorWith(ME.flatMap(fa, fb), fe))));

  static void monadErrorRedeemWithPureIsFlatMap<F>(
          MonadError<F, Exception> ME, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          Gen.integer().ap(ME),
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(ME)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().ap(ME)),
          (Kind<F, int> fa, Kind<F, int> fe(Exception e),
                  Kind<F, int> fb(int a)) =>
              ME
                  .redeemWith(fa, fe, fb)
                  .equalUnderTheLaw(EQ, ME.flatMap(fa, fb))));
  /*

  fun <F> MonadError<F, Throwable>.monadErrorRedeemWithPureIsFlatMap(EQ: Eq<Kind<F, Int>>) =
    forAll(Gen.int().applicative(this),
      Gen.functionAToB<Throwable, Kind<F, Int>>(Gen.int().applicativeError(this)),
      Gen.functionAToB<Int, Kind<F, Int>>(Gen.int().applicative(this))) { fa, fe, fb ->
      fa.redeemWith(fe, fb).equalUnderTheLaw(fa.flatMap(fb), EQ)
    }
    */
}
