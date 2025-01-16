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

  static const typeKey = 'simple_circle_tool';

  @override
  SimpleCircleDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T> state,
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
      'type': typeKey,
      'color': super.color.value,
      'width': super.width,
      'shouldScale': super.shouldScale,
    };
  }
}
