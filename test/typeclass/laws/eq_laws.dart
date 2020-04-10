import 'package:javelin/typeclass.dart';

import '../../gen.dart';
import '../../law.dart';
import '../../quick_check.dart';

class EqLaws {
  static Iterable<Law> laws<F>(Eq<F> EQ, F f(int c)) sync* {
    yield Law('Eq Laws: reflexivity', () => reflexivityEquality(EQ, f));
    yield Law('Eq Laws: commutativity', () => commutativeEquality(EQ, f));
    yield Law('Eq Laws: transitivity', () => transitiveEquality(EQ, f));
  }

  static void reflexivityEquality<F>(Eq<F> EQ, F f(int c)) => check(forall(
        Gen.integer(),
        (value) {
          final a = f(value);
          return EQ.eqv(a, a);
        },
      ));

  static void commutativeEquality<F>(Eq<F> EQ, F f(int c)) => check(forall(
        Gen.integer(),
        (value) {
          final a = f(value);
          final b = f(value);
          return EQ.eqv(a, b) == EQ.eqv(b, a);
        },
      ));

  static void transitiveEquality<F>(Eq<F> EQ, F f(int c)) => check(forall(
        Gen.integer(),
        (value) {
          final a = f(value);
          final b = f(value);
          final c = f(value);

          return !(EQ.eqv(a, b) && EQ.eqv(b, c)) || EQ.eqv(a, c);
        },
      ));
}
