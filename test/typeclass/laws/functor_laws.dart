import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';
import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class FunctorLaws {
  static Iterable<Law> laws<F>(
    Functor<F> FF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) sync* {
    yield Law(
      'Functor Laws: Covariant Identity',
      () => covariantIdentity(FF, EQ, f),
    );
    yield Law(
      'Functor Laws: Covariant Composition',
      () => covariantComposition(FF, EQ, f),
    );
  }

  static void covariantIdentity<F>(
    Functor<F> FF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall(
          Gen.integer().map(f),
          (Kind<F, int> fa) =>
              FF.map<int, int>(fa, identity).equalUnderTheLaw(EQ, fa),
        ),
      );

  static void covariantComposition<F>(
    Functor<F> FF,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall3(
          Gen.integer().map(f),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<F, int> fa, int Function(int) f, int Function(int) g) => FF
              .map<int, int>(FF.map<int, int>(fa, f), g)
              .equalUnderTheLaw(EQ, FF.map(fa, f.andThen(g))),
        ),
      );
}
