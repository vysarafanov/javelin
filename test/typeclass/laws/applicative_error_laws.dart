import 'package:javelin/datatype.dart';
import 'package:javelin/typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class ApplicativeErrorLaws {
  static Iterable<Law> laws<F, E>(
      ApplicativeError<F, E> AE,
      Eq<Kind<F, int>> EQ,
      Eq<Kind<F, Either<E, int>>> EQ_EITHER,
      Gen<E> eGen) sync* {
    yield Law('Applicative Error Laws: handle',
        () => applicativeErrorHandle(AE, EQ, eGen));
    yield Law('Applicative Error Laws: handle with for error',
        () => applicativeErrorHandleWith(AE, EQ, eGen));
    yield Law('Applicative Error Laws: handle with for success',
        () => applicativeErrorHandleWithPure(AE, EQ, eGen));
    yield Law(
        'Applicative Error Laws: redeem is derived from map and handleError',
        () => redeemIsDerivedFromMapHandleError(AE, EQ, eGen));
    yield Law('Applicative Error Laws: attempt for error',
        () => applicativeErrorAttemptError(AE, EQ_EITHER, eGen));
    yield Law('Applicative Error Laws: attempt for success',
        () => applicativeErrorAttemptSuccess(AE, EQ_EITHER));
    yield Law(
        'Applicative Error Laws: attempt lift from Either consistent with pure',
        () => applicativeErrorAttemptFromEitherConsistentWithPure(
            AE, EQ_EITHER, eGen));

    yield Law('Applicative Error Laws: catch captures errors',
        () => applicativeErrorCatch(AE, EQ, eGen));
  }

  static void applicativeErrorHandle<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.functionAtoB<E, int>(Gen.integer()),
          eGen,
          (int Function(E e) f, E e) => AE
              .handleError<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, AE.pure(f(e)))));

  static void applicativeErrorHandleWith<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.functionAtoB<E, Kind<F, int>>(
              Gen.integer().apError<F, E>(AE, eGen)),
          eGen,
          (Kind<F, int> Function(E e) f, E e) => AE
              .handleErrorWith<int>(AE.raiseError(e), f)
              .equalUnderTheLaw(EQ, f(e))));

  static void applicativeErrorHandleWithPure<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.functionAtoB<E, Kind<F, int>>(Gen.integer().apError(AE, eGen)),
          Gen.integer(),
          (Kind<F, int> Function(E e) f, int a) => AE
              .handleErrorWith(AE.pure(a), f)
              .equalUnderTheLaw(EQ, AE.pure(a))));

  static void redeemIsDerivedFromMapHandleError<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall3(
          Gen.integer().apError(AE, eGen),
          Gen.functionAtoB<E, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<F, int> fa, int Function(E) fe, int Function(int) fb) => AE
              .redeem(fa, fe, fb)
              .equalUnderTheLaw(EQ, AE.handleError(AE.map(fa, fb), fe))));

  static void applicativeErrorAttemptError<F, E>(ApplicativeError<F, E> AE,
          Eq<Kind<F, Either<E, int>>> EQ, Gen<E> eGen) =>
      check(forall(
          eGen,
          (E e) => AE
              .attempt(AE.raiseError<int>(e))
              .equalUnderTheLaw(EQ, AE.pure(Either.left<E, int>(e)))));

  static void applicativeErrorAttemptSuccess<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, Either<E, int>>> EQ) =>
      check(
        forall(
            Gen.integer(),
            (a) => AE
                .attempt(AE.pure<int>(a))
                .equalUnderTheLaw(EQ, AE.pure(Either.right<E, int>(a)))),
      );

  static void applicativeErrorAttemptFromEitherConsistentWithPure<F, E>(
          ApplicativeError<F, E> AE,
          Eq<Kind<F, Either<E, int>>> EQ,
          Gen<E> eGen) =>
      check(forall(
          Gen.either<E, int>(eGen, Gen.integer()),
          (Either<E, int> either) => AE
              .attempt(AE.fromEither(either, identity))
              .equalUnderTheLaw(EQ, AE.pure(either))));

  static void applicativeErrorCatch<F, E>(
          ApplicativeError<F, E> AE, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.either(Gen.exception(), Gen.integer()),
          eGen,
          (Either<Exception, int> either, E e) => AE
              .tryCatch(
                  () => either.fold((l) {
                        throw l;
                      }, identity),
                  (exception) => e)
              .equalUnderTheLaw(
                  EQ, either.fold((_) => AE.raiseError(e), AE.pure))));
  /*

  fun <F> ApplicativeError<F, Throwable>.applicativeErrorEffectCatch(EQ: Eq<Kind<F, Int>>): Unit =
    forAll(Gen.either(Gen.throwable(), Gen.int())) { either: Either<Throwable, Int> ->
      IO.effect {
        effectCatch { either.fold({ throw it }, ::identity) }
      }.unsafeRunSync().equalUnderTheLaw(either.fold({ raiseError<Int>(it) }, { just(it) }), EQ)
    }
    */
}
