part of typeclass;

mixin Apply<F> on Functor<F> {
  ///Given both the value and the function are within [F], **ap**ply the function to the value.
  ///
  Kind<F, B> ap<A, B>(Kind<F, A> fa, Kind<F, B Function(A)> ff);
}

extension ApplyExt<F> on Apply<F> {
  Kind<F, Tuple2<A, B>> product<A, B>(Kind<F, A> fa, Kind<F, B> fb) =>
      ap(fb, map(fa, (A a) => (B b) => Tuple2(a, b)));

  Kind<F, Tuple3<A, B, C>> product2<A, B, C>(
          Kind<F, Tuple2<A, B>> fab, Kind<F, C> fc) =>
      ap(fc, map(fab, (Tuple2<A, B> ab) => (C c) => Tuple3(ab.a, ab.b, c)));

  Kind<F, Z> map2<A, B, Z>(
          Kind<F, A> fa, Kind<F, B> fb, Z f(Tuple2<A, B> ab)) =>
      map<Tuple2<A, B>, Z>(product<A, B>(fa, fb), f);

  Kind<F, Z> map3<A, B, C, Z>(Kind<F, A> fa, Kind<F, B> fb, Kind<F, C> fc,
          Z f(Tuple3<A, B, C> abc)) =>
      map<Tuple3<A, B, C>, Z>(product2<A, B, C>(product<A, B>(fa, fb), fc), f);
}
