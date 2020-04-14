import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class MonadErrorLawsAsync {
  static Iterable<Law> laws(
    MonadError<ForAsync, Exception> ME,
    Gen<Exception> eGen,
  ) sync* {
    yield Law(
        'Monad Error Laws: left zero', () => monadErrorLeftZero(ME, eGen));
    yield Law('Monad Error Laws: ensure consistency',
        () => monadErrorEnsureConsistency(ME, eGen));
    yield Law('Monad Error Laws: NonFatal is caught',
        () => monadErrorCatchesNonFatalExceptions(ME, eGen));
    yield Law(
        'Monad Error Laws: redeemWith is derived from flatMap & HandleErrorWith',
        () => monadErrorDerivesRedeemWith(ME, eGen));
    yield Law('Monad Error Laws: redeemWith pure is flatMap',
        () => monadErrorRedeemWithPureIsFlatMap(ME, eGen));
  }

  static void monadErrorLeftZero(
          MonadError<ForAsync, Exception> ME, Gen<Exception> eGen) =>
      checkAsync(forall2Async(
          Gen.functionAtoB<int, Kind<ForAsync, int>>(
              Gen.integer().apError(ME, eGen)),
          eGen,
          (Kind<ForAsync, int> f(int i), Exception e) => ME
              .flatMap(ME.raiseError<int>(e), f)
              .equalUnderTheLaw(ME.raiseError<int>(e))));

  static void monadErrorEnsureConsistency(
          MonadError<ForAsync, Exception> ME, Gen<Exception> eGen) =>
      checkAsync(forall3Async(
        Gen.integer().apError(ME, eGen),
        eGen,
        Gen.functionAtoB<int, bool>(Gen.boolean()),
        (Kind<ForAsync, int> fa, Exception e, bool p(int i)) => ME
            .ensure(fa, () => e, p)
            .equalUnderTheLaw(ME.flatMap(
                fa, (int a) => p(a) ? ME.pure<int>(a) : ME.raiseError<int>(e))),
      ));

  static void monadErrorCatchesNonFatalExceptions(
          MonadError<ForAsync, Exception> ME, Gen<Exception> eGen) =>
      checkAsync(forall2Async(
          Gen.exception(),
          eGen,
          (Exception nonFatal, Exception e) => ME
              .tryCatch<int>(
                () => throw nonFatal,
                (exception) => e,
              )
              .equalUnderTheLaw(ME.raiseError<int>(e))));

  static void monadErrorDerivesRedeemWith(
          MonadError<ForAsync, Exception> ME, Gen<Exception> eGen) =>
      checkAsync(forall3Async(
          Gen.integer().apError(ME, eGen),
          Gen.functionAtoB<Exception, Kind<ForAsync, int>>(
              Gen.integer().apError(ME, eGen)),
          Gen.functionAtoB<int, Kind<ForAsync, int>>(
              Gen.integer().apError(ME, eGen)),
          (
            Kind<ForAsync, int> fa,
            Kind<ForAsync, int> fe(Exception e),
            Kind<ForAsync, int> fb(int a),
          ) =>
              ME.redeemWith(fa, fe, fb).equalUnderTheLaw(
                  ME.handleErrorWith(ME.flatMap(fa, fb), fe))));

  static void monadErrorRedeemWithPureIsFlatMap(
          MonadError<ForAsync, Exception> ME, Gen<Exception> eGen) =>
      checkAsync(forall3Async(
          Gen.integer().ap(ME),
          Gen.functionAtoB<Exception, Kind<ForAsync, int>>(
              Gen.integer().apError(ME, eGen)),
          Gen.functionAtoB<int, Kind<ForAsync, int>>(Gen.integer().ap(ME)),
          (Kind<ForAsync, int> fa, Kind<ForAsync, int> fe(Exception e),
                  Kind<ForAsync, int> fb(int a)) =>
              ME.redeemWith(fa, fe, fb).equalUnderTheLaw(ME.flatMap(fa, fb))));
}
