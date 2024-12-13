import 'dart:ui';

import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:meta/meta.dart';
import 'package:graphilia_board/src/models/drawing/drawing.dart';
import 'package:graphilia_board/src/models/point/point.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

mixin SinglePointDrawer<T> on CanvasDrawing<T> {
  bool shouldDrawSinglePoint();

  Point getSinglePoint();

  void drawSinglePoint(BoardState<T, BoardStateConfig> state, Canvas canvas, Point point);

  void drawMultiplePoints(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas, {
    required bool simulatePressure,
    required bool isSelected,
  });

  @nonVirtual
  @override
  void draw(
    BoardState<T, BoardStateConfig> state,
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
