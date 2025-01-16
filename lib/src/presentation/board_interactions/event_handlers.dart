import 'package:flutter/gestures.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';

// MOUSE REGION EVENT HANDLERS

typedef PointerExitEventListenerHandler<T> = bool Function(
  PointerExitEvent event,
  BoardNotifier<T> notifier,
);

// LISTENER EVENT HANDLERS

typedef PointerHoverEventListenerHandler<T> = bool Function(
  PointerHoverEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerDownEventListenerHandler<T> = bool Function(
  PointerDownEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerMoveEventListenerHandler<T> = bool Function(
  PointerMoveEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerUpEventListenerHandler<T> = bool Function(
  PointerUpEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerCancelEventListenerHandler<T> = bool Function(
  PointerCancelEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerPanZoomStartEventListenerHandler<T> = bool Function(
  PointerPanZoomStartEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerPanZoomUpdateEventListenerHandler<T> = bool Function(
  PointerPanZoomUpdateEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerPanZoomEndEventListenerHandler<T> = bool Function(
  PointerPanZoomEndEvent event,
  BoardNotifier<T> notifier,
);

typedef PointerSignalEventListenerHandler<T> = bool Function(
  PointerSignalEvent event,
  BoardNotifier<T> notifier,
);

// DETAILED GESTURE DETECTOR EVENT HANDLERS

typedef DetailedGestureTapDownCallbackHandler<T> = bool Function(
  TapDownDetails details,
  PointerDownEvent pointerDownEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureTapUpCallbackHandler<T> = bool Function(
  TapUpDetails details,
  PointerDownEvent pointerDownEvent,
  PointerUpEvent pointerUpEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureTapCallbackHandler<T> = bool Function(
  PointerDownEvent pointerDownEvent,
  PointerUpEvent pointerUpEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureTapCancelCallbackHandler<T> = bool Function(
  PointerDownEvent pointerDownEvent,
  PointerCancelEvent? cancelEvent,
  String reason,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDoubleTapDownCallbackHandler<T> = bool Function(
  TapDownDetails details,
  PointerEvent firstEvent,
  PointerDownEvent secondEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDoubleTapCallbackHandler<T> = bool Function(
  PointerEvent firstEvent,
  PointerEvent secondEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDoubleTapCancelCallbackHandler<T> = bool Function(
  PointerEvent firstEvent,
  PointerEvent? cancelEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressDownCallbackHandler<T> = bool Function(
  LongPressDownDetails details,
  PointerDownEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressCancelCallbackHandler<T> = bool Function(
  PointerDownEvent firstEvent,
  PointerCancelEvent? event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressCallbackHandler<T> = bool Function(
  PointerDownEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressStartCallbackHandler<T> = bool Function(
  LongPressStartDetails details,
  PointerDownEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressMoveUpdateCallbackHandler<T> = bool Function(
  LongPressMoveUpdateDetails details,
  PointerDownEvent initialEvent,
  PointerMoveEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressUpCallbackHandler<T> = bool Function(
  PointerDownEvent initialEvent,
  PointerUpEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureLongPressEndCallbackHandler<T> = bool Function(
  LongPressEndDetails details,
  PointerDownEvent initialEvent,
  PointerUpEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDragDownCallbackHandler<T> = bool Function(
  DragDownDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDragStartCallbackHandler<T> = bool Function(
  DragStartDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDragUpdateCallbackHandler<T> = bool Function(
  DragUpdateDetails details,
  PointerEvent initialEvent,
  PointerEvent? event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDragEndCallbackHandler<T> = bool Function(
  DragEndDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureDragCancelCallbackHandler<T> = bool Function(
  PointerEvent initialEvent,
  PointerEvent finalEvent,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureScaleStartCallbackHandler<T> = bool Function(
  ScaleStartDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureScaleUpdateCallbackHandler<T> = bool Function(
  ScaleUpdateDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureScaleEndCallbackHandler<T> = bool Function(
  ScaleEndDetails details,
  PointerEvent initialEvent,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureForcePressStartCallbackHandler<T> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureForcePressPeakCallbackHandler<T> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureForcePressUpdateCallbackHandler<T> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);

typedef DetailedGestureForcePressEndCallbackHandler<T> = bool Function(
  ForcePressDetails details,
  PointerEvent event,
  BoardNotifier<T> notifier,
);
