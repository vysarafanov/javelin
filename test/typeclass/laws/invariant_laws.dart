import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart' as core;

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class InvariantLaws {
  static Iterable<Law> laws<F>(
    Invariant<F> invariant,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) sync* {
    yield Law(
        'Invariant Laws: Invariant Identity', () => identity(invariant, eq, f));
    yield Law('Invariant Laws: Invariant Composition',
        () => composition(invariant, eq, f));
  }

  static void identity<F>(
    Invariant<F> invariant,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) =>
      check(forall(
          IntGen().map(f),
          (Kind<F, int> fa) => invariant
              .imap<int, int>(fa, core.identity, core.identity)
              .equalUnderTheLaw(eq, fa)));

  static void composition<F>(
    Invariant<F> invariant,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) =>
      check(forall5(
          IntGen().map(f),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          (
            Kind<F, int> fa,
            int Function(int) f1,
            int Function(int) f2,
            int Function(int) g1,
            int Function(int) g2,
          ) =>
              invariant
                  .imap<int, int>(invariant.imap(fa, f1, f2), g1, g2)
                  .equalUnderTheLaw(
                    eq,
                    invariant.imap<int, int>(
                        fa, g1.compose<int>(f1), g2.compose<int>(f2)),
                  )));
}
