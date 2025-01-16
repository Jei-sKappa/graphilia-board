import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:graphilia_board/graphilia_board.dart';

class _MovingSelectionState {
  _MovingSelectionState() {
    initialize();
  }

  late Point? interactionPoint;
  late bool hasMovedSelection;

  void initialize() {
    interactionPoint = null;
    hasMovedSelection = false;
  }
}

class MoveSelectionInteraction<T> extends BoardInteraction<T> {
  MoveSelectionInteraction() : _interactionState = _MovingSelectionState();

  final _MovingSelectionState _interactionState;

  @override
  DetailedGestureScaleStartCallbackHandler<T> get handleOnScaleStart => (
        ScaleStartDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T> notifier,
      ) {
        final state = notifier.value;

        if (state is! SelectedState<T>) return false;

        // The state is [SelectedState]

        // If there are no selected drawings or the point is not inside the
        // selection points, then the move interaction can't be executed
        if (state.selectedDrawings.isEmpty || state.selectionPoints.isEmpty) {
          return false;
        }

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        late final bool isInsideSelectionPoints;
        if (state.displayRectangularSelection) {
          isInsideSelectionPoints = state.rectangularSelection.contains(point);
        } else {
          final path = Path();
          path.moveTo(
            state.selectionPoints.first.x,
            state.selectionPoints.first.y,
          );
          for (var i = 1; i < state.selectionPoints.length; i++) {
            path.lineTo(
              state.selectionPoints[i].x,
              state.selectionPoints[i].y,
            );
          }

          isInsideSelectionPoints = path.contains(point);
        }

        if (!isInsideSelectionPoints) return false;

        // Save interaction point for the next move event
        _interactionState.interactionPoint = point;

        return true;
      };

  @override
  DetailedGestureScaleUpdateCallbackHandler<T> get handleOnScaleUpdate => (
        ScaleUpdateDetails details,
        PointerEvent initialEvent,
        PointerEvent event,
        BoardNotifier<T> notifier,
      ) {
        final state = notifier.value;

        // If the state is not [SelectedState], or the interactionPoint is null
        // then the interaction can't be executed
        if (state is! SelectedState<T> || _interactionState.interactionPoint == null) {
          _interactionState.initialize();
          return false;
        }

        // The state is [SelectedState] and the interactionPoint is not null

        final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

        // Calculate the delta between the two interaction points
        Point offset = point - _interactionState.interactionPoint!;

        final updatedSelectionPoints = state.selectionPoints.map((p) => p + offset).toList();

        final updatedSelectionRect = state.selectionRect.shift(offset);

        final updatedSelectedDrawings = state.selectedDrawings.map((d) => d.move(state, offset)).toList();

        // Move selected drawings bounds
        final updatedSelectedDrawingsBounds = state.selectedDrawingsBounds.shift(offset);

        // Set the flag that the selection has been moved
        _interactionState.hasMovedSelection = true;

        // Save interaction point for the next move event
        _interactionState.interactionPoint = point;

        final updatedState = state.copyWith(
          selectionPoints: updatedSelectionPoints,
          selectionRect: updatedSelectionRect,
          // Here we must not update `previousSelectedDrawings`
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
        BoardNotifier<T> notifier,
      ) {
        final state = notifier.value;

        // If the state is not [SelectedState], or the interactionPoint is null
        // then the interaction can't be executed
        if (state is! SelectedState<T> || _interactionState.interactionPoint == null) {
          _interactionState.initialize();
          return false;
        }

        // The state is [SelectedState]

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
        final state = notifier.value;

        // If the state is not [SelectedState], or the interactionPoint is null
        // then the interaction can't be executed
        if (state is! SelectedState<T> || _interactionState.interactionPoint == null) {
          _interactionState.initialize();
          return false;
        }

        // The state is [SelectedState]

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
        final state = notifier.value;

        // If the state is not [SelectedState], or the interactionPoint is null
        // then the interaction can't be executed
        if (state is! SelectedState<T> || _interactionState.interactionPoint == null) {
          _interactionState.initialize();
          return false;
        }

        // The state is [SelectedState]

        final updatedStateDetails = _handleInteractionEnd(state, event, notifier.config);

        notifier.setBoardState(
          state: updatedStateDetails.state,
          shouldAddToHistory: updatedStateDetails.shouldAddToHistory,
        );

        return true;
      };

  ({BoardState<T> state, bool shouldAddToHistory}) _handleInteractionEnd(
    SelectedState<T> state,
    PointerEvent event,
    BoardStateConfig config,
  ) {
    // Actual implementation of the pointer up event
    var updatedState = _updateSketch(state, config);

    final hasMovedSelection = _interactionState.hasMovedSelection;

    // Reset the interaction state
    _interactionState.initialize();

    // Add to undo history only if the selection has been moved
    if (hasMovedSelection) {
      return (state: updatedState, shouldAddToHistory: true);
    } else {
      return (state: updatedState, shouldAddToHistory: false);
    }
  }

  SelectedState<T> _updateSketch(
    SelectedState<T> state,
    BoardStateConfig config,
  ) {
    if (!_interactionState.hasMovedSelection) return state;

    // The user has moved the selection

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
