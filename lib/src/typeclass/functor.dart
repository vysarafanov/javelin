part of javelin_typeclass;

mixin Functor<F> on Invariant<F> {
  ///Transform the [F] wrapped value [A] into [B] preserving the [F] structure
  /// `Kind<F, A> -> Kind<F, B>`
  ///
  Kind<F, B> map<A, B>(Kind<F, A> fa, B f(A a));

  @override
  Kind<F, B> imap<A, B>(Kind<F, A> fa, B f(A a), A g(B b)) => map(fa, f);
}

extension FunctorExt<F> on Functor<F> {
  /// Lifts a function `A -> B` to the [F] structure returning a polymorphic function
  /// that can be applied over all [F] values in the shape of `Kind<F, A>`
  ///
  /// `A -> B -> Kind<F, A> -> Kind<F, B>`
  ///
  Kind<F, B> Function(Kind<F, A> fa) lift<A, B>(B f(A a)) =>
      (Kind<F, A> fa) => map(fa, f);

  /// Discards the [A] value inside [F] signaling this container may be pointing to a noop
  /// or an effect whose return value is deliberately ignored. The singleton value [void] serves as signal.
  ///
  Kind<F, void> unit<A>(Kind<F, A> fa) => map(fa, (_) {});

  ///Replaces [A] inside [F] with [B] resulting in a `Kind<F, B>`
  /// `Kind<F, A> -> Kind<F, B>`
  ///
  Kind<F, B> replace<A, B>(Kind<F, A> fa, B b) => map(fa, (_) => b);

  ///Given [A] is a sub type of [B], re-type this value from `Kind<F, A>` to `Kind<F, B>`
  /// `Kind<F, A> -> Kind<F, B>`
  ///
  Kind<F, B> widen<B, A extends B>(Kind<F, A> fa) => fa;
}
