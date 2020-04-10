import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:javelin/javelin_typeclass.dart';
import 'package:javelin/src/datatype/either.dart';
import 'package:javelin/src/typeclass/instance/option.dart';

abstract class Gen<T> {
  T random();

  static Gen<int> integer({int max = 100}) => _IntGen(max: max);
  static Gen<B Function(A)> functionAtoB<A, B>(Gen<B> genB) =>
      _MappedGen(genB, (b) => (_) => b);
  static Gen<Exception> exception() => _ExceptionGen();
  static Gen<bool> boolean() => _BoolGen();
  static Gen<Unit> unit() => _UnitGen();

  static Gen<A> oneOf<A>(Iterable<Gen<A>> gens) => _OneOfGen(gens);

  static Gen<Kind<F, A>> applicativeError<F, A, E>(
          Gen<A> genA, Gen<E> genE, ApplicativeError<F, E> AE) =>
      oneOf<Either<E, A>>([
        genA.map<Either<E, A>>(Either.right),
        genE.map<Either<E, A>>(Either.left)
      ]).map((either) => either.fold(AE.raiseError, AE.pure));

  static Gen<Either<E, A>> either<E, A>(Gen<E> genE, Gen<A> genA) {
    final genLeft = genE.map<Either<E, A>>(Either.left);
    final genRight = genA.map<Either<E, A>>(Either.right);
    return Gen.oneOf([genLeft, genRight]);
  }
}

extension GenExt<A> on Gen<A> {
  Gen<B> map<B>(B f(A a)) => _MappedGen<A, B>(this, f);

  Gen<Kind<F, A>> ap<F>(Applicative<F> AP) => map(AP.pure);
  Gen<Kind<F, A>> apError<F, E>(ApplicativeError<F, E> AE, Gen<E> eGen) =>
      Gen.applicativeError(this, eGen, AE);

  Iterable<A> generate(int count) sync* {
    for (var i = 0; i < count; i++) {
      yield random();
    }
  }
}

class _OneOfGen<A> implements Gen<A> {
  final List<Gen<A>> _gens;
  final int _max;
  final _random = Random();

  _OneOfGen(this._gens) : _max = _gens.length;

  @override
  A random() => _gens[_random.nextInt(_max)].random();
}

class _ExceptionGen implements Gen<Exception> {
  static final List<Exception> _exceptions = [
    FormatException(),
    HttpException(''),
    TimeoutException('')
  ];

  final _max = _exceptions.length;
  final _random = Random();
  _ExceptionGen();

  @override
  Exception random() => _exceptions[_random.nextInt(_max)];
}

class _IntGen implements Gen<int> {
  final _random = Random();
  final max;

  _IntGen({this.max = 100});

  @override
  int random() => _random.nextInt(max);
}

class _MappedGen<S, T> implements Gen<T> {
  final Gen<S> _gen;
  final T Function(S) _f;

  _MappedGen(this._gen, this._f);

  @override
  T random() => _f(_gen.random());
}

class _BoolGen implements Gen<bool> {
  final _random = Random();
  _BoolGen();

  @override
  bool random() => _random.nextBool();
}

class _UnitGen implements Gen<Unit> {
  @override
  Unit random() => Unit();
}
