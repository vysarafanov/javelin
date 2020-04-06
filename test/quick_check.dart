import 'package:javelin/src/datatype/tuple.dart';
import 'package:test/test.dart';

import 'gen.dart';

void check(Property property) {
  expect(property.check(), equals(true));
}

class Property {
  final bool Function() check;
  Property(this.check);
}

Property forall1<A>(
  Gen<A> aGen,
  bool property(A a), {
  int iterations = 100,
}) =>
    Property(() => aGen.random(count: iterations).every(property));

Property forall2<A, B>(
  Gen<A> aGen,
  Gen<B> bGen,
  bool property(A a, B b), {
  int iterations = 1,
}) =>
    Property(() => zip2(
          aGen.random(count: iterations).toList(),
          bGen.random(count: iterations).toList(),
          iterations,
        ).every((tuple) => property(tuple.a, tuple.b)));

Property forall3<A, B, C>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  bool property(A a, B b, C c), {
  int iterations = 1,
}) =>
    Property(() => zip3(
          aGen.random(count: iterations).toList(),
          bGen.random(count: iterations).toList(),
          cGen.random(count: iterations).toList(),
          iterations,
        ).every((tuple) => property(tuple.a, tuple.b, tuple.c)));

Iterable<Tuple2<A, B>> zip2<A, B>(List<A> a, List<B> b, int length) sync* {
  for (var i = 0; i < length; i++) {
    yield Tuple2(a[i], b[i]);
  }
}

Iterable<Tuple3<A, B, C>> zip3<A, B, C>(
    List<A> a, List<B> b, List<C> c, int length) sync* {
  for (var i = 0; i < length; i++) {
    yield Tuple3(a[i], b[i], c[i]);
  }
}
