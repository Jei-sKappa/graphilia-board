import 'dart:ui';

Rect getPointListBounds(List<Offset> points) {
  if (points.isEmpty) {
    return Rect.zero;
  }

  double minX = points[0].dx;
  double minY = points[0].dy;
  double maxX = points[0].dx;
  double maxY = points[0].dy;

  for (var point in points) {
    if (point.dx < minX) {
      minX = point.dx;
    }
    if (point.dy < minY) {
      minY = point.dy;
    }
    if (point.dx > maxX) {
      maxX = point.dx;
    }
    if (point.dy > maxY) {
      maxY = point.dy;
    }
  }

  Offset topLeft = Offset(minX, minY);
  Offset bottomRight = Offset(maxX, maxY);

  return Rect.fromPoints(topLeft, bottomRight);
}
