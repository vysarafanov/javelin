import 'package:javelin/typeclass.dart';
import 'package:javelin/src/typeclass/instance/id.dart';

class ForId {
  ForId._();
}

class Id<A> implements Kind<ForId, A> {
  final A value;

  Id(this.value);

  @override
  String toString() => 'Id($value)';
  @override
  bool operator ==(other) => other is Id<A> && value == other.value;
  @override
  int get hashCode => value.hashCode;

  static Invariant<ForId> invariant() => idTypeInstance;
  static Functor<ForId> functor() => idTypeInstance;
  static Applicative<ForId> applicative() => idTypeInstance;
  static Monad<ForId> monad() => idTypeInstance;
  static Show<Id<A>> show<A>() => IdShow<A>();
  static Eq<Id<A>> eq<A>() => IdEq<A>();
}

extension IdExt<A> on Id<A> {
  Id<B> map<B>(B f(A a)) => Id.functor().map(this, f);
  Id<B> flatMap<B>(Id<B> f(A a)) => Id.monad().flatMap(this, f);
  String show() => Id.show().show(this);
  bool eq(Id<A> other) => Id.eq().eqv(this, other);
}

extension IdK<A> on Kind<ForId, A> {
  Id<A> fix() => this as Id<A>;
}
