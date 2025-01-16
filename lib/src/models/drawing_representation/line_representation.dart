import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

import 'package:equatable/equatable.dart';

class LineRepresentation extends MultiPointDrawingRepresentation with EquatableMixin {
  const LineRepresentation({
    required this.points,
  });

  factory LineRepresentation.fromMap(Map<String, dynamic> map) {
    return LineRepresentation(
      points: (map['points'] as List).map((p) => Point.fromMap(p)).toList(),
    );
  }

  LineRepresentation.empty() : points = [];

  LineRepresentation.initial(Point point) : points = [point];

  final List<Point> points;

  static const mapKey = 'line_representation';

  @override
  List<Object?> get props => [points];

  @override
  LineRepresentation setFirstPoint(BoardState state, Point point) => copyWith(points: [point]);

  @override
  LineRepresentation setNewPoint(BoardState state, Point point) => copyWith(points: [...points, point]);

  @override
  LineRepresentation move(BoardState state, Point offset) => copyWith(points: points.map((p) => p + offset).toList());

  @override
  LineRepresentation resize(
    BoardState state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) =>
      copyWith(
        points: resizePoints(points, resizeRect, anchor, delta),
      );

  @override
  bool isInitializedOnlyOnePoint() => points.length == 1;

  @override
  Point getSinglePoint() => points.first;

  @override
  bool isPointDistanceEnoughFromLastPoint(BoardState state, Point newPoint) {
    if (points.isEmpty) {
      return true;
    }

    return isDistanceFromTwoPointsEnough(
      newPoint,
      points.last,
      kDefaultPointDistance,
      state.scaleFactor,
    );
  }

  LineRepresentation copyWith({
    List<Point>? points,
  }) {
    return LineRepresentation(
      points: points ?? this.points,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': mapKey,
      'points': points.map((p) => p.toMap()).toList(),
    };
  }
}
