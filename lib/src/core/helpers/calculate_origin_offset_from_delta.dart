import 'dart:ui';

Offset calculateOriginOffsetFromDelta(
  Offset delta, {
  required Offset originOffset,
  required double scaleFactor,
}) {
  // Scale the delta by the current scale factor
  final scaledDelta = delta / scaleFactor;

  // Subtract the scaled delta from the current origin offset
  final newOriginOffset = originOffset - scaledDelta;

  return newOriginOffset;
}
