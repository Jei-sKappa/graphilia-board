import 'dart:ui';

import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/point/points_in_polygon_mode.dart';

bool isPolygonInsideCircle(
  List<Offset> polygonVertices,
  Offset circleCenter,
  double circleRadius,
  PointsInPolygonMode mode,
) {
  switch (mode) {
    case PointsInPolygonMode.total:
      return areAllPointsInCircle(polygonVertices, circleCenter, circleRadius);
    case PointsInPolygonMode.partial:
      return isAnyPointInCircle(polygonVertices, circleCenter, circleRadius);
  }
}

bool isAnyPointInCircle(
  List<Offset> points,
  Offset circleCenter,
  double circleRadius,
) {
  for (final point in points) {
    final isInside = isPointInCircle(
      point: point,
      circleCenter: circleCenter,
      radius: circleRadius,
    );
    if (isInside) return true;
  }

  return false;
}

bool areAllPointsInCircle(
  List<Offset> points,
  Offset circleCenter,
  double circleRadius,
) {
  for (final point in points) {
    final isInside = isPointInCircle(
      point: point,
      circleCenter: circleCenter,
      radius: circleRadius,
    );
    if (!isInside) return false;
  }

  return true;
}
