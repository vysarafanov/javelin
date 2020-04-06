import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';

void main() {
  final fa = Option.of(5);
  group(('OptionFunctor'), () {
    test('covariant identity', () {
      expect(
        FunctorLaws.covariantIdentity(
          Option.functor,
          Option.eq,
          fa,
        ),
        true,
      );
    });

    test('covariant composition', () {
      expect(
          FunctorLaws.covariantComposition(
            Option.functor,
            Option.eq,
            fa,
            (a) => a.toString(),
            (b) => int.parse(b),
          ),
          true);
    });
  });
}
