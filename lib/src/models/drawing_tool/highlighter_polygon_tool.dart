import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterPolygonDrawingTool<T> extends SimplePolygonDrawingTool<T> {
  HighlighterPolygonDrawingTool({
    required Color color,
    required super.width,
    super.shouldScale,
    required super.polygonTemplate,
  }) : super(color: color.withOpacity(highlighterOpactity));

  @override
  HighlighterPolygonDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return HighlighterPolygonDrawing(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
      polygonTemplate: polygonTemplate,
    );
  }

  @override
  HighlighterPolygonDrawingTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
    PolygonTemplate? polygonTemplate,
  }) {
    return HighlighterPolygonDrawingTool(
      color: color ?? this.color,
      width: width ?? this.width,
      shouldScale: shouldScale ?? this.shouldScale,
      polygonTemplate: polygonTemplate ?? this.polygonTemplate,
    );
  }
}
