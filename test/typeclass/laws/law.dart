import 'package:javelin/javelin_typeclass.dart';

class Law {
  final String name;
  final void Function() test;

  Law(this.name, this.test);
}

extension KindExt<F, A> on Kind<F, A> {
  bool underTheLaw(Eq<F> eq, Kind<F, A> b) => eq.eqv(this, b);
}
