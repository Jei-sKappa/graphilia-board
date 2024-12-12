import 'package:flutter/gestures.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

// MOUSE REGION EVENT HANDLERS

typedef PointerExitEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerExitEvent event,
  BoardNotifier notifier,
);

// LISTENER EVENT HANDLERS

typedef PointerHoverEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerHoverEvent event,
  BoardNotifier notifier,
);

typedef PointerDownEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent event,
  BoardNotifier notifier,
);

typedef PointerMoveEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerMoveEvent event,
  BoardNotifier notifier,
);

typedef PointerUpEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerUpEvent event,
  BoardNotifier notifier,
);

typedef PointerCancelEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerCancelEvent event,
  BoardNotifier notifier,
);

typedef PointerPanZoomStartEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerPanZoomStartEvent event,
  BoardNotifier notifier,
);

typedef PointerPanZoomUpdateEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerPanZoomUpdateEvent event,
  BoardNotifier notifier,
);

typedef PointerPanZoomEndEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerPanZoomEndEvent event,
  BoardNotifier notifier,
);

typedef PointerSignalEventListenerHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerSignalEvent event,
  BoardNotifier notifier,
);

// DETAILED GESTURE DETECTOR EVENT HANDLERS

typedef DetailedGestureTapDownCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  TapDownDetails details,
  PointerDownEvent pointerDownEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureTapUpCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  TapUpDetails details,
  PointerDownEvent pointerDownEvent,
  PointerUpEvent pointerUpEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureTapCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent pointerDownEvent,
  PointerUpEvent pointerUpEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureTapCancelCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent pointerDownEvent,
  PointerCancelEvent? cancelEvent,
  String reason,
  BoardNotifier notifier,
);

typedef DetailedGestureDoubleTapDownCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  TapDownDetails details,
  PointerEvent firstEvent,
  PointerDownEvent secondEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureDoubleTapCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerEvent firstEvent,
  PointerEvent secondEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureDoubleTapCancelCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerEvent firstEvent,
  PointerEvent? cancelEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressDownCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  LongPressDownDetails details,
  PointerDownEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressCancelCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent firstEvent,
  PointerCancelEvent? event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressStartCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  LongPressStartDetails details,
  PointerDownEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressMoveUpdateCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  LongPressMoveUpdateDetails details,
  PointerDownEvent initialEvent,
  PointerMoveEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressUpCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerDownEvent initialEvent,
  PointerUpEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureLongPressEndCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  LongPressEndDetails details,
  PointerDownEvent initialEvent,
  PointerUpEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureDragDownCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  DragDownDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureDragStartCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  DragStartDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureDragUpdateCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  DragUpdateDetails details,
  PointerEvent initialEvent,
  PointerEvent? event,
  BoardNotifier notifier,
);

typedef DetailedGestureDragEndCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  DragEndDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureDragCancelCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  PointerEvent initialEvent,
  PointerEvent finalEvent,
  BoardNotifier notifier,
);

typedef DetailedGestureScaleStartCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ScaleStartDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureScaleUpdateCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ScaleUpdateDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureScaleEndCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ScaleEndDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureForcePressStartCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureForcePressPeakCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureForcePressUpdateCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);

typedef DetailedGestureForcePressEndCallbackHandler<S extends BoardState, C extends BoardStateConfig> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier notifier,
);
