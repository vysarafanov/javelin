import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/typeclass.dart';

final idTypeInstance = IdType._();

class IdType
    with
        Invariant<ForId>,
        Functor<ForId>,
        Apply<ForId>,
        Applicative<ForId>,
        Monad<ForId>,
        Foldable<ForId>,
        Traverse<ForId> {
  const IdType._();

  @override
  Kind<ForId, A> pure<A>(A a) => Id(a);

  @override
  Kind<ForId, B> flatMap<A, B>(Kind<ForId, A> fa, Kind<ForId, B> f(A a)) =>
      f(fa.fix().value);

  @override
  B foldLeft<A, B>(Kind<ForId, A> fa, B initial, B f(B acc, A a)) =>
      f(initial, fa.fix().value);

  @override
  B foldRight<A, B>(Kind<ForId, A> fa, B initial, B f(A a, B acc)) =>
      f(fa.fix().value, initial);

  @override
  Kind<G, Kind<ForId, B>> traverse<G, A, B>(
    Kind<ForId, A> fa,
    Applicative<G> AG,
    Kind<G, B> f(A a),
  ) =>
      AG.map(
        f(fa.fix().value),
        (value) => Id(value),
      );
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
