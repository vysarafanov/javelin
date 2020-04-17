part of datatype_std;

class ForList {
  ForList._();
}

class ListJ<A> extends DelegatingList<A> implements Kind<ForList, A> {
  ListJ(List<A> base) : super(base);

  ListJ<A> combineJ(ListJ<A> b) => (this + b).j();

  ListJ<B> mapJ<B>(B f(A a)) => map(f).toList().j();

  ListJ<B> flatMapJ<B>(Kind<ForList, B> f(A a)) =>
      expand((e) => f(e).fix()).toList().j();

  B foldLeft<B>(B initial, B f(B acc, A a)) => fold(initial, f);
  B foldRight<B>(B initial, B f(A a, B acc)) => reversed.fold(
      initial, (previousValue, element) => f(element, previousValue));

  Kind<F, ListJ<B>> traverse<F, B>(Applicative<F> AF, Kind<F, B> f(A a)) =>
      foldRight(
          AF.pure<ListJ<B>>(ListJ.emptyJ<B>()),
          (A a, Kind<F, ListJ<B>> acc) => AF.ap(
              f(a),
              AF.map<ListJ<B>, ListJ<B> Function(B b)>(
                  acc, (ListJ<B> l) => (B a) => ([a] + l).j())));

  static ListJ<A> emptyJ<A>() => <A>[].j();
  static ListJ<A> pureJ<A>(A a) => [a].j();

  static Invariant<ForList> invariant() => listjTypeInstance;
  static Functor<ForList> functor() => listjTypeInstance;
  static Applicative<ForList> applicative() => listjTypeInstance;
  static Monad<ForList> monad() => listjTypeInstance;
  static Foldable<ForList> foldable() => listjTypeInstance;
  static Traverse<ForList> traversable() => listjTypeInstance;
  static Show<ListJ<A>> show<A>() => ListJShow<A>();
  static Eq<ListJ<A>> eq<A>() => ListJEq<A>();
}

extension ListExt<A> on List<A> {
  ListJ<A> j() => ListJ(this);
}

extension ListJExt<A> on Kind<ForList, A> {
  ListJ<A> fix() => this as ListJ<A>;
}
