import 'package:flutter/painting.dart';
import 'package:equatable/equatable.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:graphilia_board/src/core/core.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class FunctionGraphDrawingTool<T> extends DrawingTool<T> with EquatableMixin {
  const FunctionGraphDrawingTool({
    required this.expression,
    this.shouldScale = true,
  });

  factory FunctionGraphDrawingTool.fromMap(Map<String, dynamic> map) {
    return FunctionGraphDrawingTool(
      expression: Parser().parse(map['expression']),
      shouldScale: map['shouldScale'],
    );
  }

  final Expression expression;

  /// Whether the drawing should be scaled based on the zoom level.
  final bool shouldScale;

  static const typeKey = 'function_graph_tool';

  @override
  List<Object?> get props => [expression, shouldScale];

  @override
  void drawPreview(
    Canvas canvas,
    Point point,
    BoardState<T> state,
  ) {
    drawPoint(
      canvas,
      point,
      5 / state.scaleFactor,
      Paint()..color = const Color(0xFFFF0000),
    );

    canvas.drawText(
      expression.toString(),
      style: TextStyle(
        color: const Color(0xFFFFFFFF),
        fontSize: 20 / state.scaleFactor,
      ),
      maxWidth: expression.toString().length * 14,
      offset: point.translate(
        7 / state.scaleFactor,
        7 / state.scaleFactor,
      ),
    );
  }

  @override
  FunctionGraphDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T> state,
  ) =>
      FunctionGraphDrawing(
        id: id,
        zIndex: zIndex,
        representation: AnchoredDrawingRepresentation.initial(firstPoint),
        expression: expression,
      );

  @override
  FunctionGraphDrawingTool<T> copyWith({
    Expression? expression,
    bool? shouldScale,
  }) =>
      FunctionGraphDrawingTool(
        expression: expression ?? this.expression,
        shouldScale: shouldScale ?? this.shouldScale,
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': typeKey,
      'expression': expression.toString(),
      'shouldScale': shouldScale,
    };
  }
}
