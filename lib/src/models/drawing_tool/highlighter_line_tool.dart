import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterLineTool<T> extends SimpleDrawingTool<T> {
  HighlighterLineTool({
    required Color color,
    required super.width,
    super.shouldScale,
    this.simulatePressure = false,
  }) : super(color: color.withOpacity(highlighterOpactity));

  final bool simulatePressure;

  @override
  HighlighterLine<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return HighlighterLine(
      id: id,
      zIndex: zIndex,
      representation: LineRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
      simulatePressure: simulatePressure,
    );
  }
}
