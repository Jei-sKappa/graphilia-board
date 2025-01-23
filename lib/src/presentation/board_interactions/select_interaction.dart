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

  BoardState<T> _setPrecisionMouseCursor(BoardState<T> state) {
    return state.copyWith(
      mouseCursor: SystemMouseCursors.precise,
    );
  }

  BoardState<T> _restoreMouseCursor(BoardState<T> state) {
    return state.copyWith(
      mouseCursor: null,
    );
  }

  BoardState<T> _setInteractionFeedback(BoardState<T> state, CanvasPaintCallback canvasPaintCallback) {
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

  BoardState<T> _clearInteractionFeedback(BoardState<T> state) {
    if (_interactionState.interactionFeedback == null) return state;

    return state.copyWith(
      interactionFeedbacks: state.interactionFeedbacks.where((e) => e != _interactionState.interactionFeedback).toList(),
    );
  }

  void _drawLazo(Canvas canvas, List<Point> selectionPoints, BoardState<T> state, BoardStateConfig config) {
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

  BoardState<T> disposeResources(BoardState<T> state) {
    var updatedState = _clearInteractionFeedback(state);

    // Restore mouse cursor
    updatedState = _restoreMouseCursor(updatedState);

    // Reset the interaction state
    _interactionState.initialize();

    return updatedState;
  }

  @override
  void onRemoved(BoardNotifier<T> notifier) {
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
        BoardNotifier<T> notifier,
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
        BoardNotifier<T> notifier,
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
        BoardNotifier<T> notifier,
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
        BoardNotifier<T> notifier,
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
        BoardNotifier<T> notifier,
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
        BoardNotifier<T> notifier,
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

  ({BoardState<T> state, bool shouldAddToHistory}) _handleInteractionEnd(
    BoardState<T> state,
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
    if (updatedState is SelectedState<T>) {
      return (state: updatedState, shouldAddToHistory: true);
    }

    // updatedState is not a [SelectedState]

    return (state: updatedState, shouldAddToHistory: false);
  }

  List<Drawing<T>> _getOverlappingDrawings(
    BoardState<T> state,
    BoardStateConfig config,
    Drawing<T> targetDrawing,
  ) {
    if (!targetDrawing.overlapsFollow) return [];

    final targetDrawingBounds = targetDrawing.getBounds();

    final drawingInSelectionBounds = state.sketch.getDrawingsByRect(
      targetDrawingBounds,
    );

    final overlappingDrawings = <Drawing<T>>[];
    for (final drawing in drawingInSelectionBounds) {
      // This is necessary to prevent StackOverflow when recursively calling
      // this function when [selectionRect] is a drawing's bounds, because
      // [state.sketch.getDrawingsByRect] will also return the drawing itself
      if (drawing.id == targetDrawing.id) continue;

      // Only drawings with zIndex bigger than the target drawing should be
      // considered
      // This is also necessary to prevent StackOverflow when recursively
      // calling. The '=' in the comparison is mandatory because the zIndex
      // can be the same and this will cause an infinite loop
      if (drawing.zIndex <= targetDrawing.zIndex) continue;

      final isInsideSelection = drawing.isInsidePolygon(
        state,
        targetDrawingBounds.vertices.map((e) => Point.fromOffset(e)).toList(),
        PointsInPolygonMode.partial,
      );

      if (!isInsideSelection) continue;

      // The drawing is inside the selection polygon

      overlappingDrawings.add(drawing);

      if (!drawing.overlapsFollow) continue;

      // The drawing has overlapsFollow set to true

      // Get the drawings that are in the same rect as this drawing using
      // recursive call
      final drawingsInThisBounds = _getOverlappingDrawings(
        state,
        config,
        drawing,
      );

      if (drawingsInThisBounds.isEmpty) continue;

      // There is at least one drawing that is inside the bounds of this drawing

      overlappingDrawings.addAll(drawingsInThisBounds);
    }

    return overlappingDrawings;
  }

  List<Drawing<T>> _getDrawingsInSelectionRect(
    BoardState<T> state,
    BoardStateConfig config,
  ) {
    // In order to select a drawing, at least one point of the drawing
    // must be inside the selection polygon
    final drawingInSelectionBounds = state.sketch.getDrawingsByRect(
      _interactionState.selectionRect!,
    );

    final selectedDrawings = <Drawing<T>>[];
    for (final drawing in drawingInSelectionBounds) {
      // TODO: This is useful only when the selection is a "lazo selection" so that we check if the drawing is inside the actual selection's irregular shape. If the selection is a rectangular selection, we should remove this check.
      final isInsideSelection = drawing.isInsidePolygon(
        state,
        _interactionState.selectionPoints,
        config.selectionMode,
      );

      if (!isInsideSelection) continue;

      // The drawing is inside the selection polygon

      selectedDrawings.add(drawing);

      final overlappingDrawings = _getOverlappingDrawings(
        state,
        config,
        drawing,
      );

      if (overlappingDrawings.isEmpty) continue;

      // There is at least one drawing that is inside the bounds of this drawing

      selectedDrawings.addAll(overlappingDrawings);
    }

    return selectedDrawings.toSet().toList();
  }

  BoardState<T>? _tryConvertBoardStateToSelectedState(
    BoardState<T> state,
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

    final selectedDrawings = _getDrawingsInSelectionRect(
      state,
      config,
    );

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
