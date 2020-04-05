part of javelin_typeclass;

mixin Functor<F> {
  Kind<F, B> map<A, B>(covariant Kind<F, A> fa, B f(A a));
}

extension FunctorExt<F> on Functor<F> {
  int plus1(int value) => value + 1;
}
