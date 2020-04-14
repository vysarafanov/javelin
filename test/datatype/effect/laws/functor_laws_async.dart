import 'package:javelin/src/core.dart';
import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class FunctorLawsAsync {
  static Iterable<Law> laws(
    Functor<ForAsync> FF,
    Kind<ForAsync, int> f(int a),
  ) sync* {
    yield Law(
      'Functor Laws: Covariant Identity',
      () => covariantIdentity(FF, f),
    );
    yield Law(
      'Functor Laws: Covariant Composition',
      () => covariantComposition(FF, f),
    );
  }

  static void covariantIdentity(
    Functor<ForAsync> FF,
    Kind<ForAsync, int> f(int a),
  ) =>
      checkAsync(
        forallAsync(
          Gen.integer().map(f),
          (Kind<ForAsync, int> fa) =>
              FF.map<int, int>(fa, identity).equalUnderTheLaw(fa),
        ),
      );

  static void covariantComposition(
    Functor<ForAsync> FF,
    Kind<ForAsync, int> f(int a),
  ) =>
      checkAsync(
        forall3Async(
          Gen.integer().map(f),
          Gen.functionAtoB<int, int>(Gen.integer()),
          Gen.functionAtoB<int, int>(Gen.integer()),
          (Kind<ForAsync, int> fa, int Function(int) f, int Function(int) g) =>
              FF
                  .map<int, int>(FF.map<int, int>(fa, f), g)
                  .equalUnderTheLaw(FF.map(fa, f.andThen(g))),
        ),
      );
}
