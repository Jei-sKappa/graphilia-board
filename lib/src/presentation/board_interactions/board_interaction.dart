import 'package:graphilia_board/graphilia_board.dart';

abstract class BoardInteraction<T> {
  const BoardInteraction();

  /// Triggered when the interaction is removed from the available interactions
  void onRemoved(BoardNotifier<T> notifier) {}

  // MOUSE REGION EVENT HANDLERS

  PointerExitEventListenerHandler<T>? get handlePointerExitEvent => null;

  // LISTENER EVENT HANDLERS

  PointerHoverEventListenerHandler<T>? get handlePointerHoverEvent => null;

  PointerDownEventListenerHandler<T>? get handlePointerDownEvent => null;

  PointerMoveEventListenerHandler<T>? get handlePointerMoveEvent => null;

  PointerUpEventListenerHandler<T>? get handlePointerUpEvent => null;

  PointerCancelEventListenerHandler<T>? get handlePointerCancelEvent => null;

  PointerPanZoomStartEventListenerHandler<T>? get handlePointerPanZoomStartEvent => null;

  PointerPanZoomUpdateEventListenerHandler<T>? get handlePointerPanZoomUpdateEvent => null;

  PointerPanZoomEndEventListenerHandler<T>? get handlePointerPanZoomEndEvent => null;

  PointerSignalEventListenerHandler<T>? get handlePointerSignalEvent => null;

  // DETAILED GESTURE DETECTOR EVENT HANDLERS

  DetailedGestureTapUpCallbackHandler<T>? get handleOnTapUp => null;

  DetailedGestureTapDownCallbackHandler<T>? get handleOnTapDown => null;

  DetailedGestureTapCallbackHandler<T>? get handleOnTap => null;

  DetailedGestureTapCancelCallbackHandler<T>? get handleOnTapCancel => null;

  DetailedGestureTapCallbackHandler<T>? get handleOnSecondaryTap => null;

  DetailedGestureTapDownCallbackHandler<T>? get handleOnSecondaryTapDown => null;

  DetailedGestureTapUpCallbackHandler<T>? get handleOnSecondaryTapUp => null;

  DetailedGestureTapCancelCallbackHandler<T>? get handleOnSecondaryTapCancel => null;

  DetailedGestureTapDownCallbackHandler<T>? get handleOnTertiaryTapDown => null;

  DetailedGestureTapUpCallbackHandler<T>? get handleOnTertiaryTapUp => null;

  DetailedGestureTapCancelCallbackHandler<T>? get handleOnTertiaryTapCancel => null;

  DetailedGestureDoubleTapDownCallbackHandler<T>? get handleOnDoubleTapDown => null;

  DetailedGestureDoubleTapCallbackHandler<T>? get handleOnDoubleTap => null;

  DetailedGestureDoubleTapCancelCallbackHandler<T>? get handleOnDoubleTapCancel => null;

  DetailedGestureLongPressDownCallbackHandler<T>? get handleOnLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler<T>? get handleOnLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler<T>? get handleOnLongPress => null;

  DetailedGestureLongPressStartCallbackHandler<T>? get handleOnLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler<T>? get handleOnLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler<T>? get handleOnLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler<T>? get handleOnLongPressEnd => null;

  DetailedGestureLongPressDownCallbackHandler<T>? get handleOnSecondaryLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler<T>? get handleOnSecondaryLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler<T>? get handleOnSecondaryLongPress => null;

  DetailedGestureLongPressStartCallbackHandler<T>? get handleOnSecondaryLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler<T>? get handleOnSecondaryLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler<T>? get handleOnSecondaryLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler<T>? get handleOnSecondaryLongPressEnd => null;

  DetailedGestureLongPressDownCallbackHandler<T>? get handleOnTertiaryLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler<T>? get handleOnTertiaryLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler<T>? get handleOnTertiaryLongPress => null;

  DetailedGestureLongPressStartCallbackHandler<T>? get handleOnTertiaryLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler<T>? get handleOnTertiaryLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler<T>? get handleOnTertiaryLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler<T>? get handleOnTertiaryLongPressEnd => null;

  DetailedGestureDragDownCallbackHandler<T>? get handleOnVerticalDragDown => null;

  DetailedGestureDragStartCallbackHandler<T>? get handleOnVerticalDragStart => null;

  DetailedGestureDragUpdateCallbackHandler<T>? get handleOnVerticalDragUpdate => null;

  DetailedGestureDragEndCallbackHandler<T>? get handleOnVerticalDragEnd => null;

  DetailedGestureDragCancelCallbackHandler<T>? get handleOnVerticalDragCancel => null;

  DetailedGestureDragDownCallbackHandler<T>? get handleOnHorizontalDragDown => null;

  DetailedGestureDragStartCallbackHandler<T>? get handleOnHorizontalDragStart => null;

  DetailedGestureDragUpdateCallbackHandler<T>? get handleOnHorizontalDragUpdate => null;

  DetailedGestureDragEndCallbackHandler<T>? get handleOnHorizontalDragEnd => null;

  DetailedGestureDragCancelCallbackHandler<T>? get handleOnHorizontalDragCancel => null;

  DetailedGestureDragDownCallbackHandler<T>? get handleOnPanDown => null;

  DetailedGestureDragStartCallbackHandler<T>? get handleOnPanStart => null;

  DetailedGestureDragUpdateCallbackHandler<T>? get handleOnPanUpdate => null;

  DetailedGestureDragEndCallbackHandler<T>? get handleOnPanEnd => null;

  DetailedGestureDragCancelCallbackHandler<T>? get handleOnPanCancel => null;

  DetailedGestureScaleStartCallbackHandler<T>? get handleOnScaleStart => null;

  DetailedGestureScaleUpdateCallbackHandler<T>? get handleOnScaleUpdate => null;

  DetailedGestureScaleEndCallbackHandler<T>? get handleOnScaleEnd => null;

  DetailedGestureForcePressStartCallbackHandler<T>? get handleOnForcePressStart => null;

  DetailedGestureForcePressPeakCallbackHandler<T>? get handleOnForcePressPeak => null;

  DetailedGestureForcePressUpdateCallbackHandler<T>? get handleOnForcePressUpdate => null;

  DetailedGestureForcePressEndCallbackHandler<T>? get handleOnForcePressEnd => null;
}
