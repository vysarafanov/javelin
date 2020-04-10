part of extension;

class IntJ {
  static Eq<int> eq() => intTypeInstance;
  static Show<int> show() => intTypeInstance;
}

final intTypeInstance = _IntType._();

class _IntType with Eq<int>, Show<int>, IntEq, IntShow {
  const _IntType._();
}

mixin IntShow implements Show<int> {
  @override
  String show(int a) => a.toString();
}

mixin IntEq implements Eq<int> {
  @override
  bool eqv(int a, int b) => a == b;
}
