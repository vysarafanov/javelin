import 'package:javelin/typeclass.dart';
import 'package:javelin/src/typeclass/instance/option.dart';

class ForOption {
  ForOption._();
}

abstract class Option<A> implements Kind<ForOption, A> {
  B fold<B>(B ifNone(), B ifSome(A a));

  static Option<A> of<A>(A a) => a == null ? _None() : _Some(a);
  static Option<A> none<A>() => _None();

  static Invariant<ForOption> invariant() => optionTypeInstance;
  static Functor<ForOption> functor() => optionTypeInstance;
  static Applicative<ForOption> applicative() => optionTypeInstance;
  static ApplicativeError<ForOption, Unit> applicativeError() =>
      optionTypeInstance;
  static Monad<ForOption> monad() => optionTypeInstance;
  static MonadError<ForOption, Unit> monadError() => optionTypeInstance;
  static Show<Option<A>> show<A>() => OptionShow();
  static Eq<Option<A>> eq<A>() => OptionEq();
}

extension OptionExt<A> on Option<A> {
  Option<B> map<B>(B f(A a)) => Option.functor().map(this, f);
  Option<B> flatMap<B>(Option<B> f(A a)) => Option.monad().flatMap(this, f);
  String show() => Option.show().show(this);
  bool eq(Option<A> other) => Option.eq().eqv(this, other);
  bool isEmpty() => fold(() => true, (_) => false);
  Option<A> orElse(Option<A> alternative()) => isEmpty() ? alternative() : this;
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
  String toString() => 'Some($_a)';
  @override
  bool operator ==(other) => other is _Some<A> && other._a == _a;
  @override
  int get hashCode => _a.hashCode;
}

class _None<A> extends Option<A> {
  @override
  B fold<B>(B ifNone(), B ifSome(A a)) => ifNone();

  @override
  String toString() => 'None()';
  @override
  bool operator ==(other) => other is _None;
  @override
  int get hashCode => 0;
}
