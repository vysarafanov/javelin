import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/typeclass/instance/id.dart';

class ForId {
  ForId._();
}

class Id<A> implements Kind<ForId, A> {
  final A value;

  Id(this.value);

  @override
  String toString() => show.show(this);

  @override
  bool operator ==(other) => other is Id<A> ? eq.eqv(this, other) : false;

  static const Functor<ForId> functor = IdType();
  static const Applicative<ForId> applicative = IdType();
  static const Monad<ForId> monad = IdType();
  static const Show<ForId> show = IdType();
  static const Eq<ForId> eq = IdType();
}

extension IdExt<A> on Id<A> {
  Id<B> map<B>(B f(A a)) => Id.functor.map(this, f);
  Id<B> flatMap<B>(Id<B> f(A a)) => Id.monad.flatMap(this, f);
}

extension IdK<A> on Kind<ForId, A> {
  Id<A> fix() => this as Id<A>;
}