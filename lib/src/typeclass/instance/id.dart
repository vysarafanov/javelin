import 'package:javelin/javelin_typeclass.dart';

import '../../datatype/id.dart';

class IdType with IdShow, IdEq, IdApplicative, IdFunctor, IdMonad {
  const IdType();
}

/*
* Function instance for Id datatype
*/
mixin IdFunctor on Applicative<ForId> implements Functor<ForId> {
  @override
  Kind<ForId, B> map<A, B>(Kind<ForId, A> fa, B Function(A a) f) =>
      pure(f(fa.fix().value));
}

/*
* Applicative instance for Id datatype
*/
mixin IdApplicative implements Applicative<ForId> {
  @override
  Kind<ForId, A> pure<A>(A a) => Id(a);
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
mixin IdShow implements Show<ForId> {
  @override
  String show<A>(Kind<ForId, A> fa) => 'Id(${fa.fix().value.toString()})';
}

/*
* Eq instance for Id datatype
*/
mixin IdEq implements Eq<ForId> {
  @override
  bool eqv<A>(Kind<ForId, A> a, Kind<ForId, A> b) =>
      a.fix().value == b.fix().value;
}