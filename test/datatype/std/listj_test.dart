import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_std.dart';
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

Iterable<Law> listJLaws() sync* {
  yield* ShowLaws.laws(
    ListJ.show(),
    ListJ.eq<int>(),
    ListJ.applicative().pure,
  );
  yield* EqLaws.laws(
    ListJ.eq<int>(),
    ListJ.applicative().pure,
  );
  yield* InvariantLaws.laws(
    ListJ.invariant(),
    ListJ.eq<int>(),
    ListJ.applicative().pure,
  );
  yield* FunctorLaws.laws(
    ListJ.functor(),
    ListJ.eq<int>(),
    ListJ.applicative().pure,
  );
  yield* ApplicativeLaws.laws(
    ListJ.applicative(),
    ListJ.eq<int>(),
    ListJ.eq<Tuple3<int, int, int>>(),
  );
  yield* MonadLaws.laws(
    ListJ.monad(),
    ListJ.eq<int>(),
  );
  yield* FoldableLaws.laws(
    ListJ.foldable(),
    ListJ.applicative().pure,
  );
  yield* TraverseLaws.laws(
    ListJ.traversable(),
    ListJ.applicative().pure,
    ListJ.eq<int>(),
  );
}

void main() async {
  group('ListJ type:', () {
    listJLaws().check();
  });
}
