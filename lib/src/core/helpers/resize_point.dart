import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

({Offset resizeAnchorPoint, bool canUpdateX, bool canUpdateY, double totalDistanceX, double totalDistanceY}) _getParams(
  Rect resizeRect,
  ResizeAnchor anchor,
) {
  final resizeAnchorPoint = resizeRect.getAnchorPoint(anchor);
  final resizeOppositeAnchorPoint = resizeRect.getAnchorPoint(anchor.opposite);

  final canUpdateX = anchor != ResizeAnchor.topCenter && anchor != ResizeAnchor.bottomCenter;
  final canUpdateY = anchor != ResizeAnchor.centerLeft && anchor != ResizeAnchor.centerRight;

  // Calculate the total distance between the resize anchor points
  final totalDistanceX = resizeOppositeAnchorPoint.dx - resizeAnchorPoint.dx;
  final totalDistanceY = resizeOppositeAnchorPoint.dy - resizeAnchorPoint.dy;

  return (
    resizeAnchorPoint: resizeAnchorPoint,
    canUpdateX: canUpdateX,
    canUpdateY: canUpdateY,
    totalDistanceX: totalDistanceX,
    totalDistanceY: totalDistanceY,
  );
}

Point resizePoint(
  Point point,
  Rect resizeRect,
  ResizeAnchor anchor,
  Offset delta,
) {
  final (:resizeAnchorPoint, :canUpdateX, :canUpdateY, :totalDistanceX, :totalDistanceY) = _getParams(resizeRect, anchor);

  var newX = point.dx;
  var newY = point.dy;

  if (canUpdateX) {
    final distanceX = point.dx - resizeAnchorPoint.dx;

    // Normalize the distance
    final normX = ((totalDistanceX - distanceX) / totalDistanceX);

    newX = point.dx + normX * delta.dx;
  }

  if (canUpdateY) {
    final distanceY = point.dy - resizeAnchorPoint.dy;

    final normY = ((totalDistanceY - distanceY) / totalDistanceY);

    newY = point.dy + normY * delta.dy;
  }

  return point.copyWith(x: newX, y: newY);
}

List<Point> resizePoints(
  List<Point> points,
  Rect resizeRect,
  ResizeAnchor anchor,
  Offset delta,
) {
  final (:resizeAnchorPoint, :canUpdateX, :canUpdateY, :totalDistanceX, :totalDistanceY) = _getParams(resizeRect, anchor);

  final updatedPoints = points.map((p) {
    var newX = p.dx;
    var newY = p.dy;

    if (canUpdateX) {
      final distanceX = p.dx - resizeAnchorPoint.dx;

      // Normalize the distance
      final normX = ((totalDistanceX - distanceX) / totalDistanceX);

      newX = p.dx + normX * delta.dx;
    }

    if (canUpdateY) {
      final distanceY = p.dy - resizeAnchorPoint.dy;

      final normY = ((totalDistanceY - distanceY) / totalDistanceY);

      newY = p.dy + normY * delta.dy;
    }

    return p.copyWith(x: newX, y: newY);
  }).toList();

  return updatedPoints;
}
