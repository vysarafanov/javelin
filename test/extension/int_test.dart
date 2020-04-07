import 'package:javelin/javelin_extension.dart';
import 'package:javelin/src/core.dart';
import 'package:test/test.dart';

import '../law.dart';
import '../typeclass/laws/eq_laws.dart';
import '../typeclass/laws/show_laws.dart';

Iterable<Law> intLaws() sync* {
  yield* ShowLaws.laws(IntJ.show(), IntJ.eq(), identity);
  yield* EqLaws.laws(IntJ.eq(), identity);
}

void main() {
  group('Int extension type:', () {
    intLaws().check();
  });
}
