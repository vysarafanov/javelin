import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_mtl.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:test/test.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../typeclass/laws/applicative_error_laws.dart';
import '../../typeclass/laws/applicative_laws.dart';
import '../../typeclass/laws/eq_laws.dart';
import '../../typeclass/laws/functor_laws.dart';
import '../../typeclass/laws/invariant_laws.dart';
import '../../typeclass/laws/monad_error_laws.dart';
import '../../typeclass/laws/monad_laws.dart';
import '../../typeclass/laws/show_laws.dart';

Iterable<Law> eithertLaws<F, E>(MonadError<F, E> ME, Gen<E> eGen) sync* {
  yield* ShowLaws.laws(
    EitherT.show(),
    EitherT.eq<F, Exception, int>(),
    EitherT.applicative<F, Exception>(ME).pure,
  );
  yield* EqLaws.laws(
    EitherT.eq<F, Exception, int>(),
    EitherT.applicative<F, Exception>(ME).pure,
  );
  yield* InvariantLaws.laws(
    EitherT.functor(ME),
    EitherT.eq<F, Exception, int>(),
    EitherT.applicative<F, Exception>(ME).pure,
  );
  yield* FunctorLaws.laws(
    EitherT.functor(ME),
    EitherT.eq<F, Exception, int>(),
    EitherT.applicative<F, Exception>(ME).pure,
  );
  yield* ApplicativeLaws.laws(
    EitherT.applicative<F, Exception>(ME),
    EitherT.eq<F, Exception, int>(),
  );
  yield* ApplicativeErrorLaws.laws(
    EitherT.applicativeError<F, Exception>(ME),
    EitherT.eq<F, Exception, int>(),
    EitherT.eq<F, Exception, Either<Exception, int>>(),
    Gen.exception(),
  );
  yield* MonadLaws.laws(
    EitherT.monad<F, Exception>(ME),
    EitherT.eq<F, Exception, int>(),
  );
  yield* MonadErrorLaws.laws(
    EitherT.monadError<F, Exception>(ME),
    EitherT.eq<F, Exception, int>(),
    Gen.exception(),
  );

  ///Additional tests for ApplicativeMonadF
  yield* ApplicativeErrorLaws.laws(
    EitherT.applicativeErrorF<F, Exception, E>(ME),
    EitherT.eq<F, Exception, int>(),
    EitherT.eq<F, Exception, Either<E, int>>(),
    eGen,
  );
  //Additional tests for MonadErrorF
  yield* MonadErrorLaws.laws(
    EitherT.monadErrorF<F, Exception, E>(ME),
    EitherT.eq<F, Exception, int>(),
    eGen,
  );
}

void main() {
  group('EitherT type', () {
    eithertLaws<Kind<ForEither, Exception>, Exception>(
            Either.monadError<Exception>(), Gen.exception())
        .check();
  });
}
