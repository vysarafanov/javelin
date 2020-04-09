import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class ApplicativeErrorLaws {
  static Iterable<Law> laws<F>(
      ApplicativeError<F, Exception> AE,
      Eq<Kind<F, int>> EQ,
      Eq<Kind<F, Either<Exception, int>>> EQ_EITHER) sync* {
    yield Law(
        'Applicative Error Laws: handle', () => applicativeErrorHandle(AE, EQ));
    yield Law('Applicative Error Laws: handle with for error',
        () => applicativeErrorHandleWith(AE, EQ));
    yield Law('Applicative Error Laws: handle with for success',
        () => applicativeErrorHandleWithPure(AE, EQ));
    yield Law(
        'Applicative Error Laws: redeem is derived from map and handleError',
        () => redeemIsDerivedFromMapHandleError(AE, EQ));
    yield Law('Applicative Error Laws: attempt for error',
        () => applicativeErrorAttemptError(AE, EQ_EITHER));
    yield Law('Applicative Error Laws: attempt for success',
        () => applicativeErrorAttemptSuccess(AE, EQ_EITHER));
    yield Law(
        'Applicative Error Laws: attempt lift from Either consistent with pure',
        () =>
            applicativeErrorAttemptFromEitherConsistentWithPure(AE, EQ_EITHER));

    yield Law('Applicative Error Laws: catch captures errors',
        () => applicativeErrorCatch(AE, EQ));
  }

  static void applicativeErrorHandle<F>(
          ApplicativeError<F, Exception> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<Exception, int>(Gen.integer()),
          Gen.exception(),
          (int Function(Exception e) f, Exception e) => AE
              .handleError<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, AE.pure(f(e)))));

  static void applicativeErrorHandleWith<F>(
          ApplicativeError<F, Exception> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(AE)),
          Gen.exception(),
          (Kind<F, int> Function(Exception) f, Exception e) => AE
              .handleErrorWith<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, f(e))));

  static void applicativeErrorHandleWithPure<F>(
          ApplicativeError<F, Exception> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<Exception, Kind<F, int>>(Gen.integer().apError(AE)),
          Gen.integer(),
          (Kind<F, int> Function(Exception) f, int a) => AE
              .handleErrorWith(AE.pure(a), (f))
              .equalUnderTheLaw(EQ, AE.pure(a))));

  static void redeemIsDerivedFromMapHandleError<F>(
          ApplicativeError<F, Exception> AE, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          Gen.integer().apError(AE),
          Gen.functionAtoB<Exception, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<F, int> fa, int Function(Exception) fe, int Function(int) fb) =>
              AE
                  .redeem(fa, fe, fb)
                  .equalUnderTheLaw(EQ, AE.handleError(AE.map(fa, fb), fe))));

  static void applicativeErrorAttemptError<F>(ApplicativeError<F, Exception> AE,
          Eq<Kind<F, Either<Exception, int>>> EQ) =>
      check(forall(
          Gen.exception(),
          (Exception e) => AE
              .attempt(AE.raiseError<int>(e))
              .equalUnderTheLaw(EQ, AE.pure(Either.left<Exception, int>(e)))));

  static void applicativeErrorAttemptSuccess<F>(
          ApplicativeError<F, Exception> AE,
          Eq<Kind<F, Either<Exception, int>>> EQ) =>
      check(
        forall(
            Gen.integer(),
            (a) => AE.attempt(AE.pure<int>(a)).equalUnderTheLaw(
                EQ, AE.pure(Either.right<Exception, int>(a)))),
      );

  static void applicativeErrorAttemptFromEitherConsistentWithPure<F>(
          ApplicativeError<F, Exception> AE,
          Eq<Kind<F, Either<Exception, int>>> EQ) =>
      check(forall(
          Gen.either<Exception, int>(Gen.exception(), Gen.integer()),
          (Either<Exception, int> either) => AE
              .attempt(AE.fromEither(either, identity))
              .equalUnderTheLaw(EQ, AE.pure(either))));

  static void applicativeErrorCatch<F>(
          ApplicativeError<F, Exception> AE, Eq<Kind<F, int>> EQ) =>
      check(forall(
          Gen.either(Gen.exception(), Gen.integer()),
          (Either<Exception, int> either) => AE
              .tryCatch(
                  () => either.fold((l) {
                        throw l;
                      }, identity),
                  identity)
              .equalUnderTheLaw(EQ, either.fold(AE.raiseError, AE.pure))));
  /*

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorEffectCatch(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      IO.effect {
        effectCatch { either.fold({ throw it }, ::identity) }
      }.unsafeRunSync().equalUnderTheLaw(either.fold({ raiseError<Int>(it) }, { just(it) }), EQ)
    }
    */
}
