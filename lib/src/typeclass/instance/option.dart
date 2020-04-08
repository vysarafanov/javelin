import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/option.dart';

final optionTypeInstance = OptionType._();

class OptionType
    with
        Invariant<ForOption>,
        Functor<ForOption>,
        Apply<ForOption>,
        Applicative<ForOption>,
        // ApplicativeError<ForOption, void>,
        Monad<ForOption> {
  const OptionType._();

  ///Applicative
  @override
  Kind<ForOption, A> pure<A>(A a) => Option.of(a);

  // ///ApplicativeError
  // @override
  // Kind<ForOption, A> raiseError<A>([_]) => Option.none();

  // @override
  // Kind<ForOption, A> handleErrorWith<A>(
  //         Kind<ForOption, A> fa, Kind<ForOption, A> f([_])) =>
  //     fa.fix().orElse(() => f().fix());

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
  final Show<A> SA;
  const OptionShow(this.SA);

  @override
  String show(Option<A> fa) =>
      fa.fold(() => 'None()', (value) => 'Some(${SA.show(value)})');
}

/*
* Eq instance for Option datatype
*/
class OptionEq<A> implements Eq<Option<A>> {
  final Eq<A> EQ;
  const OptionEq(this.EQ);

  @override
  bool eqv(Option<A> fa, Option<A> fb) => fa.fold(
      () => fb.fold(
            () => true,
            (_) => false,
          ),
      (a) => fb.fold(
            () => false,
            (b) => EQ.eqv(a, b),
          ));
}
