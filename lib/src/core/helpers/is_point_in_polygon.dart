import 'dart:math';
import 'dart:ui';

import 'package:graphilia_board/src/models/point/points_in_polygon_mode.dart';

/// Determines if a point is inside a polygon using the ray-casting algorithm.
bool isPointInPolygon(Offset point, List<Offset> polygon) {
  bool isInside = false;
  for (int i = 0; i < polygon.length; i++) {
    Offset p1 = polygon[i];
    Offset p2 = polygon[(i + 1) % polygon.length];

    // Check if the point is above or below the p1-p2 segment, if so the point
    // cannot intersect the segment so we can skip this iteration
    if ((point.dy > p1.dy) == (point.dy > p2.dy)) continue;

    // Calculate the x coordinate of the intersection
    double xIntersection = (point.dy - p1.dy) * (p2.dx - p1.dx) / (p2.dy - p1.dy) + p1.dx;
    if (xIntersection > point.dx) {
      isInside = !isInside;
    }
  }

  return isInside;
}

bool isAnyPointInPolygon(List<Offset> points, List<Offset> polygonVertices) {
  for (final point in points) {
    final isInside = isPointInPolygon(
      point,
      polygonVertices,
    );
    if (isInside) return true;
  }

  return false;
}

bool areAllPointsInPolygon(List<Offset> points, List<Offset> polygonVertices) {
  for (final point in points) {
    final isInside = isPointInPolygon(
      point,
      polygonVertices,
    );
    if (!isInside) return false;
  }

  return true;
}

bool onSegment(Offset p, Offset q, Offset r) {
  if (q.dx <= max(p.dx, r.dx) && q.dx >= min(p.dx, r.dx) && q.dy <= max(p.dy, r.dy) && q.dy >= min(p.dy, r.dy)) {
    return true;
  }
  return false;
}

int orientation(Offset p, Offset q, Offset r) {
  double val = (q.dy - p.dy) * (r.dx - q.dx) - (q.dx - p.dx) * (r.dy - q.dy);
  if (val == 0) return 0; // collinear
  return (val > 0) ? 1 : 2; // clock or counterclock wise
}

bool doIntersect(Offset p1, Offset q1, Offset p2, Offset q2) {
  // Find the four orientations needed for general and special cases
  int o1 = orientation(p1, q1, p2);
  int o2 = orientation(p1, q1, q2);
  int o3 = orientation(p2, q2, p1);
  int o4 = orientation(p2, q2, q1);

  // General case
  if (o1 != o2 && o3 != o4) return true;

  // Special Cases
  // p1, q1 and p2 are collinear and p2 lies on segment p1q1
  if (o1 == 0 && onSegment(p1, p2, q1)) return true;

  // p1, q1 and q2 are collinear and q2 lies on segment p1q1
  if (o2 == 0 && onSegment(p1, q2, q1)) return true;

  // p2, q2 and p1 are collinear and p1 lies on segment p2q2
  if (o3 == 0 && onSegment(p2, p1, q2)) return true;

  // p2, q2 and q1 are collinear and q1 lies on segment p2q2
  if (o4 == 0 && onSegment(p2, q1, q2)) return true;

  return false; // Doesn't fall in any of the above cases
}

bool doesPolygonsIntersect(List<Offset> polygon1, List<Offset> polygon2) {
  for (int i = 0; i < polygon1.length; i++) {
    Offset p1 = polygon1[i];
    Offset p2 = polygon1[(i + 1) % polygon1.length];

    for (int j = 0; j < polygon2.length; j++) {
      Offset q1 = polygon2[j];
      Offset q2 = polygon2[(j + 1) % polygon2.length];

      if (doIntersect(p1, p2, q1, q2)) return true;
    }
  }

  return false;
}

/// Determines if a polygon is inside another polygon.
///
/// The [strict] parameter determines if the polygon is strictly inside the
/// other polygon. If false it will also return true if the other polygon
/// ([otherVertices]) is inside the polygon ([polygonVertices]).
bool isPolygonInsideOther(
  List<Offset> polygonVertices,
  List<Offset> otherVertices,
  PointsInPolygonMode mode, {
  // TODO: Default it to true and update the code in all the callers. Also make it a customizable parameter in a config
  bool strict = false,
}) {
  switch (mode) {
    case PointsInPolygonMode.total:
      // If all polygon's vertices are inside the polygon, then the polygon is
      // inside the other polygon
      // If false, then the polygon is not inside the other polygon
      return areAllPointsInPolygon(polygonVertices, otherVertices);
    case PointsInPolygonMode.partial:
      // If any of the polygon's vertices are inside the polygon, then the
      // polygon is inside the other polygon
      // If false, we must check the intersection of the edges of the polygon
      // with the other polygon
      if (isAnyPointInPolygon(polygonVertices, otherVertices)) return true;

      // Check if any of the edges of the polygon intersect with the other
      // polygon
      if (doesPolygonsIntersect(polygonVertices, otherVertices)) return true;

      // If the polygon is not strictly inside the other polygon, and the strict
      // parameter is true we must return false
      if (strict) return false;

      // If any of the other polygon's vertices are inside the polygon, then the
      // other polygon is inside the polygon
      // If false, we must check the intersection of the edges of the other
      // polygon with the polygon
      if (isAnyPointInPolygon(otherVertices, polygonVertices)) return true;

      // Check if any of the edges of the other polygon intersect with the
      // polygon
      if (doesPolygonsIntersect(otherVertices, polygonVertices)) return true;

      return false;
  }
}
