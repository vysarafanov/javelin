part of typeclass;

mixin Monoid<A> on Semigroup<A> {
  A empty();
}

// A combine<A>(Monoid<A> monoid, List<A> list) =>
//     list.fold(monoid.empty(), monoid.combine);

// class IntMonoid with Semigroup<int>, Monoid<int> {
//   @override
//   int combine(int a, int b) => a + b;

//   @override
//   int empty() => 0;
// }

// class StringMonoid with Semigroup<String>, Monoid<String> {
//   @override
//   String combine(String a, String b) => a + b;

//   @override
//   String empty() => '';
// }

// void main() {
//   print(combine(StringMonoid(), ['M', 'O', 'N', 'O', 'I', 'D']));
//   print(combine(IntMonoid(), [1, 2, 3, 4, 5]));
// }
