import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin RepresentableDrawingMixin<T> on Drawing<T> {
  DrawingRepresentation get representation;

  Drawing<T> updateRepresentation(covariant DrawingRepresentation value);

  @override
  Drawing<T>? update(
    BoardState<T, BoardStateConfig> state,
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
  Drawing<T> move(BoardState<T, BoardStateConfig> state, Point offset) => updateRepresentation(
        representation.move(state, offset),
      );

  @override
  Drawing<T> resize(
    BoardState<T, BoardStateConfig> state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  ) =>
      updateRepresentation(
        representation.resize(state, resizeRect, anchor, delta),
      );
}
