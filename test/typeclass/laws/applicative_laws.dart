import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class ApplicativeLaws {
  static Iterable<Law> laws<F>(Applicative<F> AP, Eq<Kind<F, int>> EQ,
      Eq<Kind<F, Tuple3<int, int, int>>> EQTuple3) sync* {
    yield Law('Applicative Laws: ap identity', () => apIdentity(AP, EQ));
    yield Law('Applicative Laws: homomorphism', () => homomorphism(AP, EQ));
    yield Law('Applicative Laws: interchange', () => interchange(AP, EQ));
    yield Law('Applicative Laws: map derived', () => mapDerived(AP, EQ));
    yield Law('Applicative Laws: cartesian builder map',
        () => cartesianBuilderMap(AP, EQTuple3));
  }

  static void apIdentity<F>(Applicative<F> AP, Eq<Kind<F, int>> EQ) =>
      check(forall(
        Gen.integer().ap(AP),
        (Kind<F, int> fa) =>
            AP.ap<int, int>(fa, AP.pure(identity)).equalUnderTheLaw(EQ, fa),
      ));

  static void homomorphism<F>(Applicative<F> AP, Eq<Kind<F, int>> EQ) =>
      check(forall2(
        Gen.functionAtoB(Gen.integer()),
        Gen.integer(),
        (int Function(int) f, int a) =>
            AP.ap(AP.pure(a), AP.pure(f)).equalUnderTheLaw(EQ, AP.pure(f(a))),
      ));

  static void interchange<F>(Applicative<F> AP, Eq<Kind<F, int>> EQ) => check(
        forall2(
            Gen.functionAtoB(Gen.integer()).ap(AP),
            Gen.integer(),
            (Kind<F, int Function(int)> fa, int a) =>
                AP.ap(AP.pure(a), fa).equalUnderTheLaw(
                      EQ,
                      AP.ap(fa, AP.pure((int Function(int) x) => x(a))),
                    )),
      );

  static void mapDerived<F>(Applicative<F> AP, Eq<Kind<F, int>> EQ) =>
      check(forall2(
          Gen.integer().ap(AP),
          Gen.functionAtoB(Gen.integer()),
          (Kind<F, int> fa, int Function(int) f) =>
              AP.map(fa, f).equalUnderTheLaw(EQ, AP.ap(fa, AP.pure(f)))));

  static void cartesianBuilderMap<F>(
          Applicative<F> AP, Eq<Kind<F, Tuple3<int, int, int>>> EQ) =>
      check(forall3(
          Gen.integer(),
          Gen.integer(),
          Gen.integer(),
          (int a, int b, int c) => AP
              .map3<int, int, int, Tuple3<int, int, int>>(AP.pure(a),
                  AP.pure(b), AP.pure(c), (Tuple3<int, int, int> abc) => abc)
              .equalUnderTheLaw(
                  EQ,
                  AP.pure<Tuple3<int, int, int>>(
                      Tuple3<int, int, int>(a, b, c)))));
}
