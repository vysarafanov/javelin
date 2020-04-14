import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/extension.dart';
import 'package:test/test.dart';

import '../../gen.dart';
import '../../law.dart';

import 'laws/applicative_error_laws_async.dart';
import 'laws/applicative_laws_async.dart';
import 'laws/functor_laws_async.dart';
import 'laws/invariant_laws_async.dart';
import 'laws/monad_error_laws_async.dart';
import 'laws/monad_laws_async.dart';

Iterable<Law> asyncLaws() sync* {
  yield* InvariantLawsAsync.laws(
    Async.invariant(),
    Async.applicative().pure,
  );
  yield* FunctorLawsAsync.laws(
    Async.functor(),
    Async.applicative().pure,
  );
  yield* ApplicativeLawsAsync.laws(
    Async.applicative(),
  );
  yield* ApplicativeErrorLawsAsync.laws(
    Async.applicativeError(),
    Gen.exception(),
  );
  yield* MonadLawsAsync.laws(
    Async.monad(),
  );
  yield* MonadErrorLawsAsync.laws(
    Async.monadError(),
    Gen.exception(),
  );
}

void main() {
  group('Async type', () {
    asyncLaws().check();
  });
}
