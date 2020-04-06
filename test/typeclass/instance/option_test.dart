import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';
import '../../law.dart';
import '../laws/show_laws.dart';

void main() {
  group('Option - Show', () {
    ShowLaws.laws(
      Option.show(),
      Option.eq<int>(),
      Option.applicative.pure,
    ).check();
  });
  group(('Option - Functor'), () {
    FunctorLaws.laws(
      Option.functor,
      Option.eq<int>(),
      Option.applicative.pure,
    ).check();
  });
}
