import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/option.dart';

class OptionType
    with
        Invariant<ForOption>,
        Functor<ForOption>,
        OptionApplicative,
        OptionMonad {
  const OptionType();
}

/*
* Applicative instance for Option datatype
* Implementation of Functor for Option data type
*/
mixin OptionApplicative implements Applicative<ForOption> {
  @override
  Kind<ForOption, A> pure<A>(A a) => Option.of(a);

  @override
  Kind<ForOption, B> map<A, B>(
    Kind<ForOption, A> fa,
    B f(A a),
  ) =>
      fa.fix().fold(
            () => Option.none(),
            (a) => pure(f(a)),
          );
}

/*
* Monad instance for Option datatype
*/
mixin OptionMonad implements Monad<ForOption> {
  @override
  Kind<ForOption, B> flatMap<A, B>(
    Kind<ForOption, A> fa,
    Kind<ForOption, B> f(A a),
  ) =>
      fa.fix().fold(() => Option.none(), f);
}

/*
* Show instance for Option datatype
*/
class OptionShow<A> implements Show<Kind<ForOption, A>> {
  const OptionShow();

  @override
  String show(Kind<ForOption, A> fa) =>
      fa.fix().fold(() => 'None()', (value) => 'Some($value)');
}

/*
* Eq instance for Option datatype
*/
class OptionEq<A> implements Eq<Kind<ForOption, A>> {
  const OptionEq();

  @override
  bool eqv(Kind<ForOption, A> a, Kind<ForOption, A> b) => a.fix().fold(
      () => b.fix().fold(
            () => true,
            (_) => false,
          ),
      (value) => b.fix().fold(
            () => false,
            (value) => value == value,
          ));
}
