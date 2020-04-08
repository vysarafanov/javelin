import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class ApplicativeErrorLaws {
  static Iterable<Law> laws<F>(ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ,
      Eq<Kind<F, Either<int, int>>> EQ_EITHER) sync* {
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
  }

  static void applicativeErrorHandle<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          FunctionAtoB.gen<int, int>(IntGen()),
          IntGen(),
          (int Function(int) f, int e) => AE
              .handleError<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, AE.pure(f(e)))));

  static void applicativeErrorHandleWith<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          FunctionAtoB.gen<int, Kind<F, int>>(IntGen().map(AE.pure)),
          IntGen(),
          (Kind<F, int> Function(int) f, int e) => AE
              .handleErrorWith<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, f(e))));

  static void applicativeErrorHandleWithPure<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          FunctionAtoB.gen<int, Kind<F, int>>(IntGen().map(AE.pure)),
          IntGen(),
          (Kind<F, int> Function(int) f, int a) => AE
              .handleErrorWith(AE.pure(a), (f))
              .equalUnderTheLaw(EQ, AE.pure(a))));

  static void redeemIsDerivedFromMapHandleError<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          IntGen().map(AE.pure),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          (Kind<F, int> fa, int Function(int) fe, int Function(int) fb) => AE
              .redeem(fa, fe, fb)
              .equalUnderTheLaw(EQ, AE.handleError(AE.map(fa, fb), fe))));

  static void applicativeErrorAttemptError<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, Either<int, int>>> EQ) =>
      check(forall(
          IntGen(),
          (int e) => AE
              .attempt(AE.raiseError<int>(e))
              .equalUnderTheLaw(EQ, AE.pure(Either.left<int, int>(e)))));

  static void applicativeErrorAttemptSuccess<F>(
          ApplicativeError<F, int> AE, Eq<Kind<F, Either<int, int>>> EQ) =>
      check(
        forall(
            IntGen(),
            (a) => AE
                .attempt(AE.pure<int>(a))
                .equalUnderTheLaw(EQ, AE.pure(Either.right<int, int>(a)))),
      );
  /*

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorAttemptSuccess(EQ: Eq<Kind<F, Either<Throwable, Int>>>): Unit =
    forAll(Gen.int()) { a: Int ->
      just(a).attempt().equalUnderTheLaw(just(Right(a)), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorAttemptFromEitherConsistentWithPure(EQ: Eq<Kind<F, Either<Throwable, Int>>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      either.fromEither { it }.attempt().equalUnderTheLaw(just(either), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorCatch(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      catch { either.fold({ throw it }, ::identity) }.equalUnderTheLaw(either.fold({ raiseError<Int>(it) }, { just(it) }), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorEffectCatch(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      IO.effect {
        effectCatch { either.fold({ throw it }, ::identity) }
      }.unsafeRunSync().equalUnderTheLaw(either.fold({ raiseError<Int>(it) }, { just(it) }), EQ)
    }
    */
}
