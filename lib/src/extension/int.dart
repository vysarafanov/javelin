part of extension;

class IntJ {
  static Eq<int> eq() => intTypeInstance;
  static Show<int> show() => intTypeInstance;
  static Semigroup<int> semigoup() => intTypeInstance;
  static Monoid<int> monoid() => intTypeInstance;
}

final intTypeInstance = _IntType._();

class _IntType with Eq<int>, Show<int>, Semigroup<int>, Monoid<int> {
  const _IntType._();

  @override
  int combine(int a, int b) => a + b;

  @override
  int empty() => 0;

  @override
  bool eqv(int a, int b) => a == b;

  @override
  String show(int a) => a.toString();
}
