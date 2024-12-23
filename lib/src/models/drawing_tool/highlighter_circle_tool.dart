import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterCircleDrawingTool<T> extends SimpleCircleDrawingTool<T> {
  HighlighterCircleDrawingTool({
    required Color color,
    required super.width,
    super.shouldScale,
  }) : super(color: color.withOpacity(highlighterOpactity));

  factory HighlighterCircleDrawingTool.fromMap(Map<String, dynamic> map) {
    return HighlighterCircleDrawingTool(
      color: Color(map['color']),
      width: map['width'],
      shouldScale: map['shouldScale'],
    );
  }

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'highlighter_circle_tool',
      'color': color.value,
      'width': width,
      'shouldScale': shouldScale,
    };
  }
}
