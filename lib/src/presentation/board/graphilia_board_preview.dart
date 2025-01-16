import 'package:flutter/material.dart';
import 'package:graphilia_board/graphilia_board.dart';

class GraphiliaBoardPreview<T> extends StatelessWidget {
  const GraphiliaBoardPreview({
    required this.sketch,
    this.viewPortSize,
    this.originOffset = Offset.zero,
    this.scaleFactor = 1.0,
    super.key,
  });

  final Sketch<T> sketch;
  final Size? viewPortSize;
  final Offset originOffset;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewPortSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return GraphiliaBoardDetails(
            boardSize: viewPortSize,
            child: StaticRootLayerGroup(
              sketch: sketch,
              viewPortSize: viewPortSize,
              originOffset: originOffset,
              scaleFactor: scaleFactor,
            ),
          );
        },
      ),
    );
  }
}
