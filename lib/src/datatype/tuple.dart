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
