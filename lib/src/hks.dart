part of javelin_typeclass;

abstract class Kind<F, A> {}

abstract class Kind2<F, A, B> implements Kind<Kind<F, A>, B> {}
