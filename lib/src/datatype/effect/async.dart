part of datatype_effect;

class ForAsync {
  ForAsync._();
}

class Async<A> implements Kind<ForAsync, A> {
  final Future<A> Function() program;
  Async(this.program);

  static Async<A> pure<A>(A a) => Async(() => Future.value(a));
  static Async<A> lift<A>(Future<A> f()) => Async(f);

  static Invariant<ForAsync> invariant() => asyncTypeInstance;
  static Functor<ForAsync> functor() => asyncTypeInstance;
  static Applicative<ForAsync> applicative() => asyncTypeInstance;
  static Monad<ForAsync> monad() => asyncTypeInstance;
  // static Show<Async<A>> show<A>() => AsyncShow<A>();
  // static Eq<Async<A>> eq<A>() => AsyncEq<A>();
}

extension AsyncK<A> on Kind<ForAsync, A> {
  Async<A> fix() => this as Async<A>;
}
