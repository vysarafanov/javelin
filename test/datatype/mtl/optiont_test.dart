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

Iterable<Law> optiontLaws<F>(MonadError<F, Exception> ME) sync* {
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
  );
  yield* ApplicativeErrorLaws.laws(
    OptionT.applicativeError(ME),
    OptionT.eq<F, int>(),
    OptionT.eq<F, Either<Exception, int>>(),
    Gen.exception(),
  );
  yield* MonadLaws.laws(
    OptionT.monad(ME),
    OptionT.eq<F, int>(),
  );
  yield* MonadErrorLaws.laws(
    OptionT.monadError(ME),
    OptionT.eq<F, int>(),
    Gen.exception(),
  );
}

void main() {
  group('OptionT type', () {
    optiontLaws<Kind<ForEither, Exception>>(Either.monadError()).check();
  });
}
