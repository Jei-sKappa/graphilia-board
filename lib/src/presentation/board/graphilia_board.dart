import 'package:collection/collection.dart';
import 'package:detailed_gesture_detector/detailed_gesture_detector.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board/src/models/models.dart';
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
class GraphiliaBoard extends StatefulWidget {
  /// {@macro graphilia_board}
  const GraphiliaBoard({
    /// The notifier that controls this canvas.
    required this.notifier,
    required this.interactionController,
    this.drawingFactories,
    this.drawingRepresentationFactories,
    super.key,
  });

  /// The notifier that controls this canvas.
  final BoardNotifier notifier;

  final InteractionControllerBase interactionController;

  final Map<String, DrawingFactory>? drawingFactories;

  final Map<String, DrawingRepresentationFactory>? drawingRepresentationFactories;

  @override
  State<GraphiliaBoard> createState() => _GraphiliaBoardState();
}

class _GraphiliaBoardState extends State<GraphiliaBoard> {
  Set<BoardInteraction> previousBoardInteractions = {};

  @override
  void initState() {
    registerDrawingFactories();
    registerDrawingRepresentationFactories();
    widget.interactionController.graphiliaBoardInteractionsNotifier.where((previous, next) => !(const DeepCollectionEquality().equals(previous, next))).addListener(interactionsChangedListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.interactionController.graphiliaBoardInteractionsNotifier.removeListener(interactionsChangedListener);
    super.dispose();
  }

  void registerDrawingFactories() {
    final drawingFactories = widget.drawingFactories ?? baseDrawingFactories;

    for (final entry in drawingFactories.entries) {
      Drawing.registerFactory(entry.key, entry.value);
    }
  }

  void registerDrawingRepresentationFactories() {
    final drawingRepresentationFactories = widget.drawingRepresentationFactories ?? baseDrawingRepresentationFactories;

    for (final entry in drawingRepresentationFactories.entries) {
      DrawingRepresentation.registerFactory(entry.key, entry.value);
    }
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

class _Board extends StatelessWidget {
  const _Board({
    required this.notifier,
    required this.interactionController,
  });

  final BoardNotifier notifier;
  final InteractionControllerBase interactionController;

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
            child: ClipRect(
              child: RootLayerGroup(
                notifier: notifier,
                interactionController: interactionController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
