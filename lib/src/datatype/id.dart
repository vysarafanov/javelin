import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/typeclass/instance/id.dart';

class ForId {
  ForId._();
}

class Id<A> implements Kind<ForId, A> {
  final A value;

  Id(this.value);

  static Invariant<ForId> invariant() => idTypeInstance;
  static Functor<ForId> functor() => idTypeInstance;
  static Applicative<ForId> applicative() => idTypeInstance;
  static Monad<ForId> monad() => idTypeInstance;
  static Show<Id<A>> show<A>(Show<A> SA) => IdShow<A>(SA);
  static Eq<Id<A>> eq<A>(Eq<A> EQ) => IdEq<A>(EQ);
}

extension IdExt<A> on Id<A> {
  Id<B> map<B>(B f(A a)) => Id.functor().map(this, f);
  Id<B> flatMap<B>(Id<B> f(A a)) => Id.monad().flatMap(this, f);
  String show(Show<A> SA) => Id.show(SA).show(this);
  bool eq(Eq<A> EQ, Id<A> other) => Id.eq(EQ).eqv(this, other);
}

extension IdK<A> on Kind<ForId, A> {
  Id<A> fix() => this as Id<A>;
}
