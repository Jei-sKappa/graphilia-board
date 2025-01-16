import 'package:flutter/material.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class CanvasDrawingsLayer<T> extends StatelessWidget {
  const CanvasDrawingsLayer({
    super.key,
    required this.drawings,
    required this.state,
    required this.areDrawingsSelected,
  });

  final List<CanvasDrawing<T>> drawings;
  final BoardState<T> state;
  final bool areDrawingsSelected;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CanvasDrawingPainter(
        drawings: drawings,
        state: state,
        areDrawingsSelected: areDrawingsSelected,
      ),
    );
  }
}

/// A painter for drawing a sketch.
class CanvasDrawingPainter<T> extends CustomPainter {
  /// Creates a new [CanvasDrawingPainter] instance.
  CanvasDrawingPainter({
    required this.drawings,
    required this.state,
    required this.areDrawingsSelected,
  });

  final List<CanvasDrawing<T>> drawings;
  final BoardState<T> state;
  final bool areDrawingsSelected;

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawing in drawings) {
      drawing.draw(
        state,
        canvas,
        isSelected: areDrawingsSelected,
      );
    }
  }

  @override
  bool shouldRepaint(CanvasDrawingPainter oldDelegate) => true;
}
