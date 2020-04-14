part of extension;

class StringJ {
  static Eq<String> eq() => stringTypeInstance;
  static Show<String> show() => stringTypeInstance;
}

final stringTypeInstance = _StringType._();

class _StringType with Eq<String>, Show<String>, StringEq, StringShow {
  const _StringType._();
}

mixin StringShow implements Show<String> {
  @override
  String show(String a) => a.toString();
}

mixin StringEq implements Eq<String> {
  @override
  bool eqv(String a, String b) => a == b;
}
