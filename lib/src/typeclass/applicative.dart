part of javelin_typeclass;

mixin Applicative<F> on Apply<F> {
  Kind<F, A> pure<A>(A a);

  @override
  Kind<F, B> map<A, B>(Kind<F, A> fa, B f(A a)) => ap(fa, pure(f));
}
