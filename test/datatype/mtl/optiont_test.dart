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

Iterable<Law> optiontLaws<F, E>(MonadError<F, E> ME, Gen<E> eGen) sync* {
  yield* ShowLaws.laws(
    OptionT.show(),
    OptionT.eq<F, int>(),
    OptionT.applicative(ME).pure,
  );
  yield* EqLaws.laws(
    OptionT.eq<F, int>(),
    OptionT.applicative(ME).pure,
  );
  yield* InvariantLaws.laws(
    OptionT.functor(ME),
    OptionT.eq<F, int>(),
    OptionT.applicative(ME).pure,
  );
  yield* FunctorLaws.laws(
    OptionT.functor(ME),
    OptionT.eq<F, int>(),
    OptionT.applicative(ME).pure,
  );
  yield* ApplicativeLaws.laws(
    OptionT.applicative(ME),
    OptionT.eq<F, int>(),
    OptionT.eq<F, Tuple3<int, int, int>>(),
  );
  yield* ApplicativeErrorLaws.laws(
    OptionT.applicativeError(ME),
    OptionT.eq<F, int>(),
    OptionT.eq<F, Either<Unit, int>>(),
    Gen.unit(),
  );
  yield* MonadLaws.laws(
    OptionT.monad(ME),
    OptionT.eq<F, int>(),
  );
  yield* MonadErrorLaws.laws(
    OptionT.monadError(ME),
    OptionT.eq<F, int>(),
    Gen.unit(),
  );

  ///Additional tests for ApplicativeMonadF
  yield* ApplicativeErrorLaws.laws(
    OptionT.applicativeErrorF(ME),
    OptionT.eq<F, int>(),
    OptionT.eq<F, Either<E, int>>(),
    eGen,
  );
  //Additional tests for MonadErrorF
  yield* MonadErrorLaws.laws(
    OptionT.monadErrorF(ME),
    OptionT.eq<F, int>(),
    eGen,
  );
}

void main() {
  group('OptionT type', () {
    optiontLaws<Kind<ForEither, Exception>, Exception>(
            Either.monadError(), Gen.exception())
        .check();
  });
}
