import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/typeclass/instance/option.dart';

class ForOption {
  ForOption._();
}

abstract class Option<A> implements Kind<ForOption, A> {
  B fold<B>(B ifNone(), B ifSome(A a));

  static Option<A> of<A>(A a) => a == null ? _None() : _Some(a);
  static Option<A> none<A>() => _None();

  static Invariant<ForOption> invariant() => optoinTypeInstance;
  static Functor<ForOption> functor() => optoinTypeInstance;
  static Applicative<ForOption> applicative() => optoinTypeInstance;
  static Monad<ForOption> monad() => optoinTypeInstance;
  static Show<Option<A>> show<A>(Show<A> SA) => OptionShow(SA);
  static Eq<Option<A>> eq<A>(Eq<A> EQ) => OptionEq(EQ);
}

extension OptionExt<A> on Option<A> {
  Option<B> map<B>(B f(A a)) => Option.functor().map(this, f);
  Option<B> flatMap<B>(Option<B> f(A a)) => Option.monad().flatMap(this, f);
  String show(Show<A> SA) => Option.show(SA).show(this);
  bool eq(Eq<A> EQ, Option<A> other) => Option.eq(EQ).eqv(this, other);
}

extension OptionK<A> on Kind<ForOption, A> {
  Option<A> fix() => this as Option<A>;
}

class _Some<A> extends Option<A> {
  final A _a;
  _Some(this._a);
  A get value => _a;

  @override
  B fold<B>(B ifNone(), B ifSome(A a)) => ifSome(_a);

  @override
  int get hashCode => _a.hashCode;
}

class _None<A> extends Option<A> {
  @override
  B fold<B>(B ifNone(), B ifSome(A a)) => ifNone();

  @override
  int get hashCode => 0;
}
