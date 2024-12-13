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

class TapDrawingInteraction<T> extends BoardInteraction<T> {
  TapDrawingInteraction({
    this.handleTapWithScaleGestures = false,
  }) : _interactionState = _TapDrawingState();

  final bool handleTapWithScaleGestures;

  final _TapDrawingState _interactionState;

  @override
  DetailedGestureTapDownCallbackHandler<T>? get handleOnTapDown {
    if (handleTapWithScaleGestures) return null;

    return (
      TapDownDetails details,
      PointerDownEvent pointerDownEvent,
      BoardNotifier<T, BoardStateConfig> notifier,
    ) =>
        _handleTapDownEvent(notifier, pointerDownEvent);
  }

  @override
  DetailedGestureTapUpCallbackHandler<T>? get handleOnTapUp {
    if (handleTapWithScaleGestures) return null;

    return (
      TapUpDetails details,
      PointerDownEvent pointerDownEvent,
      PointerUpEvent pointerUpEvent,
      BoardNotifier<T, BoardStateConfig> notifier,
    ) =>
        _handleTapUpEvent(notifier, pointerUpEvent);
  }

  @override
  DetailedGestureScaleStartCallbackHandler<T>? get handleOnScaleStart {
    if (!handleTapWithScaleGestures) return null;

    return (
      ScaleStartDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier<T, BoardStateConfig> notifier,
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
  DetailedGestureScaleUpdateCallbackHandler<T>? get handleOnScaleUpdate {
    if (!handleTapWithScaleGestures) return null;

    return (
      ScaleUpdateDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier<T, BoardStateConfig> notifier,
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
  DetailedGestureScaleEndCallbackHandler<T>? get handleOnScaleEnd {
    if (!handleTapWithScaleGestures) return null;

    return (
      ScaleEndDetails details,
      PointerEvent initialEvent,
      PointerEvent event,
      BoardNotifier<T, BoardStateConfig> notifier,
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

  bool _handleTapDownEvent(BoardNotifier<T, BoardStateConfig> notifier, PointerEvent event) {
    final state = notifier.value;

    final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

    final handlers = [
      (Drawing<T> drawing, BoardState<T, BoardStateConfig> s) => drawing.onTapDown(s, event),
      if (notifier.config.onTapDown != null) (Drawing<T> drawing, BoardState<T, BoardStateConfig> s) => notifier.config.onTapDown!(event, s, drawing),
    ];

    final details = _handleTapEvent(state, point, handlers, notifier.config);

    if (details == null) return false;

    notifier.setBoardState(
      state: details.state,
      shouldAddToHistory: details.shouldAddToHistory,
    );

    return true;
  }

  bool _handleTapUpEvent(BoardNotifier<T, BoardStateConfig> notifier, PointerEvent event) {
    final state = notifier.value;

    final point = event.getPoint(notifier.config.pointPressureCurve).relativeToVisibleArea(state);

    final handlers = [
      (Drawing<T> drawing, BoardState<T, BoardStateConfig> s) => drawing.onTapUp(s, event),
      if (notifier.config.onTapUp != null) (Drawing<T> drawing, BoardState<T, BoardStateConfig> s) => notifier.config.onTapUp!(event, s, drawing),
    ];

    final details = _handleTapEvent(state, point, handlers, notifier.config);

    if (details == null) return false;

    notifier.setBoardState(
      state: details.state,
      shouldAddToHistory: details.shouldAddToHistory,
    );

    return true;
  }

  ({BoardState<T, BoardStateConfig> state, bool shouldAddToHistory})? _handleTapEvent(
    BoardState<T, BoardStateConfig> state,
    Point tapPoint,
    List<EventResult<UpdatedSketchDetails<T>> Function(Drawing<T>, BoardState<T, BoardStateConfig>)> tapEventHandlers,
    BoardStateConfig config,
  ) {
    final tappedDrawings = state.sketch.getDrawingsByPoint(
      state,
      tapPoint,
      // TODO: Use Flutter's default tolerance for thumbs or mouse pointers (flutter/lib/gestures/constants.dart)
      tolerance: 10 / state.scaleFactor,
      simulatePressure: config.simulatePressure,
    );

    BoardState<T, BoardStateConfig> stateCopy = state;
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
    BoardState<T, BoardStateConfig> state,
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
