import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class MonadLawsAsync {
  static Iterable<Law> laws(
    Monad<ForAsync> M,
  ) sync* {
    yield Law('Monad Laws: left identity', () => leftIdentity(M));
    yield Law('Monad Laws: right identity', () => rightIdentity(M));
    yield Law('Monad Laws: associativity', () => associativity(M));
  }

  static void leftIdentity(
    Monad<ForAsync> M,
  ) =>
      checkAsync(forall2Async(
          Gen.functionAtoB<int, Kind<ForAsync, int>>(Gen.integer().ap(M)),
          Gen.integer(),
          (Kind<ForAsync, int> Function(int) f, int a) =>
              M.flatMap(M.pure(a), f).equalUnderTheLaw(f(a))));

  static void rightIdentity(
    Monad<ForAsync> M,
  ) =>
      checkAsync(forallAsync(
        Gen.integer().ap(M),
        (Kind<ForAsync, int> fa) =>
            M.flatMap<int, int>(fa, M.pure).equalUnderTheLaw(fa),
      ));

  static void associativity(
    Monad<ForAsync> M,
  ) =>
      checkAsync(forall3Async(
          Gen.functionAtoB<int, Kind<ForAsync, int>>(Gen.integer().ap(M)),
          Gen.functionAtoB<int, Kind<ForAsync, int>>(Gen.integer().ap(M)),
          Gen.integer(),
          (
            Kind<ForAsync, int> Function(int) f,
            Kind<ForAsync, int> Function(int) g,
            int a,
          ) =>
              M.flatMap(M.flatMap(M.pure(a), f), g).equalUnderTheLaw(
                    M.flatMap(
                      M.pure(a),
                      (int x) => M.flatMap(M.pure(x), g),
                    ),
                  )));
}
