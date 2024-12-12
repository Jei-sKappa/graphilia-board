import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

export 'base_drawings/base_drawings.dart';
export 'representable_canvas_drawing.dart';
export 'single_point_drawer.dart';

abstract class CanvasDrawing<T> extends Drawing<T> {
  const CanvasDrawing({
    required super.id,
    required super.zIndex,
  });

  void draw(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas, {
    // TODO: simulatePressure should be a property of only the classes that require it.
    // for example a shape doesn't need to simulate pressure.
    required bool simulatePressure,
    required bool isSelected,
  });
}
