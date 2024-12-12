import 'dart:ui';

bool isDistanceFromTwoPointsEnough(
  Offset a,
  Offset b,
  double minDistance,
  double scaleFactor,
) =>
    (a - b).distance > (minDistance / scaleFactor);
