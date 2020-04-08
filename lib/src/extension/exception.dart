part of javelin_extension;

class ExceptoinJ {}

final exceptionTypeInstance = _ExceptionType._();

class _ExceptionType with Eq<Exception>, Show<Exception> {
  const _ExceptionType._();

  @override
  String show(Exception a) => a.toString();

  @override
  bool eqv(Exception a, Exception b) => a == b;
}
