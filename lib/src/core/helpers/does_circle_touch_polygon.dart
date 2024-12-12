import 'dart:math';
import 'dart:ui';

import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/point/point.dart';

/// Determines if a circle intersects, is inside, or contains a polygon.
bool doesCircleTouchPolygon(Offset center, double radius, List<Offset> polygon) {
  // Check if the center of the circle is inside the polygon
  if (isPointInPolygon(center, polygon)) {
    return true;
  }

  // Check if the circle intersects the polygon
  if (_doesCirlceIntersectPolygon(center, radius, polygon)) {
    return true;
  }

  // Check if the entire polygon is inside the circle
  if (areAllPointsInCircle(polygon, center, radius)) {
    return true;
  }

  // If none of the conditions are met, return false
  return false;
}

bool _doesCirlceIntersectPolygon(Offset center, double radius, List<Offset> polygon) {
  for (int i = 0; i < polygon.length; i++) {
    Offset p1 = polygon[i];
    Offset p2 = polygon[(i + 1) % polygon.length];

    // Calculate the distance from the center of the circle to the line segment
    double distance = _pointToSegmentDistance(center, p1, p2);

    // If the distance is less than or equal to the radius, the circle
    // intersects the polygon
    if (distance <= radius) return true;
  }

  return false;
}

/// Helper function to calculate the distance from a point to a line segment.
double _pointToSegmentDistance(Offset p, Offset a, Offset b) {
  if (a == b) return p.distanceTo(a); // a == b case

  final pa = p - a;
  final ba = b - a;
  final app = pa.scalarProduct(ba);
  double t = app / a.distanceSquaredTo(b);
  t = max(0, min(1, t)); // Clamping t to the range [0,1]

  // Find the projection point
  Offset projection = Offset(
    a.dx + t * ba.dx,
    a.dy + t * ba.dy,
  );

  // Return the distance from p to the projection
  return p.distanceTo(projection);
}
