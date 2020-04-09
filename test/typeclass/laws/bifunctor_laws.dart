import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart' as core;

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class BifunctorLaws {
  static Iterable<Law> laws<F>(
    Bifunctor<F> BF,
    Kind<Kind<F, int>, int> f(int i),
    Eq<Kind<Kind<F, int>, int>> EQ,
  ) sync* {
    yield Law('Bifunctor Laws: Identity', () => identity(BF, f, EQ));
    yield Law('Bifunctor Laws: Composition', () => composition(BF, f, EQ));
  }

  static void identity<F>(
    Bifunctor<F> BF,
    Kind<Kind<F, int>, int> f(int i),
    Eq<Kind<Kind<F, int>, int>> EQ,
  ) =>
      check(forall(
          Gen.integer().map(f),
          (Kind<Kind<F, int>, int> fa) => BF
              .bimap<int, int, int, int>(fa, core.identity, core.identity)
              .equalUnderTheLaw(EQ, fa)));

  static void composition<F>(
    Bifunctor<F> BF,
    Kind<Kind<F, int>, int> f(int i),
    Eq<Kind<Kind<F, int>, int>> EQ,
  ) =>
      check(forall5(
          Gen.integer().map(f),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<Kind<F, int>, int> fa, int f(int i), int g(int i), int x(int i),
                  int y(int i)) =>
              BF
                  .bimap(BF.bimap<int, int, int, int>(fa, f, g), x, y)
                  .equalUnderTheLaw(
                      EQ, BF.bimap(fa, f.andThen(x), g.andThen(y)))));
}
