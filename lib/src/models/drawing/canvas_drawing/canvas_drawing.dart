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
    required bool isSelected,
  });

  /// This method is called when the [Drawing] is being created for the first time.
  ///
  /// See [DrawInteraction] and [InteractionFeedbackLayer] for more information.
  void drawFeedback(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas,
  ) =>
      draw(state, canvas, isSelected: false);
}
