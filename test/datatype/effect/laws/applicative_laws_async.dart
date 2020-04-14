import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:javelin/src/core.dart';

import '../../../gen.dart';
import '../../../law.dart';
import '../../../quick_check_async.dart';

class ApplicativeLawsAsync {
  static Iterable<Law> laws(
    Applicative<ForAsync> AP,
  ) sync* {
    yield Law('Applicative Laws: ap identity', () => apIdentity(AP));
    yield Law('Applicative Laws: homomorphism', () => homomorphism(AP));
    yield Law('Applicative Laws: interchange', () => interchange(AP));
    yield Law('Applicative Laws: map derived', () => mapDerived(AP));
  }

  static void apIdentity(
    Applicative<ForAsync> AP,
  ) =>
      checkAsync(forallAsync(
        Gen.integer().ap(AP),
        (Kind<ForAsync, int> fa) =>
            AP.ap<int, int>(fa, AP.pure(identity)).equalUnderTheLaw(fa),
      ));

  static void homomorphism(
    Applicative<ForAsync> AP,
  ) =>
      checkAsync(forall2Async(
        Gen.functionAtoB(Gen.integer()),
        Gen.integer(),
        (int Function(int) f, int a) =>
            AP.ap(AP.pure(a), AP.pure(f)).equalUnderTheLaw(AP.pure(f(a))),
      ));

  static void interchange(
    Applicative<ForAsync> AP,
  ) =>
      checkAsync(
        forall2Async(
            Gen.functionAtoB(Gen.integer()).ap(AP),
            Gen.integer(),
            (Kind<ForAsync, int Function(int)> fa, int a) =>
                AP.ap(AP.pure(a), fa).equalUnderTheLaw(
                      AP.ap(fa, AP.pure((int Function(int) x) => x(a))),
                    )),
      );

  static void mapDerived(
    Applicative<ForAsync> AP,
  ) =>
      checkAsync(forall2Async(
          Gen.integer().ap(AP),
          Gen.functionAtoB(Gen.integer()),
          (Kind<ForAsync, int> fa, int Function(int) f) =>
              AP.map(fa, f).equalUnderTheLaw(AP.ap(fa, AP.pure(f)))));
}
