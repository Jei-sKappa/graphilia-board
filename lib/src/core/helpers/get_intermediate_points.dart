import 'dart:math';

import 'package:graphilia_board/src/models/point/point.dart';

List<Point> getIntermediatePoints(
  Point p1,
  Point p2, {
  int count = 1,
  double minDistance = 1,
}) {
  assert(count > 0, 'The count must be greater than 0');

  // Determine how many points can fit based on the minDistance
  int maxPointsBasedOnDistance = (p1.distanceTo(p2) / minDistance).floor() - 1;

  // Determine the actual number of points to generate, limited by count
  int pointsToGenerate = min(count, maxPointsBasedOnDistance);

  // Calculate step size for x and y based on the pointsToGenerate
  double stepX = (p2.x - p1.x) / (pointsToGenerate + 1);
  double stepY = (p2.y - p1.y) / (pointsToGenerate + 1);

  // Generate the intermediate points
  List<Point> points = [];
  for (int i = 1; i <= pointsToGenerate; i++) {
    double newX = p1.x + stepX * i;
    double newY = p1.y + stepY * i;
    points.add(Point(newX, newY));
  }

  return points;
}
