import 'package:collection/equality.dart';
import 'package:javelin/javelin.dart';
import 'package:javelin/src/datatype/datatype_std.dart';

final listjTypeInstance = ListJType();

class ListJType
    with
        Invariant<ForList>,
        Functor<ForList>,
        Apply<ForList>,
        Applicative<ForList>,
        Monad<ForList>,
        Foldable<ForList>,
        Traverse<ForList> {
  @override
  Kind<ForList, A> pure<A>(A a) => ListJ.pureJ(a);

  @override
  Kind<ForList, B> flatMap<A, B>(
          Kind<ForList, A> fa, Kind<ForList, B> f(A a)) =>
      fa.fix().flatMapJ(f);

  @override
  B foldLeft<A, B>(Kind<ForList, A> fa, B b, B f(B b, A a)) =>
      fa.fix().foldLeft(b, f);

  @override
  B foldRight<A, B>(Kind<ForList, A> fa, B b, B f(A a, B b)) =>
      fa.fix().foldRight(b, f);

  @override
  Kind<G, Kind<ForList, B>> traverse<G, A, B>(
    Kind<ForList, A> fa,
    Applicative<G> AG,
    Kind<G, B> f(A a),
  ) =>
      fa.fix().traverse(AG, f);
}

class ListJShow<A> implements Show<ListJ<A>> {
  const ListJShow();

  @override
  String show(ListJ<A> fa) => fa.toString();
}

class ListJEq<A> implements Eq<ListJ<A>> {
  final eq = ListEquality<A>();
  ListJEq();

  @override
  bool eqv(ListJ<A> fa, ListJ<A> fb) => eq.equals(fa, fb);
}
