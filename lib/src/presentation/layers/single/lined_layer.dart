import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphilia_board/src/core/extensions/extensions.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

class LinedLayer<T> extends StatelessWidget {
  const LinedLayer({
    super.key,
    required this.notifier,
    this.spacing = 25,
  });

  final BoardNotifier<T, BoardStateConfig> notifier;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BoardState>(
      // Rebuild [GridPainter] only when the [originOffset] or [scaleFactor]
      // changes.
      valueListenable: notifier.where(
        (previous, next) {
          final isOriginaOffsetChanged = next.originOffset != previous.originOffset;
          if (isOriginaOffsetChanged) return true;

          final isScaleFactorChanged = next.scaleFactor != previous.scaleFactor;
          if (isScaleFactorChanged) return true;

          return false;
        },
      ),
      builder: (context, state, _) {
        return CustomPaint(
          painter: LinedPainter(
            originOffset: state.originOffset,
            scaleFactor: state.scaleFactor,
            spacing: spacing,
          ),
        );
      },
    );
  }
}

/// A painter for drawing a grid.
class LinedPainter extends CustomPainter {
  /// Creates a new [LinedPainter] instance.
  LinedPainter({
    required this.originOffset,
    required this.scaleFactor,
    required this.spacing,
  });

  final Offset originOffset;

  /// {@macro view.state.graphilia_board_state.scale_factor}
  final double scaleFactor;

  final double spacing;

  // Calculate current grid spacing based on scaleFactor
  double calculateGridSpacing(double scaleFactor) {
    // Determine the current grid level (power of 2): log base 2 of scaleFactor
    // TODO: When the gridLevel reaches 512 the Transform widget throws a Nan error. This can only be fixed by implementing a layered scaling system.
    final gridLevel = (scaleFactor.log2()).floor();

    // Halve the base spacing based on grid level
    return spacing / pow(2, gridLevel);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw square grid background
    final gridPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 1.0
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    // Calculate grid spacing based on scaleFactor
    // Get the grid spacing based on the current scale factor
    final gridSpacing = calculateGridSpacing(scaleFactor) * scaleFactor;

    // Draw rows
    final gapY = (-originOffset.dy * scaleFactor) % gridSpacing;
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y + gapY),
        Offset(size.width, y + gapY),
        gridPaint,
      );
    }

    // Draw a circle on the origin point.
    canvas.drawCircle(
      -originOffset * scaleFactor,
      4.0,
      Paint()
        ..color = Colors.blueGrey.shade600
        ..strokeWidth = 1.0
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(LinedPainter oldDelegate) => true;
}
