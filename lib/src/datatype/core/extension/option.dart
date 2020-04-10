import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/typeclass.dart';

final optionTypeInstance = OptionType._();

class OptionType
    with
        Invariant<ForOption>,
        Functor<ForOption>,
        Apply<ForOption>,
        Applicative<ForOption>,
        ApplicativeError<ForOption, Unit>,
        Monad<ForOption>,
        MonadError<ForOption, Unit> {
  const OptionType._();

  ///Applicative
  @override
  Kind<ForOption, A> pure<A>(A a) => Option.of(a);

  ///ApplicativeError
  @override
  Kind<ForOption, A> raiseError<A>([_]) => Option.none();

  @override
  Kind<ForOption, A> handleErrorWith<A>(
          Kind<ForOption, A> fa, Kind<ForOption, A> f(Unit e)) =>
      fa.fix().orElse(() => f(Unit()).fix());

  ///Monad
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
class OptionShow<A> implements Show<Option<A>> {
  const OptionShow();

  @override
  String show(Option<A> fa) => fa.toString();
}

/*
* Eq instance for Option datatype
*/
class OptionEq<A> implements Eq<Option<A>> {
  const OptionEq();

  @override
  bool eqv(Option<A> fa, Option<A> fb) => fa == fb;
}
