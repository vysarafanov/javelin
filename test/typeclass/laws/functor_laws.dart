import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/core.dart';
import '../laws/law.dart';

class FunctorLaws {
  static bool covariantIdentity<F, A>(
    Functor<F> functor,
    Eq<Kind<F, A>> eq,
    Kind<F, A> fa,
  ) =>
      functor.map(fa, identity).underTheLaw(eq, fa);

  static bool covariantComposition<F, A, B, C>(
    Functor<F> functor,
    Eq<Kind<F, C>> eq,
    Kind<F, A> fa,
    B f(A a),
    C g(B b),
  ) =>
      functor
          .map(functor.map(fa, (f)), g)
          .underTheLaw(eq, functor.map(fa, f.andThen(g)));
}
