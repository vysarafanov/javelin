import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class ShowLaws {
  static Iterable<Law> laws<F>(Show<F> show, Eq<F> eq, F cf(int c)) sync* {
    yield Law(
      'Show Laws: equality',
      () => equalShow(show, eq, cf),
    );
  }

  static void equalShow<F>(
    Show<F> show,
    Eq<F> eq,
    F cf(int c),
  ) =>
      check(
        forall1(IntGen(), (value) {
          final a = cf(value);
          final b = cf(value);
          return eq.eqv(a, b) && show.show(a) == show.show(b);
        }),
      );
}
