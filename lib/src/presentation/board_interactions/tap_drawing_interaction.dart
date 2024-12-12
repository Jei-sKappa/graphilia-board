import 'package:flutter/gestures.dart';
import 'package:graphilia_board/graphilia_board.dart';

class _TapDrawingState {
  _TapDrawingState() {
    initialize();
  }

  late List<Point> strokePoints;

  void initialize() {
    strokePoints = [];
  }
}

class TapDrawingInteraction extends BoardInteraction {
  TapDrawingInteraction({
    this.handleTapWithScaleGestures = false,
  }) : _interactionState = _TapDrawingState();

  final bool handleTapWithScaleGestures;

  final _TapDrawingState _interactionState;

  @override
  DetailedGestureTapDownCallbackHandler? get handleOnTapDown {
    if (handleTapWithScaleGestures) return null;

    return (
      TapDownDetails details,
      PointerDownEvent pointerDownEvent,
      BoardNotifier notifier,
    ) =>
        _handleTapDownEvent(notifier, pointerDownEvent);
  }

  @override
  DetailedGestureTapUpCallbackHandler? get handleOnTapUp {
    if (handleTapWithScaleGestures) return null;

    return (
      TapUpDetails details,
      PointerDownEvent pointerDownEvent,
      PointerUpEvent pointerUpEvent,
      BoardNotifier notifier,
    ) =>
        _handleTapUpEvent(notifier, pointerUpEvent);
  }

  @override
  DetailedGestureScaleStartCallbackHandler? get handleOnScaleStart {
    if (!handleTapWithScaleGestures) return null;

    return (
      ScaleStartDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier notifier,
    ) {
      // Initialize the interaction state
      _interactionState.initialize();

      final state = notifier.value;

      // Update stroke points
      final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);
      _interactionState.strokePoints = [point];

      return _handleTapDownEvent(notifier, event);
    };
  }

  @override
  DetailedGestureScaleUpdateCallbackHandler get handleOnScaleUpdate {
    return (
      ScaleUpdateDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier notifier,
    ) {
      final state = notifier.value;

      // Update stroke points
      final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);
      _interactionState.strokePoints = [
        ..._interactionState.strokePoints,
        point,
      ];

      // Do not interrupt other interactions
      return false;
    };
  }

  @override
  DetailedGestureScaleEndCallbackHandler? get handleOnScaleEnd {
    if (!handleTapWithScaleGestures) return null;

    return (
      ScaleEndDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier notifier,
    ) {
      final state = notifier.value;

      late bool handled;

      // Check if the scale gesture can be considered as a tap up gesture
      bool isTapUpGesture = canPointerEventBeConsideredTapUpGesture(event, state, notifier.config);
      if (!isTapUpGesture) {
        handled = false;
      } else {
        handled = _handleTapUpEvent(notifier, event);
      }

      // Clear the stroke points
      _interactionState.strokePoints.clear();

      return handled;
    };
  }

  bool _handleTapDownEvent(BoardNotifier notifier, PointerEvent event) {
    final state = notifier.value;

    final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

    final handlers = [
      (Drawing drawing, BoardState s) => drawing.onTapDown(s, event),
      if (notifier.config.onTapDown != null) (Drawing drawing, BoardState s) => notifier.config.onTapDown!(event, s, drawing),
    ];

    final details = _handleTapEvent(state, point, handlers, notifier.config);

    if (details == null) return false;

    notifier.setBoardState(
      state: details.state,
      shouldAddToHistory: details.shouldAddToHistory,
    );

    return true;
  }

  bool _handleTapUpEvent(BoardNotifier notifier, PointerEvent event) {
    final state = notifier.value;

    final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

    final handlers = [
      (Drawing drawing, BoardState s) => drawing.onTapUp(s, event),
      if (notifier.config.onTapUp != null) (Drawing drawing, BoardState s) => notifier.config.onTapUp!(event, s, drawing),
    ];

    final details = _handleTapEvent(state, point, handlers, notifier.config);

    if (details == null) return false;

    notifier.setBoardState(
      state: details.state,
      shouldAddToHistory: details.shouldAddToHistory,
    );

    return true;
  }

  ({BoardState state, bool shouldAddToHistory})? _handleTapEvent(
    BoardState state,
    Point tapPoint,
    List<EventResult<UpdatedSketchDetails> Function(Drawing, BoardState)> tapEventHandlers,
    BoardStateConfig config,
  ) {
    final tappedDrawings = state.sketch.getDrawingsByPoint(
      state,
      tapPoint,
      // TODO: Use Flutter's default tolerance for thumbs or mouse pointers (flutter/lib/gestures/constants.dart)
      tolerance: 10 / state.scaleFactor,
      simulatePressure: config.simulatePressure,
    );

    BoardState stateCopy = state;
    bool handled = false;
    bool shouldAddToUndoHistory = false;
    for (final drawing in tappedDrawings) {
      for (final tapEventHandler in tapEventHandlers) {
        final eventResult = tapEventHandler(drawing, stateCopy);

        if (eventResult.handled) {
          handled = true;
          if (eventResult.result != null) {
            stateCopy = stateCopy.copyWith(sketchDelta: eventResult.result!.sketchDelta);
            shouldAddToUndoHistory = shouldAddToUndoHistory || eventResult.result!.shouldAddToUndoHistory;
          }
        }

        if (eventResult.skipRemainingHandlers) {
          break;
        }
      }
    }

    if (handled) {
      return (state: stateCopy, shouldAddToHistory: shouldAddToUndoHistory);
    }

    return null;
  }

  bool canPointerEventBeConsideredTapUpGesture(
    PointerEvent event,
    BoardState state,
    BoardStateConfig config,
  ) {
    // If the strokePoints are less than or equal to 1, then it is a tap up
    // gesture
    if (_interactionState.strokePoints.length <= 1) return true;

    // Given a [PointerDeviceKind], determine if the number of points can
    // already be a sign of NOT a tap up gesture
    if (BoardPointersHelper.allStyluses.contains(event.kind)) {
      if (_interactionState.strokePoints.length >= 24) {
        return false;
      }
    } else if (BoardPointersHelper.mouse.contains(event.kind)) {
      // TODO: Fine tune the threshold for mouse devices
      if (_interactionState.strokePoints.length >= 3) {
        return false;
      }
    } else if (BoardPointersHelper.touch.contains(event.kind)) {
      // TODO: Fine tune the threshold for touch devices
      if (_interactionState.strokePoints.length >= 5) {
        return false;
      }
    }

    // If the strokePoints are more than 1, then we need to check if the
    // distance between the first stroke point and the current pointer position
    // is less than or equal to the threshold
    final point = event.getPoint(config.pointPressureCurve).relativeToVisibleArea(state);
    final isTapUpGesture = !isPointToPointDistanceEnoughFromPointerKind(
      _interactionState.strokePoints.first,
      point,
      state.scaleFactor,
      event.kind,
    );
    return isTapUpGesture;
  }
}
