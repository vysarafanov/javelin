import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';

void main() {
  group(('Option - Functor'), () {
    FunctorLaws.laws(Option.functor, Option.eq, Option.applicative.pure)
        .forEach((law) {
      test(law.name, law.test);
    });
  });
}
