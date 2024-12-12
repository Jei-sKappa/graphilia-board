import 'package:flutter/material.dart';

bool doCirclesIntersect({
  required Offset center1,
  required double radius1,
  required Offset center2,
  required double radius2,
}) {
  // Calculate the distance between the two circle centers
  double distance = (center1 - center2).distance;

  // Check if the circles intersect
  return distance < (radius1 + radius2) && distance > (radius1 - radius2).abs();
}
