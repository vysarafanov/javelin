import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../quick_check.dart';
import '../../law.dart';

class MonadLaws {
  static Iterable<Law> laws<F>(Monad<F> M, Eq<Kind<F, int>> EQ) sync* {
    yield Law('Monad Laws: left identity', () => leftIdentity(M, EQ));
    yield Law('Monad Laws: right identity', () => rightIdentity(M, EQ));
    yield Law('Monad Laws: associativity', () => associativity(M, EQ));
  }

  static void leftIdentity<F>(Monad<F> M, Eq<Kind<F, int>> EQ) => check(forall2(
      FunctionAtoB.gen<int, Kind<F, int>>(IntGen().map(M.pure)),
      IntGen(),
      (Kind<F, int> Function(int) f, int a) =>
          M.flatMap(M.pure(a), f).equalUnderTheLaw(EQ, f(a))));

  static void rightIdentity<F>(Monad<F> M, Eq<Kind<F, int>> EQ) => check(forall(
        IntGen().map(M.pure),
        (Kind<F, int> fa) =>
            M.flatMap<int, int>(fa, M.pure).equalUnderTheLaw(EQ, fa),
      ));

  static void associativity<F>(Monad<F> M, Eq<Kind<F, int>> EQ) =>
      check(forall3(
          FunctionAtoB.gen<int, Kind<F, int>>(IntGen().map(M.pure)),
          FunctionAtoB.gen<int, Kind<F, int>>(IntGen().map(M.pure)),
          IntGen(),
          (
            Kind<F, int> Function(int) f,
            Kind<F, int> Function(int) g,
            int a,
          ) =>
              M.flatMap(M.flatMap(M.pure(a), f), g).equalUnderTheLaw(
                    EQ,
                    M.flatMap(
                      M.pure(a),
                      (int x) => M.flatMap(M.pure(x), g),
                    ),
                  )));
}
