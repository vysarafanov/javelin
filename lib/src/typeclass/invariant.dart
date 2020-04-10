part of typeclass;

mixin Invariant<F> {
  Kind<F, B> imap<A, B>(Kind<F, A> fa, B f(A a), A g(B b));
}
