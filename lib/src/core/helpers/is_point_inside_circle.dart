import 'dart:ui';

bool isPointInCircle({
  required Offset point,
  required Offset circleCenter,
  required double radius,
}) {
  // Calculate the distance between the point and the circle center
  double distance = (point - circleCenter).distance;

  // Check if the distance is less than or equal to the radius
  return distance <= radius;
}
