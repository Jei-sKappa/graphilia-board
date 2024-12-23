import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class SimpleStraightLineTool<T> extends SimpleDrawingTool<T> {
  const SimpleStraightLineTool({
    required super.color,
    required super.width,
    super.shouldScale,
  });

  factory SimpleStraightLineTool.fromMap(Map<String, dynamic> map) {
    return SimpleStraightLineTool(
      color: Color(map['color']),
      width: map['width'],
      shouldScale: map['shouldScale'],
    );
  }

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'simple_straight_line_tool',
      'color': super.color.value,
      'width': super.width,
      'shouldScale': super.shouldScale,
    };
  }
}
