import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterLineTool<T> extends SimpleDrawingTool<T> {
  HighlighterLineTool({
    required Color color,
    required super.width,
    super.shouldScale,
  }) : super(color: color.withOpacity(highlighterOpactity));

  @override
  HighlighterLine<T> createDrawing(Point firstPoint, T id, int zIndex, BoardState state) {
    return HighlighterLine(
      id: id,
      zIndex: zIndex,
      representation: LineRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }
}
