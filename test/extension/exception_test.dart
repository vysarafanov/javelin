import 'dart:async';
import 'dart:io';

import 'package:javelin/javelin_extension.dart';
import 'package:test/test.dart';

import '../law.dart';
import '../typeclass/laws/eq_laws.dart';
import '../typeclass/laws/show_laws.dart';

final exceptions = [FormatException(), HttpException(''), TimeoutException('')];

Iterable<Law> exceptionLaws() sync* {
  yield* ShowLaws.laws(
      ExceptionJ.show(), ExceptionJ.eq(), (i) => exceptions[i % 3]);
  yield* EqLaws.laws(ExceptionJ.eq(), (i) => exceptions[i % 3]);
}

void main() {
  group('Exception extension type:', () {
    exceptionLaws().check();
  });
}
