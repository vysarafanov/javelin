import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/id.dart';

final idTypeInstance = IdType._();

class IdType
    with
        Invariant<ForId>,
        Functor<ForId>,
        Apply<ForId>,
        Applicative<ForId>,
        Monad<ForId>,
        IdApplicative,
        IdMonad {
  const IdType._();
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
class IdShow<A> implements Show<Id<A>> {
  final Show<A> SA;

  const IdShow(this.SA);

  @override
  String show(Id<A> id) => 'Id(${SA.show(id.value)})';
}

/*
* Eq instance for Id datatype
*/
class IdEq<A> implements Eq<Id<A>> {
  final Eq<A> EQ;

  const IdEq(this.EQ);

  @override
  bool eqv(Id<A> a, Id<A> b) => EQ.eqv(a.value, b.value);
}
