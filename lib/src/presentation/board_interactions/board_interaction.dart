import 'package:flutter/widgets.dart';
import 'package:graphilia_board/graphilia_board.dart';

// TODO: This should go in a separate file/packagea
typedef CanvasPaintCallback = void Function(Canvas);

abstract class BoardInteraction {
  const BoardInteraction();

  /// Triggered when the interaction is removed from the available interactions
  void onRemoved(BoardNotifier notifier) {}

  // MOUSE REGION EVENT HANDLERS

  PointerExitEventListenerHandler? get handlePointerExitEvent => null;

  // LISTENER EVENT HANDLERS

  PointerHoverEventListenerHandler? get handlePointerHoverEvent => null;

  PointerDownEventListenerHandler? get handlePointerDownEvent => null;

  PointerMoveEventListenerHandler? get handlePointerMoveEvent => null;

  PointerUpEventListenerHandler? get handlePointerUpEvent => null;

  PointerCancelEventListenerHandler? get handlePointerCancelEvent => null;

  PointerPanZoomStartEventListenerHandler? get handlePointerPanZoomStartEvent => null;

  PointerPanZoomUpdateEventListenerHandler? get handlePointerPanZoomUpdateEvent => null;

  PointerPanZoomEndEventListenerHandler? get handlePointerPanZoomEndEvent => null;

  PointerSignalEventListenerHandler? get handlePointerSignalEvent => null;

  // DETAILED GESTURE DETECTOR EVENT HANDLERS

  DetailedGestureTapUpCallbackHandler? get handleOnTapUp => null;

  DetailedGestureTapDownCallbackHandler? get handleOnTapDown => null;

  DetailedGestureTapCallbackHandler? get handleOnTap => null;

  DetailedGestureTapCancelCallbackHandler? get handleOnTapCancel => null;

  DetailedGestureTapCallbackHandler? get handleOnSecondaryTap => null;

  DetailedGestureTapDownCallbackHandler? get handleOnSecondaryTapDown => null;

  DetailedGestureTapUpCallbackHandler? get handleOnSecondaryTapUp => null;

  DetailedGestureTapCancelCallbackHandler? get handleOnSecondaryTapCancel => null;

  DetailedGestureTapDownCallbackHandler? get handleOnTertiaryTapDown => null;

  DetailedGestureTapUpCallbackHandler? get handleOnTertiaryTapUp => null;

  DetailedGestureTapCancelCallbackHandler? get handleOnTertiaryTapCancel => null;

  DetailedGestureDoubleTapDownCallbackHandler? get handleOnDoubleTapDown => null;

  DetailedGestureDoubleTapCallbackHandler? get handleOnDoubleTap => null;

  DetailedGestureDoubleTapCancelCallbackHandler? get handleOnDoubleTapCancel => null;

  DetailedGestureLongPressDownCallbackHandler? get handleOnLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler? get handleOnLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler? get handleOnLongPress => null;

  DetailedGestureLongPressStartCallbackHandler? get handleOnLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler? get handleOnLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler? get handleOnLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler? get handleOnLongPressEnd => null;

  DetailedGestureLongPressDownCallbackHandler? get handleOnSecondaryLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler? get handleOnSecondaryLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler? get handleOnSecondaryLongPress => null;

  DetailedGestureLongPressStartCallbackHandler? get handleOnSecondaryLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler? get handleOnSecondaryLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler? get handleOnSecondaryLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler? get handleOnSecondaryLongPressEnd => null;

  DetailedGestureLongPressDownCallbackHandler? get handleOnTertiaryLongPressDown => null;

  DetailedGestureLongPressCancelCallbackHandler? get handleOnTertiaryLongPressCancel => null;

  DetailedGestureLongPressCallbackHandler? get handleOnTertiaryLongPress => null;

  DetailedGestureLongPressStartCallbackHandler? get handleOnTertiaryLongPressStart => null;

  DetailedGestureLongPressMoveUpdateCallbackHandler? get handleOnTertiaryLongPressMoveUpdate => null;

  DetailedGestureLongPressUpCallbackHandler? get handleOnTertiaryLongPressUp => null;

  DetailedGestureLongPressEndCallbackHandler? get handleOnTertiaryLongPressEnd => null;

  DetailedGestureDragDownCallbackHandler? get handleOnVerticalDragDown => null;

  DetailedGestureDragStartCallbackHandler? get handleOnVerticalDragStart => null;

  DetailedGestureDragUpdateCallbackHandler? get handleOnVerticalDragUpdate => null;

  DetailedGestureDragEndCallbackHandler? get handleOnVerticalDragEnd => null;

  DetailedGestureDragCancelCallbackHandler? get handleOnVerticalDragCancel => null;

  DetailedGestureDragDownCallbackHandler? get handleOnHorizontalDragDown => null;

  DetailedGestureDragStartCallbackHandler? get handleOnHorizontalDragStart => null;

  DetailedGestureDragUpdateCallbackHandler? get handleOnHorizontalDragUpdate => null;

  DetailedGestureDragEndCallbackHandler? get handleOnHorizontalDragEnd => null;

  DetailedGestureDragCancelCallbackHandler? get handleOnHorizontalDragCancel => null;

  DetailedGestureDragDownCallbackHandler? get handleOnPanDown => null;

  DetailedGestureDragStartCallbackHandler? get handleOnPanStart => null;

  DetailedGestureDragUpdateCallbackHandler? get handleOnPanUpdate => null;

  DetailedGestureDragEndCallbackHandler? get handleOnPanEnd => null;

  DetailedGestureDragCancelCallbackHandler? get handleOnPanCancel => null;

  DetailedGestureScaleStartCallbackHandler? get handleOnScaleStart => null;

  DetailedGestureScaleUpdateCallbackHandler? get handleOnScaleUpdate => null;

  DetailedGestureScaleEndCallbackHandler? get handleOnScaleEnd => null;

  DetailedGestureForcePressStartCallbackHandler? get handleOnForcePressStart => null;

  DetailedGestureForcePressPeakCallbackHandler? get handleOnForcePressPeak => null;

  DetailedGestureForcePressUpdateCallbackHandler? get handleOnForcePressUpdate => null;

  DetailedGestureForcePressEndCallbackHandler? get handleOnForcePressEnd => null;
}
