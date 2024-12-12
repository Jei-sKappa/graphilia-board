import 'dart:math';

extension Log2 on num {
  double log2() => log(this) / log(2);
}