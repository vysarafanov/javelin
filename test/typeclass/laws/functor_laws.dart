import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';
import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class FunctorLaws {
  static Iterable<Law> laws<F>(
    Functor<F> functor,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) sync* {
    yield Law(
      'Functor Laws: Covariant Identity',
      () => covariantIdentity(functor, eq, f),
    );
    yield Law(
      'Functor Laws: Covariant Composition',
      () => covariantComposition(functor, eq, f),
    );
  }

  static void covariantIdentity<F>(
    Functor<F> functor,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall(
          IntGen().map(f),
          (Kind<F, int> fa) =>
              functor.map<int, int>(fa, identity).equalUnderTheLaw(eq, fa),
        ),
      );

  static void covariantComposition<F>(
    Functor<F> functor,
    Eq<Kind<F, int>> eq,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall3(
          IntGen().map(f),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          (Kind<F, int> fa, int Function(int) f, int Function(int) g) => functor
              .map<int, int>(functor.map<int, int>(fa, f), g)
              .equalUnderTheLaw(eq, functor.map(fa, f.andThen(g))),
        ),
      );
}
