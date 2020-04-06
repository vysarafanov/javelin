import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/id.dart';

class IdType
    with
        Invariant<ForId>,
        Functor<ForId>,
        Apply<ForId>,
        Applicative<ForId>,
        Monad<ForId>,
        IdApplicative,
        IdMonad {
  const IdType();
}

/*
* Applicative instance for Id datatype
* Implementation of Functor for Id data type
*/
mixin IdApplicative implements Applicative<ForId> {
  @override
  Kind<ForId, A> pure<A>(A a) => Id(a);

  @override
  Kind<ForId, B> map<A, B>(Kind<ForId, A> fa, B Function(A a) f) =>
      pure(f(fa.fix().value));
}

/*
* Monad instance for Id datatype
*/
mixin IdMonad implements Monad<ForId> {
  @override
  Kind<ForId, B> flatMap<A, B>(Kind<ForId, A> fa, Kind<ForId, B> f(A a)) =>
      f(fa.fix().value);
}

/*
* Show instance for Id datatype
*/
class IdShow<A> implements Show<Kind<ForId, A>> {
  const IdShow();

  @override
  String show(Kind<ForId, A> fa) => 'Id(${fa.fix().value.toString()})';
}

/*
* Eq instance for Id datatype
*/
class IdEq<A> implements Eq<Kind<ForId, A>> {
  @override
  bool eqv(Kind<ForId, A> a, Kind<ForId, A> b) =>
      a.fix().value == b.fix().value;
}
