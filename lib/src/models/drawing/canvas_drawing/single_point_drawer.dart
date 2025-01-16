import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:graphilia_board/src/models/drawing/drawing.dart';
import 'package:graphilia_board/src/models/point/point.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin SinglePointDrawer<T> on CanvasDrawing<T> {
  bool shouldDrawSinglePoint();

  Point getSinglePoint();

  void drawSinglePoint(BoardState<T> state, Canvas canvas, Point point);

  void drawMultiplePoints(
    BoardState<T> state,
    Canvas canvas, {
    required bool isSelected,
  });

  @nonVirtual
  @override
  void draw(
    BoardState<T> state,
    Canvas canvas, {
    required bool isSelected,
  }) {
    if (shouldDrawSinglePoint()) {
      drawSinglePoint(
        state,
        canvas,
        getSinglePoint(),
      );
    } else {
      drawMultiplePoints(
        state,
        canvas,
        isSelected: isSelected,
      );
    }
  }
}
