part of typeclass;

mixin Traverse<F> on Functor<F>, Foldable<F> {
  Kind<G, Kind<F, B>> traverse<G, A, B>(
    Kind<F, A> fa,
    Applicative<G> AG,
    Kind<G, B> f(A a),
  );

  Kind<G, Kind<F, A>> sequence<G, A>(
    Kind<F, Kind<G, A>> fa,
    Applicative<G> AG,
  ) =>
      traverse(fa, AG, identity);
}

extension TraverseExt<F> on Traverse<F> {
  /// Thread all the `G` effects through the `F` structure to invert the structure from `F<G<A>>` to `G<F<A>>`.
  ///

}
