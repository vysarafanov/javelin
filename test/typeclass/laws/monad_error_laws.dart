import 'package:javelin/typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class MonadErrorLaws {
  static Iterable<Law> laws<F, E>(
      MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) sync* {
    yield Law(
        'Monad Error Laws: left zero', () => monadErrorLeftZero(ME, EQ, eGen));
    yield Law('Monad Error Laws: ensure consistency',
        () => monadErrorEnsureConsistency(ME, EQ, eGen));
    yield Law('Monad Error Laws: NonFatal is caught',
        () => monadErrorCatchesNonFatalExceptions(ME, EQ, eGen));
    yield Law(
        'Monad Error Laws: redeemWith is derived from flatMap & HandleErrorWith',
        () => monadErrorDerivesRedeemWith(ME, EQ, eGen));
    yield Law('Monad Error Laws: redeemWith pure is flatMap',
        () => monadErrorRedeemWithPureIsFlatMap(ME, EQ, eGen));
  }

  static void monadErrorLeftZero<F, E>(
          MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(ME, eGen)),
          eGen,
          (Kind<F, int> f(int i), E e) => ME
              .flatMap(ME.raiseError<int>(e), f)
              .equalUnderTheLaw(EQ, ME.raiseError<int>(e))));

  static void monadErrorEnsureConsistency<F, E>(
          MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall3(
        Gen.integer().apError(ME, eGen),
        eGen,
        Gen.functionAtoB<int, bool>(Gen.boolean()),
        (Kind<F, int> fa, E e, bool p(int i)) => ME
            .ensure(fa, () => e, p)
            .equalUnderTheLaw(
                EQ,
                ME.flatMap(fa,
                    (int a) => p(a) ? ME.pure<int>(a) : ME.raiseError<int>(e))),
      ));

  static void monadErrorCatchesNonFatalExceptions<F, E>(
          MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall2(
          Gen.exception(),
          eGen,
          (Exception nonFatal, E e) => ME
              .tryCatch<int>(
                () => throw nonFatal,
                (exception) => e,
              )
              .equalUnderTheLaw(EQ, ME.raiseError<int>(e))));

  static void monadErrorDerivesRedeemWith<F, E>(
          MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall3(
          Gen.integer().apError(ME, eGen),
          Gen.functionAtoB<E, Kind<F, int>>(Gen.integer().apError(ME, eGen)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().apError(ME, eGen)),
          (
            Kind<F, int> fa,
            Kind<F, int> fe(E e),
            Kind<F, int> fb(int a),
          ) =>
              ME.redeemWith(fa, fe, fb).equalUnderTheLaw(
                  EQ, ME.handleErrorWith(ME.flatMap(fa, fb), fe))));

  static void monadErrorRedeemWithPureIsFlatMap<F, E>(
          MonadError<F, E> ME, Eq<Kind<F, int>> EQ, Gen<E> eGen) =>
      check(forall3(
          Gen.integer().ap(ME),
          Gen.functionAtoB<E, Kind<F, int>>(Gen.integer().apError(ME, eGen)),
          Gen.functionAtoB<int, Kind<F, int>>(Gen.integer().ap(ME)),
          (Kind<F, int> fa, Kind<F, int> fe(E e), Kind<F, int> fb(int a)) => ME
              .redeemWith(fa, fe, fb)
              .equalUnderTheLaw(EQ, ME.flatMap(fa, fb))));
}
