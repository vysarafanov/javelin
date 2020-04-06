import 'package:javelin/javelin_datatype.dart';
import 'package:test/test.dart';

import '../laws/functor_laws.dart';

void main() {
  final fa = Id(5);
  group(('IdFunctor'), () {
    test('covariant identity', () {
      expect(
        FunctorLaws.covariantIdentity(Id.functor, Id.eq, fa),
        true,
      );
    });

    test('covariant composition', () {
      expect(
          FunctorLaws.covariantComposition(
            Id.functor,
            Id.eq,
            fa,
            (a) => a.toString(),
            (b) => int.parse(b),
          ),
          true);
    });
  });
}
