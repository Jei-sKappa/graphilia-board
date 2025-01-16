import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class HighlighterLineTool<T> extends SimpleLineTool<T> {
  HighlighterLineTool({
    required Color color,
    required super.width,
    super.shouldScale,
    super.simulatePressure,
  }) : super(color: color.withOpacity(highlighterOpactity));

  factory HighlighterLineTool.fromMap(Map<String, dynamic> map) {
    return HighlighterLineTool(
      color: Color(map['color']),
      width: map['width'],
      shouldScale: map['shouldScale'],
      simulatePressure: map['simulatePressure'],
    );
  }

  static const typeKey = 'highlighter_line_tool';

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

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': typeKey,
      'color': color.value,
      'width': width,
      'shouldScale': shouldScale,
      'simulatePressure': simulatePressure,
    };
  }
}
