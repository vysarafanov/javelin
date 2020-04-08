import 'dart:math';

abstract class Gen<T> {
  T random();
}

extension GenExt<A> on Gen<A> {
  Gen<B> map<B>(B f(A a)) => MappedGen<A, B>(this, f);
  Iterable<A> generate(int count) sync* {
    for (var i = 0; i < count; i++) {
      yield random();
    }
  }
}

class IntGen implements Gen<int> {
  final _random = Random();
  final max;

  IntGen({this.max = 100});

  @override
  int random() => _random.nextInt(max);
}

class MappedGen<S, T> implements Gen<T> {
  final Gen<S> _gen;
  final T Function(S) _f;

  MappedGen(this._gen, this._f);

  @override
  T random() => _f(_gen.random());
}

class FunctionAtoB {
  static Gen<B Function(A)> gen<A, B>(Gen<B> g) =>
      MappedGen(g, (b) => (_) => b);
}
