import 'package:javelin/typeclass.dart';
import 'package:javelin/src/core.dart' as core;

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class InvariantLaws {
  static Iterable<Law> laws<F>(
    Invariant<F> IF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) sync* {
    yield Law('Invariant Laws: Invariant Identity', () => identity(IF, EQ, f));
    yield Law(
        'Invariant Laws: Invariant Composition', () => composition(IF, EQ, f));
  }

  static void identity<F>(
    Invariant<F> IF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(forall(
          Gen.integer().map(f),
          (Kind<F, int> fa) => IF
              .imap<int, int>(fa, core.identity, core.identity)
              .equalUnderTheLaw(EQ, fa)));

  static void composition<F>(
    Invariant<F> IF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(forall5(
          Gen.integer().map(f),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (
            Kind<F, int> fa,
            int Function(int) f1,
            int Function(int) f2,
            int Function(int) g1,
            int Function(int) g2,
          ) =>
              IF.imap<int, int>(IF.imap(fa, f1, f2), g1, g2).equalUnderTheLaw(
                    EQ,
                    IF.imap<int, int>(
                        fa, g1.compose<int>(f1), g2.compose<int>(f2)),
                  )));
}
