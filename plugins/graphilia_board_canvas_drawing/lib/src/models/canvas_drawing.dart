import 'dart:ui';

import 'package:graphilia_board_core/graphilia_board_core.dart';

abstract class CanvasDrawing<T> extends Drawing<T> {
  const CanvasDrawing({
    required super.id,
    required super.zIndex,
  });

  void draw(
    BoardState<T> state,
    Canvas canvas,
  );

  /// This method is called when the [Drawing] is being created for the first time.
  ///
  /// See [DrawInteraction] and [InteractionFeedbackLayer] for more information.
  void drawFeedback(
    BoardState<T> state,
    Canvas canvas,
  ) =>
      draw(state, canvas);
}
