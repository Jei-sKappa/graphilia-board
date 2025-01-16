import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';

class PlaceholderRectRepresentation extends AnchoredDrawingRepresentation with EquatableMixin {
  const PlaceholderRectRepresentation({
    required super.anchorPoint,
    required super.endPoint,
  });

  factory PlaceholderRectRepresentation.fromMap(Map<String, dynamic> map) {
    return PlaceholderRectRepresentation(
      anchorPoint: Point.fromMap(map['anchorPoint']),
      endPoint: Point.fromMap(map['endPoint']),
    );
  }

  const PlaceholderRectRepresentation.initial(super.point) : super.initial();

  PlaceholderRectRepresentation.fromSize({
    required super.anchorPoint,
    required super.size,
  }) : super.fromSize();

  @override
  List<Object?> get props => [super.props];

  @override
  PlaceholderRectRepresentation setFirstPoint(BoardState state, Point point) => copyWith(anchorPoint: point);

  @override
  PlaceholderRectRepresentation setNewPoint(BoardState state, Point point) => copyWith(endPoint: point);

  @override
  PlaceholderRectRepresentation move(BoardState state, Point offset) => copyWith(
        anchorPoint: anchorPoint + offset,
        endPoint: endPoint + offset,
      );

  @override
  PlaceholderRectRepresentation resize(
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
  PlaceholderRectRepresentation copyWith({
    Point? anchorPoint,
    Point? endPoint,
  }) =>
      PlaceholderRectRepresentation(
        anchorPoint: anchorPoint ?? this.anchorPoint,
        endPoint: endPoint ?? this.endPoint,
      );

  @override
  Map<String, dynamic> toMap() => {
        'anchorPoint': anchorPoint.toMap(),
        'endPoint': endPoint.toMap(),
      };
}
