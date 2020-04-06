import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';

void main() {
  group(('Id - Functor'), () {
    FunctorLaws.laws(Id.functor, Id.eq, Id.applicative.pure).forEach((law) {
      test(law.name, law.test);
    });
  });
}
