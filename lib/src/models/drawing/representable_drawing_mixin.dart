import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin RepresentableDrawingMixin<T> on Drawing<T> {
  DrawingRepresentation get representation;

  Drawing updateRepresentation(covariant DrawingRepresentation value);

  @override
  Drawing? update(
    BoardState state,
    Point newPoint,
  ) {
    final shouldUpdate = representation.isPointDistanceEnoughFromLastPoint(
      state,
      newPoint,
    );
    if (!shouldUpdate) return null;

    final r = representation.setNewPoint(state, newPoint);
    return updateRepresentation(r);
  }

  @override
  Drawing move(BoardState state, Point offset) => updateRepresentation(
        representation.move(state, offset),
      );

  @override
  Drawing resize(
    BoardState state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) =>
      updateRepresentation(
        representation.resize(state, resizeRect, anchor, delta),
      );
}
