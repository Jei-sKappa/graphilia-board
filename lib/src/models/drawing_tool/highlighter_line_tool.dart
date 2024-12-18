import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterLineTool<T> extends SimpleLineTool<T> {
  HighlighterLineTool({
    required Color color,
    required super.width,
    super.shouldScale,
    super.simulatePressure,
  }) : super(color: color.withOpacity(highlighterOpactity));

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

  @override
  HighlighterLineTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
    bool? simulatePressure,
  }) {
    return HighlighterLineTool(
      color: color ?? this.color,
      width: width ?? this.width,
      shouldScale: shouldScale ?? this.shouldScale,
      simulatePressure: simulatePressure ?? this.simulatePressure,
    );
  }
}
