import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_extension.dart';
import 'package:test/test.dart';

import '../../law.dart';
import '../laws/applicative_error_laws.dart';
import '../laws/applicative_laws.dart';
import '../laws/eq_laws.dart';
import '../laws/functor_laws.dart';
import '../laws/invariant_laws.dart';
import '../laws/monad_laws.dart';
import '../laws/show_laws.dart';

Iterable<Law> eitherLaws() sync* {
  yield* ShowLaws.laws(
    Either.show(StringJ.show(), IntJ.show()),
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
    Either.applicative<String>().pure,
  );
  yield* EqLaws.laws(
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
    Either.applicative<String>().pure,
  );
  yield* InvariantLaws.laws(
    Either.invariant<String>(),
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
    Either.applicative<String>().pure,
  );
  yield* FunctorLaws.laws(
    Either.functor<String>(),
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
    Either.applicative<String>().pure,
  );
  yield* ApplicativeLaws.laws(
    Either.applicative<String>(),
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
  );
  yield* ApplicativeErrorLaws.laws(
      Either.applicativeError<int>(), Either.eq(IntJ.eq(), IntJ.eq()));
  yield* MonadLaws.laws(
    Either.monad<String>(),
    Either.eq<String, int>(StringJ.eq(), IntJ.eq()),
  );
}

void main() {
  group('Either type', () {
    eitherLaws().check();
  });
}
