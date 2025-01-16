import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin RepresentableDrawingMixin<T> on Drawing<T> {
  DrawingRepresentation get representation;

  @override
  Drawing<T>? update(
    BoardState<T> state,
    Point newPoint,
  ) {
    final shouldUpdate = representation.isPointDistanceEnoughFromLastPoint(
      state,
      newPoint,
    );
    if (!shouldUpdate) return null;

    final r = representation.setNewPoint(state, newPoint);

    return copyWith(representation: r);
  }

  @override
  Drawing<T> move(BoardState<T> state, Point offset) => copyWith(
        representation: representation.move(state, offset),
      );

  @override
  Drawing<T> resize(
    BoardState<T> state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) =>
      copyWith(
        representation: representation.resize(state, resizeRect, anchor, delta),
      );

  @override
  RepresentableDrawingMixin<T> copyWith({
    T? id,
    int? zIndex,
    covariant DrawingRepresentation? representation,
  });
}
