import 'package:flutter/material.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class CanvasDrawingsLayer extends StatelessWidget {
  const CanvasDrawingsLayer({
    super.key,
    required this.drawings,
    required this.state,
    required this.areDrawingsSelected,
    required this.simulatePressure,
  });

  final List<CanvasDrawing> drawings;
  final BoardState state;
  final bool areDrawingsSelected;
  final bool simulatePressure;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CanvasDrawingPainter(
        drawings: drawings,
        state: state,
        simulatePressure: simulatePressure,
        areDrawingsSelected: areDrawingsSelected,
      ),
    );
  }
}

/// A painter for drawing a sketch.
class CanvasDrawingPainter extends CustomPainter {
  /// Creates a new [CanvasDrawingPainter] instance.
  CanvasDrawingPainter({
    required this.drawings,
    required this.state,
    required this.simulatePressure,
    required this.areDrawingsSelected,
  });

  final List<CanvasDrawing> drawings;
  final BoardState state;
  final bool simulatePressure;
  final bool areDrawingsSelected;

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawing in drawings) {
      drawing.draw(
        state,
        canvas,
        simulatePressure: simulatePressure,
        isSelected: areDrawingsSelected,
      );
    }
  }

  @override
  bool shouldRepaint(CanvasDrawingPainter oldDelegate) => true;
}
