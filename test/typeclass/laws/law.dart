import 'package:javelin/javelin_typeclass.dart';

extension KindExt<F, A> on Kind<F, A> {
  bool underTheLaw(Eq<Kind<F, A>> eq, Kind<F, A> b) => eq.eqv(this, b);
}
