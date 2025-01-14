import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphilia_board/src/core/extensions/extensions.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

const _kGridSpacing = 25.0;

class GridLayer<T> extends StatelessWidget {
  const GridLayer({
    super.key,
    required this.notifier,
    this.spacing = _kGridSpacing,
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
        return StaticGridLayer(
          originOffset: state.originOffset,
          scaleFactor: state.scaleFactor,
          spacing: spacing,
        );
      },
    );
  }
}

class StaticGridLayer extends StatelessWidget {
  const StaticGridLayer({
    this.originOffset = Offset.zero,
    this.scaleFactor = 1.0,
    this.spacing = _kGridSpacing,
    super.key,
  });

  final Offset originOffset;
  final double scaleFactor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(
        originOffset: originOffset,
        scaleFactor: scaleFactor,
        spacing: spacing,
      ),
    );
  }
}

/// A painter for drawing a grid.
class GridPainter extends CustomPainter {
  /// Creates a new [GridPainter] instance.
  GridPainter({
    required this.originOffset,
    required this.scaleFactor,
    this.spacing = _kGridSpacing,
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

    // Draw columns
    final gapX = (-originOffset.dx * scaleFactor) % gridSpacing;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x + gapX, 0),
        Offset(x + gapX, size.height),
        gridPaint,
      );
    }

    // Draw rows
    final gapY = (-originOffset.dy * scaleFactor) % gridSpacing;
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y + gapY),
        Offset(size.width, y + gapY),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}
