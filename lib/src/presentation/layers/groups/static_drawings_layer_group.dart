import 'package:flutter/widgets.dart';
import 'package:graphilia_board/graphilia_board.dart';

enum _DrawingType {
  canvas,
  widget,
}

extension _DrawingTypeExtension<T> on Drawing<T> {
  _DrawingType get type {
    if (this is CanvasDrawing) {
      return _DrawingType.canvas;
    } else if (this is WidgetDrawing) {
      return _DrawingType.widget;
    } else {
      throw Exception('Invalid drawing type');
    }
  }
}

class StaticDrawingsLayerGroup<T> extends StatelessWidget {
  const StaticDrawingsLayerGroup({
    super.key,
    required this.sketch,
    this.originOffset = Offset.zero,
    this.scaleFactor = 1.0,
  });

  final Sketch<T> sketch;
  final Offset originOffset;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final state = BoardState<T, BoardStateConfig>(
      sketch: sketch,
      // TODO: Check why `sketchDelta` is required
      sketchDelta: const SketchDelta.initial(),
    );

    final viewPortSize = GraphiliaBoardDetails.of(context).boardSize;

    final visibleRect = Rect.fromLTRB(
      state.originOffset.dx,
      state.originOffset.dy,
      state.originOffset.dx + viewPortSize.width / state.scaleFactor,
      state.originOffset.dy + viewPortSize.height / state.scaleFactor,
    );

    // Get the drawings in the rect
    final drawings = state.sketch
        .getDrawingsByRect(visibleRect)
        // Make sure to also expand the drawing groups
        .expandDrawingGroups();

    if (drawings.isEmpty) return const SizedBox.shrink();

    // TODO: Verify if this is needed
    drawings.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    final zIndexedDrawingsMatrix = <List<Drawing<T>>>[];
    late _DrawingType lastDrawingType;
    for (final drawing in drawings) {
      if (drawing is! CanvasDrawing<T> && drawing is! WidgetDrawing<T>) {
        throw Exception('Invalid drawing type');
      }

      // The drawing's type is valid

      final currentDrawingType = drawing.type;

      if (zIndexedDrawingsMatrix.isEmpty) {
        zIndexedDrawingsMatrix.add([drawing]);
        lastDrawingType = currentDrawingType;
        continue;
      }

      // The zIndexMatrix is not empty (first drawing already added)

      // If the current drawing category is the same as the last
      // drawing category, add the drawing to the last group
      if (currentDrawingType == lastDrawingType) {
        zIndexedDrawingsMatrix.last.add(drawing);
      }
      // Otherwise, create a new group
      else {
        zIndexedDrawingsMatrix.add([drawing]);
        lastDrawingType = currentDrawingType;
      }
    }

    return Stack(
      children: [
        for (final drawings in zIndexedDrawingsMatrix)
          Positioned.fill(
            child: RepaintBoundary(
              child: switch (drawings.first.type) {
                _DrawingType.canvas => CanvasDrawingsLayer<T>(
                    drawings: List.castFrom(drawings),
                    state: state,
                    areDrawingsSelected: false,
                  ),
                _DrawingType.widget => WidgetDrawingsLayer<T>(
                    drawings: List.castFrom(drawings),
                    state: state,
                    areDrawingsSelected: false,
                  ),
              },
            ),
          ),
      ],
    );
  }
}
