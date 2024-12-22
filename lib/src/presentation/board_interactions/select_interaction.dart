import 'dart:math' hide Point;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphilia_board/graphilia_board.dart';

class _SelectingState {
  _SelectingState() {
    initialize();
  }

  late List<Point> selectionPoints;
  late Rect? selectionRect;
  late InteractionFeedback? interactionFeedback;

  void initialize() {
    selectionPoints = [];
    selectionRect = null;
    interactionFeedback = null;
  }
}

class SelectInteraction<T> extends BoardInteraction<T> {
  SelectInteraction({
    this.selectionLineSimplificationTolerance = 2.0,
    this.enableRectangularSelection = false,
  }) : _interactionState = _SelectingState();

  final double selectionLineSimplificationTolerance;
  final bool enableRectangularSelection;

  final _SelectingState _interactionState;

  BoardState<T, BoardStateConfig> _setPrecisionMouseCursor(BoardState<T, BoardStateConfig> state) {
    return state.copyWith(
      mouseCursor: SystemMouseCursors.precise,
    );
  }

  BoardState<T, BoardStateConfig> _restoreMouseCursor(BoardState<T, BoardStateConfig> state) {
    return state.copyWith(
      mouseCursor: null,
    );
  }

  BoardState<T, BoardStateConfig> _setInteractionFeedback(BoardState<T, BoardStateConfig> state, CanvasPaintCallback canvasPaintCallback) {
    final previousInteractionFeedback = _interactionState.interactionFeedback;
    _interactionState.interactionFeedback = InteractionFeedback(canvasPaintCallback);

    final updatedInteractionFeedbacks = [
      ...state.interactionFeedbacks.where((e) => e != previousInteractionFeedback),
      _interactionState.interactionFeedback!,
    ];

    return state.copyWith(
      interactionFeedbacks: updatedInteractionFeedbacks,
    );
  }

  BoardState<T, BoardStateConfig> _clearInteractionFeedback(BoardState<T, BoardStateConfig> state) {
    if (_interactionState.interactionFeedback == null) return state;

    return state.copyWith(
      interactionFeedbacks: state.interactionFeedbacks.where((e) => e != _interactionState.interactionFeedback).toList(),
    );
  }

  void _drawLazo(Canvas canvas, List<Point> selectionPoints, BoardState<T, BoardStateConfig> state, BoardStateConfig config) {
    if (selectionPoints.isEmpty) return;

    // The selection points are more than one

    drawDashedPath(
      canvas: canvas,
      points: selectionPoints,
      dashWidth: 6 / state.scaleFactor,
      dashSpace: 6 / state.scaleFactor,
      paint: Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.5 / state.scaleFactor,
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
        final updatedState = _setPrecisionMouseCursor(state);

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

        _addFirstPointToSelection(point, notifier.config);

        // Update the interaction feedback
        final selectionPointsCopy = [..._interactionState.selectionPoints];
        final updatedState = _setInteractionFeedback(state, (canvas) => _drawLazo(canvas, selectionPointsCopy, state, notifier.config));

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
        if (_interactionState.selectionPoints.isEmpty || _interactionState.selectionRect == null) {
          _interactionState.initialize();
          return false;
        }

        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        _addPointToSelection(point, state.scaleFactor, notifier.config);

        // Update the interaction feedback
        final selectionPointsCopy = [..._interactionState.selectionPoints];
        final updatedState = _setInteractionFeedback(state, (canvas) => _drawLazo(canvas, selectionPointsCopy, state, notifier.config));

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
        // Actual implementation of the pointer up event
        if (_interactionState.selectionPoints.isEmpty || _interactionState.selectionRect == null) {
          _interactionState.initialize();
          return false;
        }

        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        _addPointToSelection(point, state.scaleFactor, notifier.config);

        final updatedStateDetails = _handleInteractionEnd(state, event, notifier.config);

        notifier.setBoardState(
          state: updatedStateDetails.state,
          shouldAddToHistory: updatedStateDetails.shouldAddToHistory,
        );

        return true;
      };

  @override
  PointerCancelEventListenerHandler<T> get handlePointerCancelEvent => (
        PointerCancelEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        if (_interactionState.selectionPoints.isEmpty || _interactionState.selectionRect == null) {
          _interactionState.initialize();
          return false;
        }

        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        _addPointToSelection(point, state.scaleFactor, notifier.config);

        final updatedStateDetails = _handleInteractionEnd(state, event, notifier.config);

        notifier.setBoardState(
          state: updatedStateDetails.state,
          shouldAddToHistory: updatedStateDetails.shouldAddToHistory,
        );

        return true;
      };

  @override
  PointerExitEventListenerHandler<T> get handlePointerExitEvent => (
        PointerExitEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        if (_interactionState.selectionPoints.isEmpty || _interactionState.selectionRect == null) {
          _interactionState.initialize();
          return false;
        }

        final state = notifier.value;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        _addPointToSelection(point, state.scaleFactor, notifier.config);

        final updatedState = _restoreMouseCursor(state);

        final updatedStateDetails = _handleInteractionEnd(updatedState, event, notifier.config);

        notifier.setBoardState(
          state: updatedStateDetails.state,
          shouldAddToHistory: updatedStateDetails.shouldAddToHistory,
        );

        return true;
      };

  ({BoardState<T, BoardStateConfig> state, bool shouldAddToHistory}) _handleInteractionEnd(
    BoardState<T, BoardStateConfig> state,
    PointerEvent event,
    BoardStateConfig config,
  ) {
    var updatedState = _tryConvertBoardStateToSelectedState(
      state,
      event,
      config,
    );

    // Clear the interaction feedback because:
    // - If [updatedState] is null, it means that the user has not selected
    // anything and so the lazo should not be displayed anymore
    // - If [updatedState] is [SelectedState], the lazo will be displayed
    // by the new [SelectedState]
    updatedState = _clearInteractionFeedback(updatedState ?? state);

    // Reset the interaction state
    _interactionState.initialize();

    // Add to undo history only if the state has become a [SelectedState]
    // because it means that the user has selected something
    if (updatedState is SelectedState<T, BoardStateConfig>) {
      return (state: updatedState, shouldAddToHistory: true);
    }

    // updatedState is not a [SelectedState]

    return (state: updatedState, shouldAddToHistory: false);
  }

  BoardState<T, BoardStateConfig>? _tryConvertBoardStateToSelectedState(
    BoardState<T, BoardStateConfig> state,
    PointerEvent event,
    BoardStateConfig config,
  ) {
    // If there is only one point return null
    if (_interactionState.selectionPoints.length <= 1) return null;

    // The selection points are more than one

    // Add a point to link last point to first point
    _addPointToSelection(
      _interactionState.selectionPoints.first,
      state.scaleFactor,
      config,
    );

    // In order to select a drawing, at least one point of the drawing
    // must be inside the selection polygon
    final drawingInSelectionBounds = state.sketch.getDrawingsByRect(
      _interactionState.selectionRect!,
    );

    final selectedDrawings = <Drawing<T>>[];
    for (final drawing in drawingInSelectionBounds) {
      final isInsideSelection = drawing.isInsidePolygon(
        state,
        _interactionState.selectionPoints,
        config.selectionMode,
      );
      if (isInsideSelection) {
        selectedDrawings.add(drawing);
      }
    }

    // Get the total bounds of the selected drawings
    final bounds = getTotalBounds(selectedDrawings);

    // If it's null it means that there is no drawing selected, so reset the
    // state
    if (bounds == null) return null;

    return SelectedState.fromOther(
      state,
      selectionPoints: _interactionState.selectionPoints,
      // Selection rect can't be null because it follows selectionPoints and
      // it's previously null checked
      selectionRect: _interactionState.selectionRect!,
      selectedDrawingsBounds: bounds,
      selectedDrawings: selectedDrawings,
      displayRectangularSelection: enableRectangularSelection,
    );
  }

  void _addFirstPointToSelection(
    Point point,
    BoardStateConfig config,
  ) {
    _interactionState.selectionPoints = [point];
    _interactionState.selectionRect = Rect.fromPoints(point, point);
  }

  void _addPointToSelection(
    Point point,
    double scaleFactor,
    BoardStateConfig config,
  ) {
    _interactionState.selectionPoints = config.pointsSimplifier.simplify(
      [..._interactionState.selectionPoints, point],
      pixelTolerance: selectionLineSimplificationTolerance / scaleFactor,
    );

    _interactionState.selectionRect = Rect.fromPoints(
      Offset(
        min(_interactionState.selectionRect!.topLeft.dx, point.x),
        min(_interactionState.selectionRect!.topLeft.dy, point.y),
      ),
      Offset(
        max(_interactionState.selectionRect!.bottomRight.dx, point.x),
        max(_interactionState.selectionRect!.bottomRight.dy, point.y),
      ),
    );
  }
}
