import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';
import '../laws/show_laws.dart';
import '../../law.dart';

void main() {
  group('Id - Show', () {
    ShowLaws.laws(
      Id.show(),
      Id.eq<int>(),
      Id.applicative.pure,
    ).check();
  });
  group(('Id - Functor'), () {
    FunctorLaws.laws(
      Id.functor,
      Id.eq<int>(),
      Id.applicative.pure,
    ).check();
  });
}
