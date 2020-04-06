import 'dart:math';

abstract class Gen<T> {
  /// Generate a random sequence of type T, that is compatible
  /// with the constraints of this generator.
  ///
  Iterable<T> random({int count = 100});
}

extension GetExt<A> on Gen<A> {
  Gen<B> map<B>(B f(A a)) => MappedGen<A, B>(this, f);
}

class IntGen implements Gen<int> {
  final _random = Random();
  final max;

  IntGen({this.max = 100});

  @override
  Iterable<int> random({int count = 100}) => Iterable.generate(
        count,
        (_) => _random.nextInt(max),
      );
}

class MappedGen<S, T> implements Gen<T> {
  final Gen<S> _gen;
  final T Function(S) _f;

  MappedGen(this._gen, this._f);

  @override
  Iterable<T> random({int count = 100}) => _gen.random(count: count).map(_f);
}

class FunctionAtoB {
  static Gen<B Function(A)> gen<A, B>(Gen<B> g) =>
      MappedGen(g, (b) => (_) => b);
}
