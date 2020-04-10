import 'package:javelin/src/typeclass.dart';
import 'package:javelin/src/datatype/id.dart';

final idTypeInstance = IdType._();

class IdType
    with
        Invariant<ForId>,
        Functor<ForId>,
        Apply<ForId>,
        Applicative<ForId>,
        Monad<ForId> {
  const IdType._();

  @override
  Kind<ForId, A> pure<A>(A a) => Id(a);

  @override
  Kind<ForId, B> flatMap<A, B>(Kind<ForId, A> fa, Kind<ForId, B> f(A a)) =>
      f(fa.fix().value);
}

/*
* Show instance for Id datatype
*/
class IdShow<A> implements Show<Id<A>> {
  const IdShow();

  @override
  String show(Id<A> id) => id.toString();
}

/*
* Eq instance for Id datatype
*/
class IdEq<A> implements Eq<Id<A>> {
  const IdEq();

  @override
  bool eqv(Id<A> a, Id<A> b) => a == b;
}
