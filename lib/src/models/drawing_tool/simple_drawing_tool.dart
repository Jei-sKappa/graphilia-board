import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/core/helpers/draw_point.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

abstract class SimpleDrawingTool<T> extends DrawingTool<T> with EquatableMixin {
  const SimpleDrawingTool({
    required this.color,
    required this.width,
    this.shouldScale = true,
  });

  final Color color;

  final double width;

  /// Whether the drawing should be scaled based on the zoom level.
  final bool shouldScale;

  @override
  List<Object?> get props => [color, width, shouldScale];

  @override
  void drawPreview(
    Canvas canvas,
    Point point,
    BoardState<T, BoardStateConfig> state,
  ) {
    drawPoint(
      canvas,
      point,
      getScaledWidthIfNecessary(state),
      SimpleDrawing.createSimplePaint(color),
    );
  }
}

extension CalculateScaledWidthIfNecessary<T> on SimpleDrawingTool<T> {
  double getScaledWidthIfNecessary(BoardState<T, BoardStateConfig> state) => shouldScale ? width / state.scaleFactor : width;
}
