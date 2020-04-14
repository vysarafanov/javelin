import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class ApplicativeErrorLawsAsync {
  static Iterable<Law> laws(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) sync* {
    yield Law('Applicative Error Laws: handle',
        () => applicativeErrorHandle(AE, eGen));
    yield Law('Applicative Error Laws: handle with for error',
        () => applicativeErrorHandleWith(AE, eGen));
    yield Law('Applicative Error Laws: handle with for success',
        () => applicativeErrorHandleWithPure(AE, eGen));
    yield Law(
        'Applicative Error Laws: redeem is derived from map and handleError',
        () => redeemIsDerivedFromMapHandleError(AE, eGen));
    yield Law('Applicative Error Laws: attempt for error',
        () => applicativeErrorAttemptError(AE, eGen));
    yield Law('Applicative Error Laws: attempt for success',
        () => applicativeErrorAttemptSuccess(AE));
    yield Law(
        'Applicative Error Laws: attempt lift from Either consistent with pure',
        () => applicativeErrorAttemptFromEitherConsistentWithPure(AE, eGen));

    yield Law('Applicative Error Laws: catch captures errors',
        () => applicativeErrorCatch(AE, eGen));
  }

  static void applicativeErrorHandle(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forall2Async(
          Gen.functionAtoB<Exception, int>(Gen.integer()),
          eGen,
          (int Function(Exception e) f, Exception e) => AE
              .handleError<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(AE.pure(f(e)))));

  static void applicativeErrorHandleWith(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forall2Async(
          Gen.functionAtoB<Exception, Kind<ForAsync, int>>(
              Gen.integer().apError<ForAsync, Exception>(AE, eGen)),
          eGen,
          (Kind<ForAsync, int> Function(Exception e) f, Exception e) => AE
              .handleErrorWith<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(f(e))));

  static void applicativeErrorHandleWithPure(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forall2Async(
          Gen.functionAtoB<Exception, Kind<ForAsync, int>>(
              Gen.integer().apError(AE, eGen)),
          Gen.integer(),
          (Kind<ForAsync, int> Function(Exception e) f, int a) =>
              AE.handleErrorWith(AE.pure(a), f).equalUnderTheLaw(AE.pure(a))));

  static void redeemIsDerivedFromMapHandleError(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forall3Async(
          Gen.integer().apError(AE, eGen),
          Gen.functionAtoB<Exception, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<ForAsync, int> fa, int Function(Exception) fe,
                  int Function(int) fb) =>
              AE
                  .redeem(fa, fe, fb)
                  .equalUnderTheLaw(AE.handleError(AE.map(fa, fb), fe))));

  static void applicativeErrorAttemptError(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forallAsync(
          eGen,
          (Exception e) => AE
              .attempt(AE.raiseError<int>(e))
              .equalUnderTheLaw(AE.pure(Either.left<Exception, int>(e)))));

  static void applicativeErrorAttemptSuccess(
    ApplicativeError<ForAsync, Exception> AE,
  ) =>
      checkAsync(
        forallAsync(
            Gen.integer(),
            (a) => AE
                .attempt(AE.pure<int>(a))
                .equalUnderTheLaw(AE.pure(Either.right<Exception, int>(a)))),
      );

  static void applicativeErrorAttemptFromEitherConsistentWithPure(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forallAsync(
          Gen.either<Exception, int>(eGen, Gen.integer()),
          (Either<Exception, int> either) => AE
              .attempt(AE.fromEither(either, identity))
              .equalUnderTheLaw(AE.pure(either))));

  static void applicativeErrorCatch(
    ApplicativeError<ForAsync, Exception> AE,
    Gen<Exception> eGen,
  ) =>
      checkAsync(forall2Async(
          Gen.either(Gen.exception(), Gen.integer()),
          eGen,
          (Either<Exception, int> either, Exception e) => AE
              .tryCatch(
                  () => either.fold((l) {
                        throw l;
                      }, identity),
                  (exception) => e)
              .equalUnderTheLaw(
                  either.fold((_) => AE.raiseError(e), AE.pure))));
  /*

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorEffectCatch(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      IO.effect {
        effectCatch { either.fold({ throw it }, ::identity) }
      }.unsafeRunSync().equalUnderTheLaw(either.fold({ raiseError<Int>(it) }, { just(it) }), EQ)
    }
    */
}
