import 'dart:ui';

import 'package:graphilia_board_core/graphilia_board_core.dart';

void drawDashedPath({
  required Canvas canvas,
  required List<Point> points,
  required double dashWidth,
  required double dashSpace,
  required Paint paint,
}) {
  if (points.length < 2) return; // No path to draw if less than 2 points

  double remainingLenght = dashWidth;
  bool drawingDash = true;

  Offset prevPoint = points.first;

  // TODO: Consider drawing the last point in some way (point.length - 1)
  for (int i = 0; i < points.length - 1; i++) {
    var currPoint = prevPoint;
    final p1 = Point.fromOffset(currPoint);
    final p2 = points[i + 1];

    // Calculate the distance between the current points
    double segmentLength = (p2 - p1).distance.abs();
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;

    double distanceCovered = 0;

    while (distanceCovered < segmentLength) {
      double distanceToDraw = remainingLenght;
      if (distanceCovered + distanceToDraw > segmentLength) {
        distanceToDraw = segmentLength - distanceCovered;
      }

      currPoint = prevPoint;

      final t = distanceToDraw / segmentLength;
      final currOffset = Offset(dx * t, dy * t);

      final nextPoint = Offset(
        currPoint.dx + currOffset.dx,
        currPoint.dy + currOffset.dy,
      );

      prevPoint = nextPoint;

      if (drawingDash) {
        canvas.drawLine(currPoint, nextPoint, paint);
      }

      distanceCovered += distanceToDraw;
      remainingLenght -= distanceToDraw;
      assert(remainingLenght >= 0, 'Remaining length cannot be negative');

      if (remainingLenght == 0) {
        drawingDash = !drawingDash;
        remainingLenght = drawingDash ? dashWidth : dashSpace;
      }
    }
  }
}
