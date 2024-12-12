import 'dart:ui';

({
  Offset originOffset,
  double scaleFactor,
}) calculateOriginOffsetAndScaleFactorFromRelativeScale(
  double scale, {
  required Offset point,
  required Offset initialInteractionPoint,
  required Offset initialOriginOffset,
  required double initialScaleFactor,
}) {
  final result = calculateOriginOffsetAndScaleFactorFromScale(
    scale,
    point: point,
    originOffset: initialOriginOffset,
    scaleFactor: initialScaleFactor,
  );

  final focalPointsDelta = point - initialInteractionPoint;

  final scaledFocalPointsDelta = focalPointsDelta / initialScaleFactor;

  final newScaleFactor = result.scaleFactor;

  // Translate the origin offset by the scaled focal points delta
  final newOriginOffset = result.originOffset - scaledFocalPointsDelta;

  return (
    originOffset: newOriginOffset,
    scaleFactor: newScaleFactor,
  );
}

({
  Offset originOffset,
  double scaleFactor,
}) calculateOriginOffsetAndScaleFactorFromScale(
  double scale, {
  required Offset point,
  required Offset originOffset,
  required double scaleFactor,
}) {
  final newScaleFactor = scaleFactor * scale;

  final scaledPoint = point / scaleFactor;

  final realPoint = scaledPoint + originOffset;

  final scaledRealPoint = realPoint / scale;

  final scaledOrigin = originOffset / scale;

  final newOriginOffset = realPoint - scaledRealPoint + scaledOrigin;

  return (
    originOffset: newOriginOffset,
    scaleFactor: newScaleFactor,
  );
}
