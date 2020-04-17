import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class TraverseLaws {
  static Iterable<Law> laws<F>(
      Traverse<F> TF, Kind<F, int> cf(int i), Eq<Kind<F, int>> EQ) sync* {
    yield Law('Traverse Laws: Identity', () => identityTraverse(TF, cf, EQ));
  }
  // Law("Traverse Laws: Identity", { identityTraverse(TF, AF, { AF.just(it) }, EQ) }),
  //             Law("Traverse Laws: Sequential composition", { sequentialComposition(TF, { AF.just(it) }, EQ) }),
  //             Law("Traverse Laws: Parallel composition", { parallelComposition(TF, { AF.just(it) }, EQ) }),
  //             Law("Traverse Laws: FoldMap derived", { foldMapDerived(TF, { AF.just(it) }) }

  static void identityTraverse<F>(
          Traverse<F> TF, Kind<F, int> cf(int i), Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.functionAtoB<int, Kind<ForId, int>>(
              Gen.integer().map(Id.applicative().pure)),
          Gen.integer().map(cf),
          (Kind<ForId, int> f(int i), Kind<F, int> fa) => TF
              .traverse<ForId, int, int>(fa, Id.applicative(), f)
              .fix()
              .value
              .equalUnderTheLaw(
                  EQ,
                  TF.map(
                    TF.map(fa, f),
                    (Kind<ForId, int> id) => id.fix().value,
                  ))));

  // static void sequentialComposition<F>(
  //         Traverse<F> TF, Kind<F, int> cf(int i), Eq<Kind<F, int>> EQ) =>
  //     check(forAll3(
  //         Gen.functionAtoB<int, Kind<ForId, int>>(
  //             Gen.integer().map(Id.applicative().pure)),
  //         Gen.functionAtoB<int, Kind<ForId, int>>(
  //             Gen.integer().map(Id.applicative().pure)),
  //         Gen.integer().map(cf), (Kind<ForId, int> f(int i),
  //             Kind<ForId, int> g(int i), Kind<F, int> fha) {
  //       final fa = TF.traverse(fha, Id.applicative(), f).fix();
  //       final composed = fa
  //           .map((Kind<F, int> a) => TF.traverse(a, Id.applicative(), g))
  //           .value
  //           .fix()
  //           .value;

  //           final expected = TF.traverse(fha, AG, (a) => null)
  //     }));
}

/*

  fun <F> Traverse<F>.sequentialComposition(cf: (Int) -> Kind<F, Int>, EQ: Eq<Kind<F, Int>>) = Id.applicative().run {
    val idApp = this
    forAll(Gen.functionAToB<Int, Kind<ForId, Int>>(Gen.intSmall().map(::Id)),
      Gen.functionAToB<Int, Kind<ForId, Int>>(Gen.intSmall().map(::Id)),
      Gen.intSmall().map(cf)) { f: (Int) -> Kind<ForId, Int>, g: (Int) -> Kind<ForId, Int>, fha: Kind<F, Int> ->

      val fa = fha.traverse(idApp, f).fix()
      val composed = fa.map { it.traverse(idApp, g) }.value().value()
      val expected = fha.traverse(ComposedApplicative(idApp, idApp)) { a: Int -> f(a).map(g).nest() }.unnest().extract().extract()
      composed.equalUnderTheLaw(expected, EQ)
    }
  }

  fun <F> Traverse<F>.parallelComposition(cf: (Int) -> Kind<F, Int>, EQ: Eq<Kind<F, Int>>) =
    forAll(Gen.functionAToB<Int, Kind<ForId, Int>>(Gen.intSmall().map(::Id)), Gen.functionAToB<Int, Kind<ForId, Int>>(Gen.intSmall().map(::Id)), Gen.intSmall().map(cf)) { f: (Int) -> Kind<ForId, Int>, g: (Int) -> Kind<ForId, Int>, fha: Kind<F, Int> ->
      val TIA = object : Applicative<TIF> {
        override fun <A> just(a: A): Kind<TIF, A> =
          TIC(Id(a) toT Id(a))

        override fun <A, B> Kind<TIF, A>.ap(ff: Kind<TIF, (A) -> B>): Kind<TIF, B> {
          val (fam, fan) = fix().ti
          val (fm, fn) = ff.fix().ti
          return TIC(Id.applicative().run { fam.ap(fm) toT fan.ap(fn) })
        }
      }

      val TIEQ: Eq<TI<Kind<F, Int>>> = Eq { a, b ->
        with(EQ) {
          a.a.extract().eqv(b.a.extract()) && a.b.extract().eqv(b.b.extract())
        }
      }

      val seen: TI<Kind<F, Int>> = fha.traverse(TIA) { TIC(f(it) toT g(it)) }.fix().ti
      val expected: TI<Kind<F, Int>> = TIC(fha.traverse(Id.applicative(), f) toT fha.traverse(Id.applicative(), g)).ti

      seen.equalUnderTheLaw(expected, TIEQ)
    }

  fun <F> Traverse<F>.foldMapDerived(cf: (Int) -> Kind<F, Int>) =
    forAll(Gen.functionAToB<Int, Int>(Gen.intSmall()), Gen.intSmall().map(cf)) { f: (Int) -> Int, fa: Kind<F, Int> ->
      val traversed = fa.traverse(Const.applicative(Int.monoid())) { a -> f(a).const() }.value()
      val mapped = fa.foldMap(Int.monoid(), f)
      mapped.equalUnderTheLaw(traversed, Eq.any())
    }
*/
