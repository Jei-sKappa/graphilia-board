import 'package:collection/collection.dart';
import 'package:detailed_gesture_detector/detailed_gesture_detector.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/board/board.dart';
import 'package:graphilia_board/src/presentation/interaction_controller/interaction_controller.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/layers/layers.dart';
import 'package:graphilia_board/src/presentation/board_interactions/board_interactions.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

/// {@template graphilia_board}
/// This Widget represents a canvas on which users can draw with any pointer.
///
/// You can control its behavior from code using the [notifier] instance you
/// pass in.
/// {@endtemplate}
class GraphiliaBoard<T> extends StatefulWidget {
  /// {@macro graphilia_board}
  const GraphiliaBoard({
    /// The notifier that controls this canvas.
    required this.notifier,
    required this.interactionController,
    super.key,
  });

  /// The notifier that controls this canvas.
  final BoardNotifier<T> notifier;

  final InteractionControllerBase<T> interactionController;

  @override
  State<GraphiliaBoard<T>> createState() => _GraphiliaBoardState<T>();

  // Helper methods
  static void registerFactories<T>({
    Map<String, DrawingToolFactory<T>>? drawingToolFactories,
    Map<String, DrawingFactory<T>>? drawingFactories,
    Map<String, DrawingRepresentationFactory>? drawingRepresentationFactories,
  }) {
    _registerDrawingToolFactories<T>(
      drawingToolFactories: drawingToolFactories,
    );
    _registerDrawingFactories<T>(
      drawingFactories: drawingFactories,
    );
    _registerDrawingRepresentationFactories(
      drawingRepresentationFactories: drawingRepresentationFactories,
    );
  }

  static void _registerDrawingToolFactories<T>({
    Map<String, DrawingToolFactory<T>>? drawingToolFactories,
  }) {
    final fixedDrawingToolFactories = drawingToolFactories ?? getBaseDrawingToolFactories<T>();

    for (final entry in fixedDrawingToolFactories.entries) {
      DrawingTool.registerFactory(entry.key, entry.value);
    }
  }

  static void _registerDrawingFactories<T>({
    Map<String, DrawingFactory<T>>? drawingFactories,
  }) {
    final fixedDrawingFactories = drawingFactories ?? getBaseDrawingFactories<T>();

    for (final entry in fixedDrawingFactories.entries) {
      Drawing.registerFactory(entry.key, entry.value);
    }
  }

  static void _registerDrawingRepresentationFactories({
    Map<String, DrawingRepresentationFactory>? drawingRepresentationFactories,
  }) {
    final fixedDrawingRepresentationFactories = drawingRepresentationFactories ?? baseDrawingRepresentationFactories;

    for (final entry in fixedDrawingRepresentationFactories.entries) {
      DrawingRepresentation.registerFactory(entry.key, entry.value);
    }
  }
}

class _GraphiliaBoardState<T> extends State<GraphiliaBoard<T>> {
  Set<BoardInteraction<T>> previousBoardInteractions = {};

  @override
  void initState() {
    widget.interactionController.graphiliaBoardInteractionsNotifier.where((previous, next) => !(const DeepCollectionEquality().equals(previous, next))).addListener(interactionsChangedListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.interactionController.graphiliaBoardInteractionsNotifier.removeListener(interactionsChangedListener);
    super.dispose();
  }

  void interactionsChangedListener() {
    final currentBoardInteractions = widget.interactionController.graphiliaBoardInteractions;

    // Get the removed interactions from the previous set
    final removedInteractions = previousBoardInteractions.difference(currentBoardInteractions);

    for (final interaction in removedInteractions) {
      interaction.onRemoved(widget.notifier);
    }

    // Update the previous set
    previousBoardInteractions = currentBoardInteractions;
  }

  @override
  Widget build(BuildContext context) => _Board(
        notifier: widget.notifier,
        interactionController: widget.interactionController,
      );
}

class _Board<T> extends StatelessWidget {
  const _Board({
    required this.notifier,
    required this.interactionController,
  });

  final BoardNotifier<T> notifier;
  final InteractionControllerBase<T> interactionController;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: interactionController.onPointerDown,
      onPointerMove: interactionController.onPointerMove,
      onPointerUp: interactionController.onPointerUp,
      onPointerHover: interactionController.onPointerHover,
      onPointerCancel: interactionController.onPointerCancel,
      onPointerPanZoomStart: interactionController.onPointerPanZoomStart,
      onPointerPanZoomUpdate: interactionController.onPointerPanZoomUpdate,
      onPointerPanZoomEnd: interactionController.onPointerPanZoomEnd,
      onPointerSignal: interactionController.onPointerSignal,
      child: ListenableBuilder(
        // Only rebuild the [DetailedGestureDetector] when the state changes
        // to a different type to update the interaction controller handlers.
        //
        // The [Listener] widget above is not rebuilt because currently all
        // interactions handlers are **never** nullable so the right state
        // handler is always called.
        listenable: interactionController.graphiliaBoardInteractionsNotifier.where((previous, next) => !(const DeepCollectionEquality().equals(previous, next))),
        builder: (context, child) {
          return DetailedGestureDetector(
            onTapDown: interactionController.onTapDown,
            onTapUp: interactionController.onTapUp,
            onTap: interactionController.onTap,
            onTapCancel: interactionController.onTapCancel,
            onSecondaryTap: interactionController.onSecondaryTap,
            onSecondaryTapDown: interactionController.onSecondaryTapDown,
            onSecondaryTapUp: interactionController.onSecondaryTapUp,
            onSecondaryTapCancel: interactionController.onSecondaryTapCancel,
            onTertiaryTapDown: interactionController.onTertiaryTapDown,
            onTertiaryTapUp: interactionController.onTertiaryTapUp,
            onTertiaryTapCancel: interactionController.onTertiaryTapCancel,
            onDoubleTapDown: interactionController.onDoubleTapDown,
            onDoubleTap: interactionController.onDoubleTap,
            onDoubleTapCancel: interactionController.onDoubleTapCancel,
            onLongPressDown: interactionController.onLongPressDown,
            onLongPressCancel: interactionController.onLongPressCancel,
            onLongPress: interactionController.onLongPress,
            onLongPressStart: interactionController.onLongPressStart,
            onLongPressMoveUpdate: interactionController.onLongPressMoveUpdate,
            onLongPressUp: interactionController.onLongPressUp,
            onLongPressEnd: interactionController.onLongPressEnd,
            onSecondaryLongPressDown: interactionController.onSecondaryLongPressDown,
            onSecondaryLongPressCancel: interactionController.onSecondaryLongPressCancel,
            onSecondaryLongPress: interactionController.onSecondaryLongPress,
            onSecondaryLongPressStart: interactionController.onSecondaryLongPressStart,
            onSecondaryLongPressMoveUpdate: interactionController.onSecondaryLongPressMoveUpdate,
            onSecondaryLongPressUp: interactionController.onSecondaryLongPressUp,
            onSecondaryLongPressEnd: interactionController.onSecondaryLongPressEnd,
            onTertiaryLongPressDown: interactionController.onTertiaryLongPressDown,
            onTertiaryLongPressCancel: interactionController.onTertiaryLongPressCancel,
            onTertiaryLongPress: interactionController.onTertiaryLongPress,
            onTertiaryLongPressStart: interactionController.onTertiaryLongPressStart,
            onTertiaryLongPressMoveUpdate: interactionController.onTertiaryLongPressMoveUpdate,
            onTertiaryLongPressUp: interactionController.onTertiaryLongPressUp,
            onTertiaryLongPressEnd: interactionController.onTertiaryLongPressEnd,
            onVerticalDragDown: interactionController.onVerticalDragDown,
            onVerticalDragStart: interactionController.onVerticalDragStart,
            onVerticalDragUpdate: interactionController.onVerticalDragUpdate,
            onVerticalDragEnd: interactionController.onVerticalDragEnd,
            onVerticalDragCancel: interactionController.onVerticalDragCancel,
            onHorizontalDragDown: interactionController.onHorizontalDragDown,
            onHorizontalDragStart: interactionController.onHorizontalDragStart,
            onHorizontalDragUpdate: interactionController.onHorizontalDragUpdate,
            onHorizontalDragEnd: interactionController.onHorizontalDragEnd,
            onHorizontalDragCancel: interactionController.onHorizontalDragCancel,
            onForcePressStart: interactionController.onForcePressStart,
            onForcePressPeak: interactionController.onForcePressPeak,
            onForcePressUpdate: interactionController.onForcePressUpdate,
            onForcePressEnd: interactionController.onForcePressEnd,
            onPanDown: interactionController.onPanDown,
            onPanStart: interactionController.onPanStart,
            onPanUpdate: interactionController.onPanUpdate,
            onPanEnd: interactionController.onPanEnd,
            onPanCancel: interactionController.onPanCancel,
            onScaleStart: interactionController.onScaleStart,
            onScaleUpdate: interactionController.onScaleUpdate,
            onScaleEnd: interactionController.onScaleEnd,
            child: child,
          );
        },
        child: ColoredBox(
          // TODO: This a fix to make the parent as big as possible to avoid losing gesture detection, see "https://github.com/flutter/flutter/issues/6606" and "https://github.com/flutter/flutter/issues/27587"
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: RepaintBoundary(
              key: notifier.repaintBoundaryKey,
              child: ClipRect(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final viewPortSize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    return GraphiliaBoardDetails(
                      boardSize: viewPortSize,
                      child: RootLayerGroup(
                        notifier: notifier,
                        interactionController: interactionController,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
