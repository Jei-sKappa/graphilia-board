import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class SimpleStraightLineTool<T> extends SimpleDrawingTool<T> {
  const SimpleStraightLineTool({
    required super.color,
    required super.width,
    super.shouldScale,
  });

  @override
  SimpleStraightLine<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return SimpleStraightLine(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }

  @override
  SimpleStraightLineTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
  }) {
    return SimpleStraightLineTool(
      color: color ?? super.color,
      width: width ?? super.width,
      shouldScale: shouldScale ?? super.shouldScale,
    );
  }
}
