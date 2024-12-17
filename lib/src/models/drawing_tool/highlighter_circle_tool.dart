import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterCircleDrawingTool<T> extends SimpleCircleDrawingTool<T> {
  HighlighterCircleDrawingTool({
    required Color color,
    required super.width,
    super.shouldScale,
  }) : super(color: color.withOpacity(highlighterOpactity));

  @override
  HighlighterCircleDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return HighlighterCircleDrawing(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }
}
