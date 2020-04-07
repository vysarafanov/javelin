import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_extension.dart';
import 'package:test/test.dart';

import '../laws/applicative_laws.dart';
import '../laws/eq_laws.dart';
import '../laws/functor_laws.dart';
import '../laws/invariant_laws.dart';
import '../laws/monad_laws.dart';
import '../laws/show_laws.dart';
import '../../law.dart';

Iterable<Law> idLaws() sync* {
  yield* ShowLaws.laws(
    Id.show(IntJ.show()),
    Id.eq<int>(IntJ.eq()),
    Id.applicative().pure,
  );
  yield* EqLaws.laws(
    Id.eq<int>(IntJ.eq()),
    Id.applicative().pure,
  );
  yield* InvariantLaws.laws(
    Id.invariant(),
    Id.eq<int>(IntJ.eq()),
    Id.applicative().pure,
  );
  yield* FunctorLaws.laws(
    Id.functor(),
    Id.eq<int>(IntJ.eq()),
    Id.applicative().pure,
  );
  yield* ApplicativeLaws.laws(
    Id.applicative(),
    Id.eq<int>(IntJ.eq()),
  );
  yield* MonadLaws.laws(
    Id.monad(),
    Id.eq<int>(IntJ.eq()),
  );
}

void main() {
  group('Id type:', () {
    idLaws().check();
  });
}
