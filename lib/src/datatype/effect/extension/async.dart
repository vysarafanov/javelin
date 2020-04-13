import 'package:javelin/src/datatype/datatype_effect.dart';
import 'package:javelin/src/typeclass.dart';

final asyncTypeInstance = AsyncType();

class AsyncType
    with
        Invariant<ForAsync>,
        Functor<ForAsync>,
        Apply<ForAsync>,
        Applicative<ForAsync>,
        Monad<ForAsync> {
  @override
  Kind<ForAsync, A> pure<A>(A a) => Async.pure(a);

  @override
  Kind<ForAsync, B> flatMap<A, B>(
          Kind<ForAsync, A> fa, Kind<ForAsync, B> f(A a)) =>
      Async(() => fa.fix().program().then((value) => f(value).fix().program()));
}
