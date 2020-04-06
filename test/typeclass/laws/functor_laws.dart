import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';
import '../../gen.dart';
import '../../quick_check.dart';
import '../laws/law.dart';

class FunctorLaws {
  static Iterable<Law> laws<F>(
    Functor<F> functor,
    Eq<F> eq,
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
    Eq<F> eq,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall1(
          IntGen().map(f),
          (fa) => functor.map(fa, identity).underTheLaw(eq, fa),
        ),
      );

  static void covariantComposition<F>(
    Functor<F> functor,
    Eq<F> eq,
    Kind<F, int> f(int a),
  ) =>
      check(
        forall3(
          IntGen().map(f),
          FunctionAtoB.gen<int, int>(IntGen()),
          FunctionAtoB.gen<int, int>(IntGen()),
          (Kind<F, int> fa, int Function(int) f, int Function(int) g) => functor
              .map<int, int>(functor.map<int, int>(fa, f), g)
              .underTheLaw(eq, functor.map(fa, f.andThen(g))),
        ),
      );
}
