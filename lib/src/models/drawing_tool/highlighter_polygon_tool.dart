import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterPolygonDrawingTool<T> extends SimplePolygonDrawingTool<T> {
  HighlighterPolygonDrawingTool({
    required Color color,
    required super.width,
    super.shouldScale,
    required super.polygonTemplate,
  }) : super(color: color.withOpacity(highlighterOpactity));

  factory HighlighterPolygonDrawingTool.fromMap(Map<String, dynamic> map) {
    return HighlighterPolygonDrawingTool(
      color: Color(map['color']),
      width: map['width'],
      shouldScale: map['shouldScale'],
      polygonTemplate: PolygonTemplate.fromJson(map['polygonTemplate']),
    );
  }

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

    @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'highlighter_polygon_tool',
      'color': color.value,
      'width': width,
      'shouldScale': shouldScale,
      'polygonTemplate': polygonTemplate.toJson(),
    };
  }
}
