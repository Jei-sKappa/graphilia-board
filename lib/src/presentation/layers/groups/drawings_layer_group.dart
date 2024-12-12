import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:graphilia_board/src/core/extensions/extensions.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

enum _DrawingType {
  canvas,
  widget,
}

extension _DrawingTypeExtension on Drawing {
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

class _CategoryGroup {
  _CategoryGroup(
    Drawing drawing,
    this.catergory,
  )   : drawings = [drawing],
        stateListener = drawing.stateListener;

  void addToGroup(Drawing drawing) {
    drawings.add(drawing);
  }

  final List<Drawing> drawings;
  final BoardStateListener? stateListener;
  final _DrawingCatergory catergory;
}

class _DrawingCatergory {
  _DrawingCatergory(Drawing drawing)
      : drawingType = drawing.type,
        listenerType = drawing.stateListener?.runtimeType;

  final _DrawingType drawingType;
  final Type? listenerType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _DrawingCatergory && other.drawingType == drawingType && other.listenerType == listenerType;
  }

  @override
  int get hashCode => drawingType.hashCode ^ listenerType.hashCode;

  @override
  String toString() {
    return '_DrawingCatergory('
        'drawingType: $drawingType, '
        'listenerType: $listenerType'
        ')';
  }
}

class DrawingsLayerGroup extends StatefulWidget {
  const DrawingsLayerGroup({
    super.key,
    required this.notifier,
    required this.viewPortSize,
  });

  final BoardNotifier notifier;
  final Size viewPortSize;

  @override
  State<DrawingsLayerGroup> createState() => _DrawingsLayerGroupState();
}

class _DrawingsLayerGroupState extends State<DrawingsLayerGroup> {
  Rect? lastRenderedRect;

  Rect _getPrerenderRect(Size viewPortSize, BoardState state) {
    // Render double the viewport bounds to avoid flickering when scrolling.
    // TODO: !!! Consider lowering the area to render to avoid performance issues.
    // TODO: !!! Consider adding a dyanmic area render feature based on the direction and velocity of the scroll trying to predict the next visible area.
    final scaleViewPortWidth = viewPortSize.width / state.scaleFactor;
    final scaleViewPortHeight = viewPortSize.height / state.scaleFactor;

    return Rect.fromLTRB(
      state.originOffset.dx - scaleViewPortWidth,
      state.originOffset.dy - scaleViewPortHeight,
      state.originOffset.dx + scaleViewPortWidth * 2,
      state.originOffset.dy + scaleViewPortHeight * 2,
    );
  }

  CanvasDrawingsLayer _canvasDrawingLayerBuilder(
    _CategoryGroup group,
    BoardState state,
  ) =>
      CanvasDrawingsLayer(
        drawings: List.castFrom(group.drawings),
        state: state,
        areDrawingsSelected: false,
        simulatePressure: widget.notifier.config.simulatePressure,
      );

  WidgetDrawingsLayer _widgetDrawingLayerBuilder(
    _CategoryGroup group,
    BoardState state,
  ) =>
      WidgetDrawingsLayer(
        drawings: List.castFrom(group.drawings),
        state: state,
        areDrawingsSelected: false,
      );

  ValueListenableBuilder _createValueListenableBuilder(
    _CategoryGroup group,
    Widget Function(_CategoryGroup group, BoardState state) layerBuilder,
  ) =>
      ValueListenableBuilder(
        valueListenable: widget.notifier.where(
          group.stateListener!.shouldReceiveUpdate,
        ),
        builder: (_, listenedState, __) => layerBuilder(group, listenedState),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // Determine if the visible area is out of the bounds of
      // the prerendered area
      valueListenable: widget.notifier.where(
        (previous, next) {
          // If there is no last rendered rect, we need to
          // rebuild
          if (lastRenderedRect == null) return true;

          // If the sketch version changed, we need to rebuild
          final isSketchVersionChanged = previous.sketchDelta.version != next.sketchDelta.version;
          if (isSketchVersionChanged) return true;

          // TODO: Check only if the selected drawings in the visible area changed
          final prevSelectedDrawingsIds = switch (previous) {
            SelectedState s => s.selectedDrawings.map((e) => e.id).toList(),
            _ => null,
          };
          // TODO: Check only if the selected drawings in the visible area changed
          final selectedDrawingsIds = switch (next) {
            SelectedState s => s.selectedDrawings.map((e) => e.id).toList(),
            _ => null,
          };
          final areSelectedDrawingsIdsChanged = !(const DeepCollectionEquality().equals(
            prevSelectedDrawingsIds,
            selectedDrawingsIds,
          ));
          if (areSelectedDrawingsIdsChanged) return true;

          // Get the current visible rect in the viewport
          final scaledViewPortWidth = widget.viewPortSize.width / next.scaleFactor;
          final scaledViewPortHeight = widget.viewPortSize.height / next.scaleFactor;
          final visibleRect = Rect.fromLTRB(
            next.originOffset.dx,
            next.originOffset.dy,
            next.originOffset.dx + scaledViewPortWidth,
            next.originOffset.dy + scaledViewPortHeight,
          );

          // If the visible rect is not inscribed in the last
          // rendered rect, we need to rebuild
          if (!visibleRect.isInscribed(lastRenderedRect!)) {
            return true;
          }

          return false;
        },
      ),
      builder: (context, state, _) {
        // Get the prerendered rect to optimize the drawings
        // rendering
        final prerenderedRect = _getPrerenderRect(
          widget.viewPortSize,
          state,
        );

        // Get the drawings in the currently prerendered rect
        final drawings = state.sketch
            .getDrawingsByRect(
              prerenderedRect,
            )
            // Make sure to also expand the drawing groups
            .expandDrawingGroups();

        if (drawings.isEmpty) return const SizedBox.shrink();

        // TODO: Verify if this is needed
        drawings.sort((a, b) => a.zIndex.compareTo(b.zIndex));

        // Set the selected drawings
        late final List<dynamic> selectedDrawingsIds;

        if (state is SelectedState) {
          // TODO: Check only if the selected drawings in the visible area changed
          selectedDrawingsIds = state.selectedDrawings.expandDrawingGroups().map((e) => e.id).toList();
        } else {
          selectedDrawingsIds = [];
        }

        final zIndexedDrawingsMatrix = <_CategoryGroup>[];
        late _DrawingCatergory lastDrawingCategory;
        for (final drawing in drawings) {
          if (selectedDrawingsIds.contains(drawing.id)) {
            continue;
          }

          // The drawing is not selected

          if (drawing is! CanvasDrawing && drawing is! WidgetDrawing) {
            throw Exception('Invalid drawing type');
          }

          // The drawing's type is valid

          final currentDrawingCategory = _DrawingCatergory(drawing);

          if (zIndexedDrawingsMatrix.isEmpty) {
            zIndexedDrawingsMatrix.add(
              _CategoryGroup(drawing, currentDrawingCategory),
            );
            lastDrawingCategory = currentDrawingCategory;
            continue;
          }

          // The zIndexMatrix is not empty (first drawing already added)

          // If the current drawing category is the same as the last
          // drawing category, add the drawing to the last group
          if (currentDrawingCategory == lastDrawingCategory) {
            zIndexedDrawingsMatrix.last.addToGroup(drawing);
          }
          // Otherwise, create a new group
          else {
            zIndexedDrawingsMatrix.add(
              _CategoryGroup(drawing, currentDrawingCategory),
            );
            lastDrawingCategory = currentDrawingCategory;
          }
        }

        final drawingLayersStack = Stack(
          children: [
            for (final drawingsGroup in zIndexedDrawingsMatrix)
              Positioned.fill(
                child: RepaintBoundary(
                  child: () {
                    late Widget layer;
                    switch (drawingsGroup.catergory.drawingType) {
                      case _DrawingType.canvas:
                        if (drawingsGroup.stateListener != null) {
                          layer = _createValueListenableBuilder(
                            drawingsGroup,
                            _canvasDrawingLayerBuilder,
                          );
                        } else {
                          layer = _canvasDrawingLayerBuilder(
                            drawingsGroup,
                            state,
                          );
                        }

                        // Ignore pointer to avoid interferences with
                        // [WidgetDrawing]s GestureRecognizers
                        layer = IgnorePointer(child: layer);

                      case _DrawingType.widget:
                        if (drawingsGroup.stateListener != null) {
                          layer = _createValueListenableBuilder(
                            drawingsGroup,
                            _widgetDrawingLayerBuilder,
                          );
                        } else {
                          layer = _widgetDrawingLayerBuilder(
                            drawingsGroup,
                            state,
                          );
                        }
                    }

                    return layer;
                  }(),
                ),
              ),
          ],
        );

        // Save the last rendered rect
        lastRenderedRect = prerenderedRect;

        return drawingLayersStack;
      },
    );
  }
}
