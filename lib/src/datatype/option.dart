import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/typeclass/instance/option.dart';

abstract class Option<A> implements Kind<Option, A> {
  B fold<B>(B ifNone(), B ifSome(A a));

  static Option<A> of<A>(A a) => a == null ? _None() : _Some(a);
  static Option<A> none<A>() => _None();

  @override
  String toString() => show.show(this);

  @override
  bool operator ==(other) => other is Option<A> ? eq.eqv(this, other) : false;

  static const Functor<Option> functor = OptionType();
  static const Applicative<Option> applicative = OptionType();
  static const Monad<Option> monad = OptionType();
  static const Show<Option> show = OptionType();
  static const Eq<Option> eq = OptionType();
}

extension OptionExt<A> on Option<A> {
  Option<B> map<B>(B f(A a)) => Option.functor.map(this, f);
  Option<B> flatMap<B>(Option<B> f(A a)) => Option.monad.flatMap(this, f);
}

extension OptionK<A> on Kind<Option, A> {
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
