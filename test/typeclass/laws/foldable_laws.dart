import 'package:javelin/src/extension.dart';
import 'package:javelin/src/typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class FoldableLaws {
  static Iterable<Law> laws<F>(Foldable<F> FF, Kind<F, int> cf(int i)) sync* {
    yield Law('Foldable Laws: Left fold consistent with foldMap',
        () => leftFoldConsistentWithFoldMap(FF, cf, IntJ.eq(), IntJ.monoid()));
    yield Law('Foldable Laws: Right fold consistent with foldMap',
        () => rightFoldConsistentWithFoldMap(FF, cf, IntJ.eq(), IntJ.monoid()));
    /*
    
      Law("Foldable Laws: Exists is consistent with find") { FF.existsConsistentWithFind(cf) },
      Law("Foldable Laws: Exists is lazy") { FF.existsIsLazy(cf, EQ) },
      Law("Foldable Laws: ForAll is lazy") { FF.forAllIsLazy(cf, EQ) },
      Law("Foldable Laws: ForAll consistent with exists") { FF.forallConsistentWithExists(cf) },
      Law("Foldable Laws: ForAll returns true if isEmpty") { FF.forallReturnsTrueIfEmpty(cf) },
      Law("Foldable Laws: FirstOption returns None if isEmpty") { FF.firstOptionReturnsNoneIfEmpty(cf) },
      Law("Foldable Laws: FirstOption returns None if predicate fails") { FF.firstOptionReturnsNoneIfPredicateFails(cf) },
      Law("Foldable Laws: FoldM for Id is equivalent to fold left") { FF.foldMIdIsFoldL(cf, EQ) }
    */
  }

  static void leftFoldConsistentWithFoldMap<F>(
          Foldable<F> FF, Kind<F, int> cf(int i), Eq<int> EQ, Monoid<int> MN) =>
      check(forall2(
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.integer().map(cf),
          (int f(int i), Kind<F, int> fa) => EQ.eqv(
                FF.foldMap(fa, MN, f),
                FF.foldLeft(fa, MN.empty(), (acc, a) => MN.combine(acc, f(a))),
              )));

  static void rightFoldConsistentWithFoldMap<F>(
          Foldable<F> FF, Kind<F, int> cf(int i), Eq<int> EQ, Monoid<int> MN) =>
      check(forall2(
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.integer().map(cf),
          (int f(int i), Kind<F, int> fa) => EQ.eqv(
                FF.foldMap(fa, MN, f),
                FF.foldRight(fa, MN.empty(), (a, b) => MN.combine(f(a), b)),
              )));
  /*f

  fun <F> Foldable<F>.existsConsistentWithFind(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.intPredicate(), Gen.int().map(cf)) { f: (Int) -> Boolean, fa: Kind<F, Int> ->
      fa.exists(f).equalUnderTheLaw(fa.find(f).fold({ false }, { true }), Eq.any())
    }

  fun <F> Foldable<F>.existsIsLazy(cf: (Int) -> Kind<F, Int>, EQ: Eq<Int>) =
    forAll(Gen.int().map(cf)) { fa: Kind<F, Int> ->
      val sideEffect = SideEffect()
      fa.exists { _ ->
        sideEffect.increment()
        true
      }
      val expected = if (fa.isEmpty()) 0 else 1
      sideEffect.counter.equalUnderTheLaw(expected, EQ)
    }

  fun <F> Foldable<F>.forAllIsLazy(cf: (Int) -> Kind<F, Int>, EQ: Eq<Int>) =
    forAll(Gen.int().map(cf)) { fa: Kind<F, Int> ->
      val sideEffect = SideEffect()
      fa.forAll { _ ->
        sideEffect.increment()
        true
      }
      val expected = if (fa.isEmpty()) 0 else 1
      sideEffect.counter.equalUnderTheLaw(expected, EQ)
    }

  fun <F> Foldable<F>.forallConsistentWithExists(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.intPredicate(), Gen.int().map(cf)) { f: (Int) -> Boolean, fa: Kind<F, Int> ->
      if (fa.forAll(f)) {
        // if f is true for all elements, then there cannot be an element for which
        // it does not hold.
        val negationExists = fa.exists { a -> !(f(a)) }
        // if f is true for all elements, then either there must be no elements
        // or there must exist an element for which it is true.
        !negationExists && (fa.isEmpty() || fa.exists(f))
      } else true
    }

  fun <F> Foldable<F>.forallReturnsTrueIfEmpty(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.intPredicate(), Gen.int().map(cf)) { f: (Int) -> Boolean, fa: Kind<F, Int> ->
      !fa.isEmpty() || fa.forAll(f)
    }

  fun <F> Foldable<F>.firstOptionReturnsNoneIfEmpty(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.int().map(cf)) { fa: Kind<F, Int> ->
      if (fa.isEmpty()) fa.firstOption().isEmpty()
      else fa.firstOption().isDefined()
    }

  fun <F> Foldable<F>.firstOptionReturnsNoneIfPredicateFails(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.int().map(cf)) { fa: Kind<F, Int> ->
      fa.firstOption { false }.isEmpty()
    }

  fun <F> Foldable<F>.foldMIdIsFoldL(cf: (Int) -> Kind<F, Int>, EQ: Eq<Int>) =
    forAll(Gen.functionAToB<Int, Int>(Gen.intSmall()), Gen.intSmall().map(cf)) { f: (Int) -> Int, fa: Kind<F, Int> ->
      with(Int.monoid()) {
        val foldL: Int = fa.foldLeft(empty()) { acc, a -> acc.combine(f(a)) }
        val foldM: Int = fa.foldM(Id.monad(), empty()) { acc, a -> Id(acc.combine(f(a))) }.extract()
        foldM.equalUnderTheLaw(foldL, EQ)
      }
    }
  */
}
