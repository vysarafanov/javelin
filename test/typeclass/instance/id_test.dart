import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';
import 'package:test/test.dart';

Kind<F, int> plus1<F>(Functor<F> functor, Kind<F, int> fa) =>
    functor.map(fa, (value) => value + 1);

void main() {
  final value = 5;
  final expectedValue = 6;

  test('plus1 - Id', () {
    expect(plus1(Id.functor, Id(value)).fix().value, expectedValue);
  });

  test('plus1 - Option', () {
    plus1(Option.functor, Option.of(6)).fix().fold(
        () => expect(false, true), (value) => expect(value, expectedValue));
  });
}
