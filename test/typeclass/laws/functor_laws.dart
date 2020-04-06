import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';
import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class FunctorLaws {
  static Iterable<Law> laws<F>(
    Functor<F> FN,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) sync* {
    yield Law(
      'Functor Laws: Covariant Identity',
      () => covariantIdentity(FN, EQ, f),
    );
    yield Law(
      'Functor Laws: Covariant Composition',
      () => covariantComposition(FN, EQ, f),
    );
  }

  static void covariantIdentity<F>(
    Functor<F> FN,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall(
          IntGen().map(f),
          (Kind<F, int> fa) =>
              FN.map<int, int>(fa, identity).equalUnderTheLaw(EQ, fa),
        ),
      );

  static void covariantComposition<F>(
    Functor<F> FN,
    Eq<Kind<F, int>> EQ,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall3(
          IntGen().map(f),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          (Kind<F, int> fa, int Function(int) f, int Function(int) g) => FN
              .map<int, int>(FN.map<int, int>(fa, f), g)
              .equalUnderTheLaw(EQ, FN.map(fa, f.andThen(g))),
        ),
      );
}
