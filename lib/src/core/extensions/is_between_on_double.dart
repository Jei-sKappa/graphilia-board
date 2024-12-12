extension IsBetweenOnDouble on double {
  /// Returns true if the value is between [min] and [max] (inclusive).
  bool isBetween(double min, double max) {
    return this >= min && this <= max;
  }

  /// Returns true if the value is between [min] and [max] (exclusive).
  bool isBetweenStrict(double min, double max) {
    return this > min && this < max;
  }
}
