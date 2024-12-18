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

  @override
  HighlighterCircleDrawingTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
  }) {
    return HighlighterCircleDrawingTool(
      color: color ?? this.color,
      width: width ?? this.width,
      shouldScale: shouldScale ?? this.shouldScale,
    );
  }
}
