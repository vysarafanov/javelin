part of javelin_typeclass;

mixin Applicative<F> on Functor<F> {
  Kind<F, A> pure<A>(A a);
}
