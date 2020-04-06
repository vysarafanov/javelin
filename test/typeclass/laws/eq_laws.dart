import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class EqLaws {
  static Iterable<Law> laws<F>(Eq<F> eq, F cf(int c)) sync* {
    yield Law('Eq Laws: reflexivity', () => reflexivityEquality(eq, cf));
    yield Law('Eq Laws: commutativity', () => commutativeEquality(eq, cf));
    yield Law('Eq Laws: transitivity', () => transitiveEquality(eq, cf));
  }

  static void reflexivityEquality<F>(Eq<F> eq, F cf(int c)) => check(forall1(
        IntGen(),
        (value) {
          final a = cf(value);
          return eq.eqv(a, a);
        },
      ));

  static void commutativeEquality<F>(Eq<F> eq, F cf(int c)) => check(forall1(
        IntGen(),
        (value) {
          final a = cf(value);
          final b = cf(value);
          return eq.eqv(a, b) == eq.eqv(b, a);
        },
      ));

  static void transitiveEquality<F>(Eq<F> eq, F cf(int c)) => check(forall1(
        IntGen(),
        (value) {
          final a = cf(value);
          final b = cf(value);
          final c = cf(value);

          return !(eq.eqv(a, b) && eq.eqv(b, c)) || eq.eqv(a, c);
        },
      ));
}
