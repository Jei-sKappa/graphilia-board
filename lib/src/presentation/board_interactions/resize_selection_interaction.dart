import 'package:flutter/gestures.dart';
import 'package:graphilia_board/graphilia_board.dart';

class _ResizingSelectionState {
  _ResizingSelectionState() {
    initialize();
  }

  late ResizeAnchor? anchor;
  late Point? interactionPoint;
  late bool hasResizedSelection;

  void initialize() {
    anchor = null;
    interactionPoint = null;
    hasResizedSelection = false;
  }

  bool get hasData => anchor != null && interactionPoint != null;
}

class ResizeSelectionInteraction<T> extends BoardInteraction<T> {
  ResizeSelectionInteraction({
    this.resizeBoundsInflation = 5.0,
  }) : _interactionState = _ResizingSelectionState();

  final double resizeBoundsInflation;
  final _ResizingSelectionState _interactionState;

  bool isStateValid(BoardState<T, BoardStateConfig> state) => state is SelectedState<T, BoardStateConfig> && state.displayRectangularSelection && state.selectedDrawings.isNotEmpty && state.selectionPoints.isNotEmpty;

  @override
  DetailedGestureScaleStartCallbackHandler<T> get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T, BoardStateConfig> notifier,
      ) {
        final state = notifier.value;

        // If the state is not valid then the interaction can't be executed
        if (!isStateValid(state)) {
          _interactionState.initialize();
          return false;
        }

        // The state is valid and the interaction state has data
        state as SelectedState<T, BoardStateConfig>;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        // Check if the point correspont to one of the 8 resize anchors
        final rectangularSelection = state.rectangularSelection;

        // Get the closest anchor point from the event point

        // Initially set the closest anchor point to the top left
        var closestAnchor = ResizeAnchor.topLeft;
        var closestAnchorPoint = rectangularSelection.topLeft;
        var minDistance = rectangularSelection.topLeft.distanceTo(point);

        // Check the top center anchor
        final topCenterDistance = rectangularSelection.topCenter.distanceTo(point);
        if (topCenterDistance < minDistance) {
          closestAnchor = ResizeAnchor.topCenter;
          closestAnchorPoint = rectangularSelection.topCenter;
          minDistance = topCenterDistance;
        }

        // Check the top right anchor
        final topRightDistance = rectangularSelection.topRight.distanceTo(point);
        if (topRightDistance < minDistance) {
          closestAnchor = ResizeAnchor.topRight;
          closestAnchorPoint = rectangularSelection.topRight;
          minDistance = topRightDistance;
        }

        // Check the right center anchor
        final rightCenterDistance = rectangularSelection.centerRight.distanceTo(point);
        if (rightCenterDistance < minDistance) {
          closestAnchor = ResizeAnchor.centerRight;
          closestAnchorPoint = rectangularSelection.centerRight;
          minDistance = rightCenterDistance;
        }

        // Check the bottom right anchor
        final bottomRightDistance = rectangularSelection.bottomRight.distanceTo(point);
        if (bottomRightDistance < minDistance) {
          closestAnchor = ResizeAnchor.bottomRight;
          closestAnchorPoint = rectangularSelection.bottomRight;
          minDistance = bottomRightDistance;
        }

        // Check the bottom center anchor
        final bottomCenterDistance = rectangularSelection.bottomCenter.distanceTo(point);
        if (bottomCenterDistance < minDistance) {
          closestAnchor = ResizeAnchor.bottomCenter;
          closestAnchorPoint = rectangularSelection.bottomCenter;
          minDistance = bottomCenterDistance;
        }

        // Check the bottom left anchor
        final bottomLeftDistance = rectangularSelection.bottomLeft.distanceTo(point);
        if (bottomLeftDistance < minDistance) {
          closestAnchor = ResizeAnchor.bottomLeft;
          closestAnchorPoint = rectangularSelection.bottomLeft;
          minDistance = bottomLeftDistance;
        }

        // Check the left center anchor
        final leftCenterDistance = rectangularSelection.centerLeft.distanceTo(point);
        if (leftCenterDistance < minDistance) {
          closestAnchor = ResizeAnchor.centerLeft;
          closestAnchorPoint = rectangularSelection.centerLeft;
          minDistance = leftCenterDistance;
        }

        final hasTappedOnAnchor = !isPointToPointDistanceEnoughFromPointerKind(
          closestAnchorPoint,
          point,
          state.scaleFactor,
          event.kind,
          tolerance: kBaseResizeRectAnchorRadius / state.scaleFactor,
        );

        if (!hasTappedOnAnchor) {
          _interactionState.initialize();
          return false;
        }

        // The user has tapped on an anchor

        // Save interaction point and anchor for the next resize event
        _interactionState.interactionPoint = point;
        _interactionState.anchor = closestAnchor;

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

        // If the state is not valid then the interaction can't be executed
        if (!isStateValid(state) || !_interactionState.hasData) {
          _interactionState.initialize();
          return false;
        }

        // The state is valid and the interaction state has data
        state as SelectedState<T, BoardStateConfig>;

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        // Calculate the delta between the two interaction points
        Point delta = point - _interactionState.interactionPoint!;

        // Resize all the selected drawings
        final updatedSelectedDrawings = state.selectedDrawings
            .map(
              (drawing) => drawing.resize(
                state,
                state.rectangularSelection,
                _interactionState.anchor!,
                delta,
              ),
            )
            .toList();

        // Resize selected drawings bounds
        final updatedSelectedDrawingsBounds = state.selectedDrawingsBounds.inflateAnchorPoint(_interactionState.anchor!, delta);

        // Set the flag that the selection has been resized
        _interactionState.hasResizedSelection = true;

        // Save interaction point for the next resize event
        _interactionState.interactionPoint = point;

        final updatedState = state.copyWith(
          selectedDrawings: updatedSelectedDrawings,
          selectedDrawingsBounds: updatedSelectedDrawingsBounds,
        );

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

        // If the state is not valid then the interaction can't be executed
        if (!isStateValid(state) || !_interactionState.hasData) {
          _interactionState.initialize();
          return false;
        }

        // The state is valid and the interaction state has data
        state as SelectedState<T, BoardStateConfig>;

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
        final state = notifier.value;

        // If the state is not valid then the interaction can't be executed
        if (!isStateValid(state) || !_interactionState.hasData) {
          _interactionState.initialize();
          return false;
        }

        // The state is valid and the interaction state has data
        state as SelectedState<T, BoardStateConfig>;

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
        final state = notifier.value;

        // If the state is not valid then the interaction can't be executed
        if (!isStateValid(state) || !_interactionState.hasData) {
          _interactionState.initialize();
          return false;
        }

        // The state is valid and the interaction state has data
        state as SelectedState<T, BoardStateConfig>;

        final updatedStateDetails = _handleInteractionEnd(state, event, notifier.config);

        notifier.setBoardState(
          state: updatedStateDetails.state,
          shouldAddToHistory: updatedStateDetails.shouldAddToHistory,
        );

        return true;
      };

  ({BoardState<T, BoardStateConfig> state, bool shouldAddToHistory}) _handleInteractionEnd(
    SelectedState<T, BoardStateConfig> state,
    PointerEvent event,
    BoardStateConfig config,
  ) {
    // Actual implementation of the pointer up event
    var updatedState = _updateSketch(state, config);

    final hasResizedSelection = _interactionState.hasResizedSelection;

    // Reset the interaction state
    _interactionState.initialize();

    // Add to undo history only if the selection has been moved
    if (hasResizedSelection) {
      return (state: updatedState, shouldAddToHistory: true);
    } else {
      return (state: updatedState, shouldAddToHistory: false);
    }
  }

  SelectedState<T, BoardStateConfig> _updateSketch(
    SelectedState<T, BoardStateConfig> state,
    BoardStateConfig config,
  ) {
    if (!_interactionState.hasResizedSelection) return state;

    // The user has resized the selection

    // Finalize the movement of the selected drawings
    late final SketchDelta<T> delta;
    if (config.shouldMoveSelectedDrawingsOnTop) {
      delta = SketchDelta(
        version: state.sketchDelta.version + 1,
        newDrawings: const [],
        updatedDrawingsBefore: state.previousSelectedDrawings,
        // TODO: Check if is updatedDrawings or newDrawings
        updatedDrawingsAfter: state.selectedDrawings,
        deletedDrawings: state.selectedDrawings,
      );
    } else {
      delta = SketchDelta.update(
        state.previousSelectedDrawings,
        state.selectedDrawings,
        state.sketchDelta.version + 1,
      );
    }

    return state.copyWith(
      previousSelectedDrawings: state.selectedDrawings,
      sketchDelta: delta,
    );
  }
}
