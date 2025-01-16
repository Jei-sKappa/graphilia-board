import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';

class AnchoredDrawingRepresentation extends MultiPointDrawingRepresentation with EquatableMixin {
  const AnchoredDrawingRepresentation({
    required this.anchorPoint,
    required this.endPoint,
  });

  factory AnchoredDrawingRepresentation.fromMap(Map<String, dynamic> map) {
    return AnchoredDrawingRepresentation(
      anchorPoint: Point.fromMap(map['anchorPoint']),
      endPoint: Point.fromMap(map['endPoint']),
    );
  }

  @override
  List<Object?> get props => [anchorPoint, endPoint];

  const AnchoredDrawingRepresentation.initial(Point point)
      : anchorPoint = point,
        endPoint = point;

  AnchoredDrawingRepresentation.fromSize({
    required this.anchorPoint,
    required Size size,
  }) : endPoint = anchorPoint + size.bottomRight(Offset.zero);

  final Point anchorPoint;
  final Point endPoint;

  @override
  AnchoredDrawingRepresentation setFirstPoint(BoardState state, Point point) => copyWith(anchorPoint: point);

  @override
  AnchoredDrawingRepresentation setNewPoint(BoardState state, Point point) => copyWith(endPoint: point);

  @override
  AnchoredDrawingRepresentation move(BoardState state, Point offset) => copyWith(
        anchorPoint: anchorPoint + offset,
        endPoint: endPoint + offset,
      );

  @override
  AnchoredDrawingRepresentation resize(
    BoardState state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) {
    final resizedPoints = resizePoints(
      [anchorPoint, endPoint],
      resizeRect,
      anchor,
      delta,
    );

    return copyWith(
      anchorPoint: resizedPoints[0],
      endPoint: resizedPoints[1],
    );
  }

  @override
  bool isInitializedOnlyOnePoint() => anchorPoint == endPoint;

  @override
  Point getSinglePoint() => anchorPoint;

  @override
  bool isPointDistanceEnoughFromLastPoint(
    BoardState state,
    Point newPoint,
  ) =>
      isDistanceFromTwoPointsEnough(
        endPoint,
        newPoint,
        kDefaultPointDistance,
        state.scaleFactor,
      );

  AnchoredDrawingRepresentation copyWith({
    Point? anchorPoint,
    Point? endPoint,
  }) =>
      AnchoredDrawingRepresentation(
        anchorPoint: anchorPoint ?? this.anchorPoint,
        endPoint: endPoint ?? this.endPoint,
      );

  @override
  Map<String, dynamic> toMap() => {
        'type': 'anchored_drawing_representation',
        'anchorPoint': anchorPoint.toMap(),
        'endPoint': endPoint.toMap(),
      };
}
