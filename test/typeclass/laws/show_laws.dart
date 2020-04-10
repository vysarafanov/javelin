import 'package:javelin/typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class ShowLaws {
  static Iterable<Law> laws<F>(Show<F> S, Eq<F> EQ, F f(int a)) sync* {
    yield Law(
      'Show Laws: equality',
      () => equalShow(S, EQ, f),
    );
  }

  static void equalShow<F>(
    Show<F> S,
    Eq<F> EQ,
    F f(int c),
  ) =>
      check(
        forall(Gen.integer(), (value) {
          final a = f(value);
          final b = f(value);
          return EQ.eqv(a, b) && S.show(a) == S.show(b);
        }),
      );
}
