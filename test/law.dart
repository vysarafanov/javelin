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

extension LawsExt on Iterable<Law> {
  void check() => forEach((law) => test(law.name, law.test));
}
