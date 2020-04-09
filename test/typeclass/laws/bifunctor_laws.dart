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
  }

  static void identity<F>(Bifunctor<F> BF, Kind<Kind<F, int>, int> f(int i),
          Eq<Kind<Kind<F, int>, int>> EQ) =>
      check(forall(
          Gen.integer().map(f),
          (Kind<Kind<F, int>, int> fa) => BF
              .bimap<int, int, int, int>(fa, core.identity, core.identity)
              .equalUnderTheLaw(EQ, fa)));
  /*
  fun <F> laws(BF: Bifunctor<F>, f: (Int) -> Kind2<F, Int, Int>, EQ: Eq<Kind2<F, Int, Int>>): List<Law> =
        listOf(
            Law("Bifunctor Laws: Identity") { BF.identity(f, EQ) },
            Law("Bifunctor Laws: Composition") { BF.composition(f, EQ) }
        )

    fun <F> Bifunctor<F>.identity(f: (Int) -> Kind2<F, Int, Int>, EQ: Eq<Kind2<F, Int, Int>>): Unit =
        forAll(Gen.int().map(f)) { fa: Kind2<F, Int, Int> ->
            fa.bimap({ it }, { it }).equalUnderTheLaw(fa, EQ)
        }

    fun <F> Bifunctor<F>.composition(f: (Int) -> Kind2<F, Int, Int>, EQ: Eq<Kind2<F, Int, Int>>): Unit =
        forAll(
          Gen.int().map(f),
          Gen.functionAToB<Int, Int>(Gen.int()),
          Gen.functionAToB<Int, Int>(Gen.int()),
          Gen.functionAToB<Int, Int>(Gen.int()),
          Gen.functionAToB<Int, Int>(Gen.int())
        ) { fa: Kind2<F, Int, Int>, ff, g, x, y ->
            fa.bimap(ff, g).bimap(x, y).equalUnderTheLaw(fa.bimap(ff andThen x, g andThen y), EQ)
        }
  */
}
