import 'package:javelin/src/datatype.dart';
import 'package:test/test.dart';

import 'gen.dart';

void check(Property property) {
  expect(property.check(), equals(true));
}

class Property {
  final bool Function() check;
  Property(this.check);
}

Property forall<A>(
  Gen<A> aGen,
  bool property(A a), {
  int iterations = 100,
}) =>
    Property(() => aGen.generate(iterations).every(property));

Property forall2<A, B>(
  Gen<A> aGen,
  Gen<B> bGen,
  bool property(A a, B b), {
  int iterations = 100,
}) =>
    Property(() => zip2(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          iterations,
        ).every((tuple) => property(tuple.a, tuple.b)));

Property forall3<A, B, C>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  bool property(A a, B b, C c), {
  int iterations = 100,
}) =>
    Property(() => zip3(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          iterations,
        ).every((tuple) => property(tuple.a, tuple.b, tuple.c)));

Property forall4<A, B, C, D>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  Gen<D> dGen,
  bool property(A a, B b, C c, D d), {
  int iterations = 100,
}) =>
    Property(() => zip4(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          dGen.generate(iterations).toList(),
          iterations,
        ).every((tuple) => property(tuple.a, tuple.b, tuple.c, tuple.d)));

Property forall5<A, B, C, D, E>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  Gen<D> dGen,
  Gen<E> eGen,
  bool property(A a, B b, C c, D d, E e), {
  int iterations = 100,
}) =>
    Property(() => zip5(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          dGen.generate(iterations).toList(),
          eGen.generate(iterations).toList(),
          iterations,
        ).every(
            (tuple) => property(tuple.a, tuple.b, tuple.c, tuple.d, tuple.e)));

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

Iterable<Tuple4<A, B, C, D>> zip4<A, B, C, D>(
    List<A> a, List<B> b, List<C> c, List<D> d, int length) sync* {
  for (var i = 0; i < length; i++) {
    yield Tuple4(a[i], b[i], c[i], d[i]);
  }
}

Iterable<Tuple5<A, B, C, D, E>> zip5<A, B, C, D, E>(
    List<A> a, List<B> b, List<C> c, List<D> d, List<E> e, int length) sync* {
  for (var i = 0; i < length; i++) {
    yield Tuple5(a[i], b[i], c[i], d[i], e[i]);
  }
}
