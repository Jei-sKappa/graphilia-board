import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:graphilia_board/src/models/drawing/drawing.dart';
import 'package:graphilia_board/src/models/point/point.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin SinglePointDrawer<T> on CanvasDrawing<T> {
  bool shouldDrawSinglePoint();

  Point getSinglePoint();

  void drawSinglePoint(BoardState state, Canvas canvas, Point point);

  void drawMultiplePoints(
    BoardState state,
    Canvas canvas, {
    required bool simulatePressure,
    required bool isSelected,
  });

  @nonVirtual
  @override
  void draw(
    BoardState state,
    Canvas canvas, {
    required bool simulatePressure,
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
        simulatePressure: simulatePressure,
        isSelected: isSelected,
      );
    }
  }
}
