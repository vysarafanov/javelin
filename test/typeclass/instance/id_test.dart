import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';
import 'package:test/test.dart';

import '../laws/eq_laws.dart';
import '../laws/functor_laws.dart';
import '../laws/invariant_laws.dart';
import '../laws/show_laws.dart';
import '../../law.dart';

Iterable<Law> idLaws() sync* {
  yield* ShowLaws.laws(Id.show(), Id.eq<int>(), Id.applicative.pure);
  yield* EqLaws.laws(Id.eq<int>(), Id.applicative.pure);
  yield* InvariantLaws.laws(Id.invariant, Id.eq<int>(), Id.applicative.pure);
  yield* FunctorLaws.laws(Id.functor, Id.eq<int>(), Id.applicative.pure);
}

void main() {
  group('Id typeclass', () {
    idLaws().check();
  });
}
