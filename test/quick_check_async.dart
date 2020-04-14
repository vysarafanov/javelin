import 'package:javelin/src/core.dart';
import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:test/test.dart';

import 'gen.dart';

void checkAsync(PropertyAsync property) {
  expect(property.checkAsync(), completion(equals(true)));
}

class PropertyAsync {
  final Future<bool> Function() checkAsync;
  PropertyAsync(this.checkAsync);
}

PropertyAsync forallAsync<A>(
  Gen<A> aGen,
  Future<bool> property(A a), {
  int iterations = 100,
}) =>
    PropertyAsync(() => Future.wait(aGen.generate(iterations).map(property))
        .then((value) => value.every(identity)));

PropertyAsync forall2Async<A, B>(
  Gen<A> aGen,
  Gen<B> bGen,
  Future<bool> property(A a, B b), {
  int iterations = 100,
}) =>
    PropertyAsync(() => Future.wait(zip2(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          iterations,
        ).map((tuple) => property(tuple.a, tuple.b)))
            .then((value) => value.every(identity)));

PropertyAsync forall3Async<A, B, C>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  Future<bool> property(A a, B b, C c), {
  int iterations = 100,
}) =>
    PropertyAsync(() => Future.wait(zip3(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          iterations,
        ).map((tuple) => property(tuple.a, tuple.b, tuple.c)))
            .then((value) => value.every(identity)));

PropertyAsync forall4Async<A, B, C, D>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  Gen<D> dGen,
  Future<bool> property(A a, B b, C c, D d), {
  int iterations = 100,
}) =>
    PropertyAsync(() => Future.wait(zip4(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          dGen.generate(iterations).toList(),
          iterations,
        ).map((tuple) => property(tuple.a, tuple.b, tuple.c, tuple.d)))
            .then((value) => value.every(identity)));

PropertyAsync forall5Async<A, B, C, D, E>(
  Gen<A> aGen,
  Gen<B> bGen,
  Gen<C> cGen,
  Gen<D> dGen,
  Gen<E> eGen,
  Future<bool> property(A a, B b, C c, D d, E e), {
  int iterations = 100,
}) =>
    PropertyAsync(() => Future.wait(zip5(
          aGen.generate(iterations).toList(),
          bGen.generate(iterations).toList(),
          cGen.generate(iterations).toList(),
          dGen.generate(iterations).toList(),
          eGen.generate(iterations).toList(),
          iterations,
        ).map((tuple) => property(tuple.a, tuple.b, tuple.c, tuple.d, tuple.e)))
            .then((value) => value.every(identity)));

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
