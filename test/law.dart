import 'package:javelin/src/datatype/datatype_core.dart';
import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';
import 'package:test/test.dart';

class Law {
  final String name;
  final void Function() test;

  Law(this.name, this.test);
}

extension KindExt<F, A> on Kind<F, A> {
  bool equalUnderTheLaw(Eq<Kind<F, A>> eq, Kind<F, A> b) => eq.eqv(this, b);
}

extension AsyncExt<A> on Kind<ForAsync, A> {
  Future<bool> equalUnderTheLaw(Kind<ForAsync, A> b) async {
    final aRes = await fix()
        .program()
        .then((value) => Either.right<Exception, A>(value))
        .catchError((error) => Either.left<Exception, A>(error));

    final bRes = await b
        .fix()
        .program()
        .then((value) => Either.right<Exception, A>(value))
        .catchError((error) => Either.left<Exception, A>(error));

    return aRes == bRes;
  }
}

extension LawsExt on Iterable<Law> {
  void check() => forEach((law) => test(law.name, law.test));
}
