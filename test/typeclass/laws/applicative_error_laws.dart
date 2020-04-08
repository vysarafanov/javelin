import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class ApplicativeErrorLaws {
  static Iterable<Law> laws<F>(
      ApplicativeError<F, int> AE, Eq<Kind<F, int>> EQ) sync* {
    yield Law(
        'Applicative Error Laws: handle', () => applicativeErrorHandle(AE, EQ));
    yield Law('Applicative Error Laws: handle with for error',
        () => applicativeErrorHandleWith(AE, EQ));
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
  /*


  fun <F> ApplicativeError<F, Throwable>.applicativeErrorHandleWith(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.functionAToB<Throwable, Kind<F, Int>>(Gen.int().applicativeError(this)), Gen.throwable()) { f: (Throwable) -> Kind<F, Int>, e: Throwable ->
      raiseError<Int>(e).handleErrorWith(f).equalUnderTheLaw(f(e), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorHandleWithPure(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.functionAToB<Throwable, Kind<F, Int>>(Gen.int().applicativeError(this)), Gen.int()) { f: (Throwable) -> Kind<F, Int>, a: Int ->
      just(a).handleErrorWith(f).equalUnderTheLaw(just(a), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.redeemIsDerivedFromMapHandleError(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.int().applicativeError(this), Gen.functionAToB<Throwable, Int>(Gen.int()), Gen.functionAToB<Int, Int>(Gen.int())) { fa, fe, fb ->
      fa.redeem(fe, fb).equalUnderTheLaw(fa.map(fb).handleError(fe), EQ)
    }

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorAttemptError(EQ: Eq<Kind<F, Either<Throwable, Int>>>): Unit =
    forAll(Gen.throwable()) { e: Throwable ->
      raiseError<Int>(e).attempt().equalUnderTheLaw(just(Left(e)), EQ)
    }

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
