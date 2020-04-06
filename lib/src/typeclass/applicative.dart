part of javelin_typeclass;

mixin Applicative<F> on Apply<F> {
  Kind<F, A> pure<A>(A a);
}
