part of typeclass;

mixin Apply<F> on Functor<F> {
  ///Given both the value and the function are within [F], **ap**ply the function to the value.
  ///
  Kind<F, B> ap<A, B>(Kind<F, A> fa, Kind<F, B Function(A)> ff);
}

extension ApplyExt<F> on Apply<F> {
  Kind<F, Tuple2<A, B>> product<A, B>(Kind<F, A> fa, Kind<F, B> fb) =>
      ap(fb, map(fa, (A a) => (B b) => Tuple2(a, b)));

  Kind<F, Z> map2<A, B, Z>(
          Kind<F, A> fa, Kind<F, B> fb, Z f(Tuple2<A, B> ab)) =>
      map(product(fa, fb), f);
}
