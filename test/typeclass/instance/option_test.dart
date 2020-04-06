import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/eq_laws.dart';
import '../laws/functor_laws.dart';
import '../../law.dart';
import '../laws/show_laws.dart';

Iterable<Law> optionLaws() sync* {
  yield* ShowLaws.laws(
      Option.show(), Option.eq<int>(), Option.applicative.pure);
  yield* EqLaws.laws(Option.eq<int>(), Option.applicative.pure);
  yield* FunctorLaws.laws(
      Option.functor, Option.eq<int>(), Option.applicative.pure);
}

void main() {
  group('Option typeclass', () {
    optionLaws().check();
  });
}
