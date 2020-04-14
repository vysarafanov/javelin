import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:javelin/src/core.dart' as core;

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class InvariantLawsAsync {
  static Iterable<Law> laws(
    Invariant<ForAsync> IF,
    Kind<ForAsync, int> f(int a),
  ) sync* {
    yield Law('Invariant Laws: Invariant Identity', () => identity(IF, f));
    yield Law(
        'Invariant Laws: Invariant Composition', () => composition(IF, f));
  }

  static void identity(
    Invariant<ForAsync> IF,
    Kind<ForAsync, int> f(int a),
  ) =>
      checkAsync(forallAsync(
          Gen.integer().map(f),
          (Kind<ForAsync, int> fa) => IF
              .imap<int, int>(fa, core.identity, core.identity)
              .equalUnderTheLaw(fa)));

  static void composition(
    Invariant<ForAsync> IF,
    Kind<ForAsync, int> f(int a),
  ) =>
      checkAsync(forall5Async(
          Gen.integer().map(f),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (
            Kind<ForAsync, int> fa,
            int Function(int) f1,
            int Function(int) f2,
            int Function(int) g1,
            int Function(int) g2,
          ) =>
              IF.imap<int, int>(IF.imap(fa, f1, f2), g1, g2).equalUnderTheLaw(
                    IF.imap<int, int>(
                        fa, g1.compose<int>(f1), g2.compose<int>(f2)),
                  )));
}
