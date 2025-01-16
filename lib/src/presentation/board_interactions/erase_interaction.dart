import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphilia_board/graphilia_board.dart';

class _ErasingState<T> {
  _ErasingState() {
    initialize();
  }

  late Point? lastErasedPoint;
  late int skippedUpdateEventsCount;
  late bool isFirstMoveEvent;
  late List<Drawing<T>> erasedDrawings;
  late InteractionFeedback? interactionFeedback;

  void initialize() {
    lastErasedPoint = null;
    skippedUpdateEventsCount = 0;
    isFirstMoveEvent = true;
    erasedDrawings = [];
    interactionFeedback = null;
  }
}

class EraseInteraction<T> extends BoardInteraction<T> {
  EraseInteraction({
    required this.eraserWidth,
  }) : _interactionState = _ErasingState();

  final double eraserWidth;

  final _ErasingState<T> _interactionState;

  BoardState<T, BoardStateConfig> _removeMouseCursor(BoardState<T, BoardStateConfig> state) {
    return state.copyWith(
      mouseCursor: SystemMouseCursors.none,
    );
  }

  BoardState<T, BoardStateConfig> _restoreMouseCursor(BoardState<T, BoardStateConfig> state) {
    return state.copyWith(
      mouseCursor: null,
    );
  }

  BoardState<T, BoardStateConfig> _setInteractionFeedback(
    BoardState<T, BoardStateConfig> state,
    CanvasPaintCallback canvasPaintCallback,
  ) {
    final previousInteractionFeedback = _interactionState.interactionFeedback;
    _interactionState.interactionFeedback = CanvasInteractionFeedback(canvasPaintCallback);

    final updatedInteractionFeedbacks = [
      ...state.interactionFeedbacks.where((e) => e != previousInteractionFeedback),
      _interactionState.interactionFeedback!,
    ];

    return state.copyWith(
      interactionFeedbacks: updatedInteractionFeedbacks,
    );
  }

  BoardState<T, BoardStateConfig> _clearInteractionFeedback(
    BoardState<T, BoardStateConfig> state,
  ) {
    if (_interactionState.interactionFeedback == null) return state;

    return state.copyWith(
      interactionFeedbacks: state.interactionFeedbacks.where((e) => e != _interactionState.interactionFeedback).toList(),
    );
  }

  void _drawEraser(Canvas canvas, BoardState<T, BoardStateConfig> state, BoardStateConfig config) {
    if (state.pointerPosition == null) return;

    // Pointer position is not null

    final maybeScaledEraserWidth = scaleEraserWidthIfNecessary(
      eraserWidth: eraserWidth,
      scaleFactor: state.scaleFactor,
      config: config,
    );

    canvas.drawCircle(
      state.pointerPosition!,
      maybeScaledEraserWidth / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke,
    );
  }

  BoardState<T, BoardStateConfig> disposeResources(BoardState<T, BoardStateConfig> state) {
    var updatedState = _clearInteractionFeedback(state);

    // Restore mouse cursor
    updatedState = _restoreMouseCursor(updatedState);

    // Reset the interaction state
    _interactionState.initialize();

    return updatedState;
  }

  @override
  void onRemoved(BoardNotifier<T, BoardStateConfig> notifier) {
    final state = notifier.value;

    final updatedState = disposeResources(state);

    notifier.setBoardState(
      state: updatedState,
      shouldAddToHistory: false,
    );
  }

  @override
  PointerHoverEventListenerHandler<T> get handlePointerHoverEvent => (
        PointerHoverEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        // Update the mouse cursor
        var updatedState = _removeMouseCursor(state);

        // Update the interaction feedback
        updatedState = _setInteractionFeedback(updatedState, (canvas) => _drawEraser(canvas, updatedState, notifier.config));

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  DetailedGestureScaleStartCallbackHandler<T> get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        var updatedState = _eraseDrawingsByPoint(point, state, notifier.config);

        // Update the interaction feedback
        updatedState = _setInteractionFeedback(updatedState, (canvas) => _drawEraser(canvas, updatedState, notifier.config));

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  DetailedGestureScaleUpdateCallbackHandler<T> get handleOnScaleUpdate => (
        ScaleUpdateDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        late BoardState<T, BoardStateConfig> updatedState;
        final shouldErase = _interactionState.isFirstMoveEvent || _interactionState.skippedUpdateEventsCount >= 3;
        if (shouldErase) {
          updatedState = _eraseDrawingsByPoint(point, state, notifier.config);
          _interactionState.skippedUpdateEventsCount = 0;
          _interactionState.lastErasedPoint = point;
        } else {
          updatedState = state;
          _interactionState.skippedUpdateEventsCount++;
        }
        _interactionState.isFirstMoveEvent = false;

        // Update the interaction feedback
        updatedState = _setInteractionFeedback(updatedState, (canvas) => _drawEraser(canvas, updatedState, notifier.config));

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  DetailedGestureScaleEndCallbackHandler<T> get handleOnScaleEnd => (
        ScaleEndDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        var updatedState = _eraseDrawingsByPoint(point, state, notifier.config);

        updatedState = _setBoardStateDelta(updatedState);

        updatedState = _clearInteractionFeedback(updatedState);

        final wereErasedDrawings = _interactionState.erasedDrawings.isNotEmpty;

        // Reset the interaction state
        _interactionState.initialize();

        // After initialization create a new interaction feedback
        // Without this, the eraser will not be drawn when the user stops erasing
        updatedState = _setInteractionFeedback(updatedState, (canvas) => _drawEraser(canvas, updatedState, notifier.config));

        notifier.setBoardState(
          state: updatedState,
          // Update the history only if there were erased drawings
          shouldAddToHistory: wereErasedDrawings,
        );
        return true;
      };

  @override
  PointerCancelEventListenerHandler<T> get handlePointerCancelEvent => (
        PointerCancelEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        var updatedState = _eraseDrawingsByPoint(point, state, notifier.config);

        updatedState = _setBoardStateDelta(updatedState);

        updatedState = _clearInteractionFeedback(updatedState);

        // Reset the interaction state
        _interactionState.initialize();

        // After initialization create a new interaction feedback
        // Without this, the eraser will not be drawn when the user stops erasing
        updatedState = _setInteractionFeedback(updatedState, (canvas) => _drawEraser(canvas, updatedState, notifier.config));

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  @override
  PointerExitEventListenerHandler<T> get handlePointerExitEvent => (
        PointerExitEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        var updatedState = _setBoardStateDelta(state);

        updatedState = disposeResources(updatedState);

        notifier.setBoardState(
          state: updatedState,
          shouldAddToHistory: false,
        );
        return true;
      };

  BoardState<T, BoardStateConfig> _eraseDrawingsByPoint(
    Point point,
    BoardState<T, BoardStateConfig> state,
    BoardStateConfig config,
  ) {
    final maybeScaledEraserWidth = scaleEraserWidthIfNecessary(
      eraserWidth: eraserWidth,
      scaleFactor: state.scaleFactor,
      config: config,
    );

    late List<Drawing<T>> erasedDrawings;
    if (_interactionState.lastErasedPoint == null) {
      erasedDrawings = state.sketch.getDrawingsByPoint(
        state,
        point,
        tolerance: maybeScaledEraserWidth / 2,
      );
    } else {
      erasedDrawings = [];

      // Use the last stroke point to generate a polygon from that last point
      // and the point received so we can erase drawings inside that polygon
      // allowing to delete drawings that are inside the "erasing line"
      // performed by the user also if the user is moving the pointer fast

      final eraseStrokeRect = Rect.fromPoints(
        _interactionState.lastErasedPoint!,
        point,
      ).inflate(maybeScaledEraserWidth / 2);

      final eraseStrokeRectVertices = eraseStrokeRect.vertices.map((v) => Point.fromOffset(v)).toList();
      final drawingsInBounds = state.sketch.getDrawingsByRect(eraseStrokeRect);

      // TODO: Currently the erase bound is a rectangle, but it should be a circle. Implement a method to get the drawings inside a circle.
      for (final drawing in drawingsInBounds) {
        final isInside = drawing.isInsidePolygon(
          state,
          eraseStrokeRectVertices,
          PointsInPolygonMode.partial,
        );

        if (isInside) {
          erasedDrawings.add(drawing);
        }
      }
    }

    if (erasedDrawings.isEmpty) return state;

    // ErasedDrawings contains some drawings

    _addErasedDrawingToInteractionState(erasedDrawings);

    final eraseDelta = SketchDelta.delete(
      erasedDrawings,
      state.sketchDelta.version + 1,
    );

    return state.copyWith(
      sketchDelta: eraseDelta,
    );
  }

  BoardState<T, BoardStateConfig> _setBoardStateDelta(BoardState<T, BoardStateConfig> state) {
    if (_interactionState.erasedDrawings.isEmpty) return state;

    return state.copyWith(
      sketchDelta: SketchDelta.delete(
        [..._interactionState.erasedDrawings],
        state.sketchDelta.version,
      ),
      shouldApplySketchDeltaToSketch: false,
    );
  }

  void _addErasedDrawingToInteractionState(List<Drawing<T>> erasedDrawings) {
    _interactionState.erasedDrawings = [
      ..._interactionState.erasedDrawings,
      ...erasedDrawings,
    ];
  }
}

extension EraseInteractionNonOverridableMethodsExtension on EraseInteraction {
  double scaleEraserWidthIfNecessary({
    required double eraserWidth,
    required double scaleFactor,
    required BoardStateConfig config,
  }) =>
      config.shouldScaleEraserWidth ? eraserWidth / scaleFactor : eraserWidth;
}
