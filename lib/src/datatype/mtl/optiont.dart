part of datatype_mtl;

class ForOptionT {
  ForOptionT._();
}

class OptionT<F, A> implements Kind<Kind<ForOptionT, F>, A> {
  final Kind<F, Option<A>> value;

  OptionT(this.value);

  @override
  String toString() => value.toString();
  @override
  bool operator ==(other) => other is OptionT<F, A> && value == other.value;
  @override
  int get hashCode => value.hashCode;

  static OptionT<F, A> of<F, A>(Applicative<F> AF, A a) =>
      OptionT(AF.pure(Option.of<A>(a)));

  static OptionT<F, A> none<F, A>(Applicative<F> AF) =>
      OptionT(AF.pure(Option.none<A>()));

  OptionT<F, B> map<B>(Functor<F> FF, B f(A a)) =>
      OptionT(FF.map(value, (Option<A> a) => a.map(f)));

  OptionT<F, B> flatMap<B>(Monad<F> MF, Kind<Kind<ForOptionT, F>, B> f(A a)) =>
      flatMapF(MF, (a) => f(a).fix().value);

  OptionT<F, B> flatMapF<B>(Monad<F> MF, Kind<F, Option<B>> f(A a)) =>
      OptionT(MF.flatMap(value,
          (Option<A> option) => option.fold(() => MF.pure(Option.none()), f)));

  Kind<Kind<ForOptionT, F>, B> ap<B>(
          Monad<F> MF, Kind<Kind<ForOptionT, F>, B Function(A)> ff) =>
      flatMap(MF, (A a) => ff.fix().map(MF, (f) => f(a)));

  static Functor<Kind<ForOptionT, F>> functor<F>(Functor<F> FF) =>
      OptionTFunctor(FF);

  static Applicative<Kind<ForOptionT, F>> applicative<F>(Monad<F> MF) =>
      OptionTApplicative(MF);
  static ApplicativeError<Kind<ForOptionT, F>, E> applicativeError<F, E>(
          MonadError<F, E> ME) =>
      OptionTApplicativeError(ME);
  static Monad<Kind<ForOptionT, F>> monad<F>(Monad<F> MF) => OptionTMonad(MF);
  static MonadError<Kind<ForOptionT, F>, E> monadError<F, E>(
          MonadError<F, E> ME) =>
      OptionTMonadError(ME);
  static Show<OptionT<F, A>> show<F, A>() => OptionTShow();
  static Eq<OptionT<F, A>> eq<F, A>() => OptionTEq();
}

extension OptionTK<F, A> on Kind<Kind<ForOptionT, F>, A> {
  OptionT<F, A> fix() => this as OptionT<F, A>;
}
