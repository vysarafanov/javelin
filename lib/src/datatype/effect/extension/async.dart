import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';

final asyncTypeInstance = AsyncType();

class AsyncType
    with
        Invariant<ForAsync>,
        Functor<ForAsync>,
        Apply<ForAsync>,
        Applicative<ForAsync>,
        ApplicativeError<ForAsync, Exception>,
        Monad<ForAsync>,
        MonadError<ForAsync, Exception> {
  @override
  Kind<ForAsync, A> pure<A>(A a) => Async.pure(a);

  @override
  Kind<ForAsync, B> flatMap<A, B>(
          Kind<ForAsync, A> fa, Kind<ForAsync, B> f(A a)) =>
      Async(() => fa.fix().program().then((value) => f(value).fix().program()));

  @override
  Kind<ForAsync, A> raiseError<A>(Exception e) => Async(() => Future.error(e));

  @override
  Kind<ForAsync, A> handleErrorWith<A>(
          Kind<ForAsync, A> fa, Kind<ForAsync, A> f(Exception e)) =>
      Async(() => fa.fix().program().catchError((e) => f(e).fix().program()));
}
