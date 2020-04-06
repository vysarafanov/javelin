import 'package:javelin/javelin_datatype.dart';
import 'package:javelin/javelin_typeclass.dart';

class IdType with IdShow, IdEq, IdApplicative, IdFunctor, IdMonad {
  const IdType();
}

/*
* Function instance for Id datatype
*/
mixin IdFunctor on Applicative<Id> implements Functor<Id> {
  @override
  Kind<Id, B> map<A, B>(Kind<Id, A> fa, B Function(A a) f) =>
      pure(f(fa.fix().value));
}

/*
* Applicative instance for Id datatype
*/
mixin IdApplicative implements Applicative<Id> {
  @override
  Kind<Id, A> pure<A>(A a) => Id(a);
}

/*
* Monad instance for Id datatype
*/
mixin IdMonad implements Monad<Id> {
  @override
  Kind<Id, B> flatMap<A, B>(Kind<Id, A> fa, Kind<Id, B> f(A a)) =>
      f(fa.fix().value);
}

/*
* Show instance for Id datatype
*/
mixin IdShow implements Show<Id> {
  @override
  String show(Id fa) => 'Id(${fa.fix().value.toString()})';
}

/*
* Eq instance for Id datatype
*/
mixin IdEq implements Eq<Id> {
  @override
  bool eqv(Id a, Id b) => a.fix().value == b.fix().value;
}
