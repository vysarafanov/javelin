import 'package:javelin/javelin.dart';
import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:test/test.dart';

import '../../law.dart';
import '../../typeclass/laws/applicative_laws.dart';
import '../../typeclass/laws/eq_laws.dart';
import '../../typeclass/laws/foldable_laws.dart';
import '../../typeclass/laws/functor_laws.dart';
import '../../typeclass/laws/invariant_laws.dart';
import '../../typeclass/laws/monad_laws.dart';
import '../../typeclass/laws/show_laws.dart';
import '../../typeclass/laws/traverse_laws.dart';

Iterable<Law> idLaws() sync* {
  yield* ShowLaws.laws(
    Id.show(),
    Id.eq<int>(),
    Id.applicative().pure,
  );
  yield* EqLaws.laws(
    Id.eq<int>(),
    Id.applicative().pure,
  );
  yield* InvariantLaws.laws(
    Id.invariant(),
    Id.eq<int>(),
    Id.applicative().pure,
  );
  yield* FunctorLaws.laws(
    Id.functor(),
    Id.eq<int>(),
    Id.applicative().pure,
  );
  yield* ApplicativeLaws.laws(
    Id.applicative(),
    Id.eq<int>(),
    Id.eq<Tuple3<int, int, int>>(),
  );
  yield* MonadLaws.laws(
    Id.monad(),
    Id.eq<int>(),
  );
  yield* FoldableLaws.laws(
    Id.foldable(),
    Id.applicative().pure,
  );
  yield* TraverseLaws.laws(
    Id.traverse(),
    Id.applicative().pure,
    Id.eq<int>(),
  );
}

void main() async {
  group('Id type:', () {
    idLaws().check();
  });
}
