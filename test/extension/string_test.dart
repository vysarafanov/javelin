import 'package:javelin/extension.dart';
import 'package:test/test.dart';

import '../law.dart';
import '../typeclass/laws/eq_laws.dart';
import '../typeclass/laws/show_laws.dart';

Iterable<Law> stringLaws() sync* {
  yield* ShowLaws.laws(StringJ.show(), StringJ.eq(), (i) => i.toString());
  yield* EqLaws.laws(StringJ.eq(), (i) => i.toString());
}

void main() {
  group('String extension type:', () {
    stringLaws().check();
  });
}
