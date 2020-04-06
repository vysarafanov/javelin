import 'package:javelin/javelin_typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class EqLaws {
  static Iterable<Law> laws<F>(Eq<F> eq, F f(int c)) sync* {
    yield Law('Eq Laws: reflexivity', () => reflexivityEquality(eq, f));
    yield Law('Eq Laws: commutativity', () => commutativeEquality(eq, f));
    yield Law('Eq Laws: transitivity', () => transitiveEquality(eq, f));
  }

  static void reflexivityEquality<F>(Eq<F> eq, F f(int c)) => check(forall(
        IntGen(),
        (value) {
          final a = f(value);
          return eq.eqv(a, a);
        },
      ));

  static void commutativeEquality<F>(Eq<F> eq, F f(int c)) => check(forall(
        IntGen(),
        (value) {
          final a = f(value);
          final b = f(value);
          return eq.eqv(a, b) == eq.eqv(b, a);
        },
      ));

  static void transitiveEquality<F>(Eq<F> eq, F f(int c)) => check(forall(
        IntGen(),
        (value) {
          final a = f(value);
          final b = f(value);
          final c = f(value);

          return !(eq.eqv(a, b) && eq.eqv(b, c)) || eq.eqv(a, c);
        },
      ));
}
