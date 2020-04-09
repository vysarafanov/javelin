part of javelin_extension;

class ExceptionJ {
  static Eq<Exception> eq() => exceptionTypeInstance;
  static Show<Exception> show() => exceptionTypeInstance;
}

final exceptionTypeInstance = _ExceptionType._();

class _ExceptionType with Eq<Exception>, Show<Exception> {
  const _ExceptionType._();

  @override
  String show(Exception a) => a.toString();

  @override
  bool eqv(Exception a, Exception b) => a == b;
}
