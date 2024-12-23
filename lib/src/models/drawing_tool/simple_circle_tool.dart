import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class SimpleCircleDrawingTool<T> extends SimpleDrawingTool<T> {
  const SimpleCircleDrawingTool({
    required super.color,
    required super.width,
    super.shouldScale,
  });

  factory SimpleCircleDrawingTool.fromMap(Map<String, dynamic> map) {
    return SimpleCircleDrawingTool(
      color: Color(map['color']),
      width: map['width'],
      shouldScale: map['shouldScale'],
    );
  }

  @override
  SimpleCircleDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return SimpleCircleDrawing(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }

  @override
  SimpleCircleDrawingTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
  }) {
    return SimpleCircleDrawingTool(
      color: color ?? super.color,
      width: width ?? super.width,
      shouldScale: shouldScale ?? super.shouldScale,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'simple_circle_tool',
      'color': super.color.value,
      'width': super.width,
      'shouldScale': super.shouldScale,
    };
  }
}
