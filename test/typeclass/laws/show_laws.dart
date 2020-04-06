import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class ShowLaws {
  static Iterable<Law> laws<F>(Show<F> show, Eq<F> eq, F f(int a)) sync* {
    yield Law(
      'Show Laws: equality',
      () => equalShow(show, eq, f),
    );
  }

  static void equalShow<F>(
    Show<F> show,
    Eq<F> eq,
    F f(int c),
  ) =>
      check(
        forall(IntGen(), (value) {
          final a = f(value);
          final b = f(value);
          return eq.eqv(a, b) && show.show(a) == show.show(b);
        }),
      );
}
