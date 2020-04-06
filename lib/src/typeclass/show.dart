part of javelin_typeclass;

mixin Show<F> {
  String show<A>(covariant Kind<F, A> fa);
}
