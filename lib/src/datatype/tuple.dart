class Tuple2<A, B> {
  final A a;
  final B b;

  Tuple2(this.a, this.b);

  @override
  String toString() => 'Tuple2(a=$a, b=$b)';

  @override
  bool operator ==(other) =>
      other is Tuple2<A, B> && other.a == a && other.b == b;

  @override
  int get hashCode => a.hashCode + b.hashCode;
}

class Tuple3<A, B, C> {
  final A a;
  final B b;
  final C c;

  Tuple3(this.a, this.b, this.c);

  @override
  String toString() => 'Tuple3(a=$a, b=$b, c=$c)';

  @override
  bool operator ==(other) =>
      other is Tuple3<A, B, C> && other.a == a && other.b == b && other.c == c;

  @override
  int get hashCode => a.hashCode + b.hashCode + c.hashCode;
}

class Tuple4<A, B, C, D> {
  final A a;
  final B b;
  final C c;
  final D d;

  Tuple4(this.a, this.b, this.c, this.d);

  @override
  String toString() => 'Tuple4(a=$a, b=$b, c=$c, d=$d)';

  @override
  bool operator ==(other) =>
      other is Tuple4<A, B, C, D> &&
      other.a == a &&
      other.b == b &&
      other.c == c &&
      other.d == d;

  @override
  int get hashCode => a.hashCode + b.hashCode + c.hashCode + d.hashCode;
}

class Tuple5<A, B, C, D, E> {
  final A a;
  final B b;
  final C c;
  final D d;
  final E e;

  Tuple5(this.a, this.b, this.c, this.d, this.e);

  @override
  String toString() => 'Tuple5(a=$a, b=$b, c=$c, d=$d, e=$e)';

  @override
  bool operator ==(other) =>
      other is Tuple5<A, B, C, D, E> &&
      other.a == a &&
      other.b == b &&
      other.c == c &&
      other.d == d &&
      other.e == e;

  @override
  int get hashCode =>
      a.hashCode + b.hashCode + c.hashCode + d.hashCode + e.hashCode;
}
