import 'package:flutter/gestures.dart';
import 'package:graphilia_board/graphilia_board.dart';

bool isPointToPointDistanceEnoughFromPointerKind(
  Offset a,
  Offset b,
  double scaleFactor,
  PointerDeviceKind pointerDeviceKind, {
  double tolerance = 0.0,
}) {
  late final double minDistance;
  switch (pointerDeviceKind) {
    case PointerDeviceKind.touch || PointerDeviceKind.stylus || PointerDeviceKind.invertedStylus:
      minDistance = kTouchSlop;
    case PointerDeviceKind.mouse || PointerDeviceKind.trackpad:
      minDistance = kPrecisePointerPanSlop;
    case PointerDeviceKind.unknown:
      // Fall back to the default value for touch devices that should be enough
      // for most cases.
      minDistance = kPanSlop;
  }
  return isDistanceFromTwoPointsEnough(a, b, minDistance + tolerance, scaleFactor);
}
