import 'dart:math';

class ZIndexManager {
  ZIndexManager([int initialValue = 0]) : _current = initialValue;

  int _current;

  /// Returns the current z-index without incrementing it.
  int peek() => _current;

  /// Returns the current z-index and increments it.
  int read() => _current++;

  /// Call this function whenever a new z-index is used and was not generated by
  /// [read].
  void notifyUnsupervised(int unsupervised) =>
      _current = max(_current, unsupervised);
}
