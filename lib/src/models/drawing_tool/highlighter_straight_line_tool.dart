import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterStraightLineTool<T> extends SimpleStraightLineTool<T> {
  HighlighterStraightLineTool({
    required Color color,
    required super.width,
    super.shouldScale,
  }) : super(color: color.withOpacity(highlighterOpactity));

  @override
  HighlighterStraightLine<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return HighlighterStraightLine(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }

  @override
  HighlighterStraightLineTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
  }) {
    return HighlighterStraightLineTool(
      color: color ?? this.color,
      width: width ?? this.width,
      shouldScale: shouldScale ?? this.shouldScale,
    );
  }
}
