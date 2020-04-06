import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/option.dart';

class OptionType
    with OptionShow, OptionEq, OptionApplicative, OptionFunctor, OptionMonad {
  const OptionType();
}

/*
* Function instance for Option datatype
*/
mixin OptionFunctor on Applicative<Option> implements Functor<Option> {
  @override
  Kind<Option, B> map<A, B>(
    Kind<Option, A> fa,
    B f(A a),
  ) =>
      fa.fix().fold(
            () => Option.none(),
            (value) => pure(f(value)),
          );
}

/*
* Applicative instance for Option datatype
*/
mixin OptionApplicative implements Applicative<Option> {
  @override
  Kind<Option, A> pure<A>(A a) => Option.of(a);
}

/*
* Monad instance for Option datatype
*/
mixin OptionMonad implements Monad<Option> {
  @override
  Kind<Option, B> flatMap<A, B>(
    Kind<Option, A> fa,
    Kind<Option, B> f(A a),
  ) =>
      fa.fix().fold(() => Option.none(), f);
}

/*
* Show instance for Option datatype
*/
mixin OptionShow implements Show<Option> {
  @override
  String show(Option fa) =>
      fa.fix().fold(() => 'None()', (value) => 'Some($value)');
}

/*
* Eq instance for Option datatype
*/
mixin OptionEq implements Eq<Option> {
  @override
  bool eqv(Option a, Option b) => a.fix().fold(
      () => b.fix().fold(
            () => true,
            (_) => false,
          ),
      (value) => b.fix().fold(
            () => false,
            (value) => value == value,
          ));
}
