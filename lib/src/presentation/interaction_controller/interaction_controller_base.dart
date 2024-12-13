import 'package:detailed_gesture_detector/detailed_gesture_detector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:graphilia_board/graphilia_board.dart';

abstract class InteractionControllerBase<T> {
  InteractionControllerBase({
    Set<BoardInteraction<T>> graphiliaBoardInteractions = const {},
  }) : _graphiliaBoardInteractionsNotifier = ValueNotifier(graphiliaBoardInteractions);

  // TODO: Use a logging package
  void _log(String message) => debugPrint('log | InteractionControllerBase | $message');

  final ValueNotifier<Set<BoardInteraction<T>>> _graphiliaBoardInteractionsNotifier;

  ValueNotifier<Set<BoardInteraction<T>>> get graphiliaBoardInteractionsNotifier => _graphiliaBoardInteractionsNotifier;

  Set<BoardInteraction<T>> get graphiliaBoardInteractions => _graphiliaBoardInteractionsNotifier.value;

  void updateHandlers(Set<BoardInteraction<T>> value) {
    _log('updateHandlers: $value');
    _graphiliaBoardInteractionsNotifier.value = value;
  }

  // MOUSE REGION CALLBACKS

  /// Should be called when the pointer exits the canvas with the corresponding
  /// [event].
  PointerExitEventListener? get onPointerExit;

  // LISTENER CALLBACKS

  /// Should be called when the pointer hovers over the canvas with the
  /// corresponding [event].
  PointerHoverEventListener? get onPointerHover;

  /// Should be called when the pointer is pressed down on the canvas with the
  /// corresponding [event].
  PointerDownEventListener? get onPointerDown;

  /// Should be called when the pointer is moved on the canvas with the
  /// corresponding [event].
  PointerMoveEventListener? get onPointerMove;

  /// Should be called when the pointer is lifted from the canvas with the
  /// corresponding [event].
  PointerUpEventListener? get onPointerUp;

  /// Should be called when the pointer is canceled with the corresponding
  /// [event].
  PointerCancelEventListener? get onPointerCancel;

  PointerPanZoomStartEventListener? get onPointerPanZoomStart;

  PointerPanZoomUpdateEventListener? get onPointerPanZoomUpdate;

  PointerPanZoomEndEventListener? get onPointerPanZoomEnd;

  PointerSignalEventListener? get onPointerSignal;

  // DETAILED GESTURE DETECTOR CALLBACKS

  DetailedGestureTapDownCallback? get onTapDown;

  DetailedGestureTapUpCallback? get onTapUp;

  DetailedGestureTapCallback? get onTap;

  DetailedGestureTapCancelCallback? get onTapCancel;

  DetailedGestureTapCallback? get onSecondaryTap;

  DetailedGestureTapDownCallback? get onSecondaryTapDown;

  DetailedGestureTapUpCallback? get onSecondaryTapUp;

  DetailedGestureTapCancelCallback? get onSecondaryTapCancel;

  DetailedGestureTapDownCallback? get onTertiaryTapDown;

  DetailedGestureTapUpCallback? get onTertiaryTapUp;

  DetailedGestureTapCancelCallback? get onTertiaryTapCancel;

  DetailedGestureDoubleTapDownCallback? get onDoubleTapDown;

  DetailedGestureDoubleTapCallback? get onDoubleTap;

  DetailedGestureDoubleTapCancelCallback? get onDoubleTapCancel;

  DetailedGestureLongPressDownCallback? get onLongPressDown;

  DetailedGestureLongPressCancelCallback? get onLongPressCancel;

  DetailedGestureLongPressCallback? get onLongPress;

  DetailedGestureLongPressStartCallback? get onLongPressStart;

  DetailedGestureLongPressMoveUpdateCallback? get onLongPressMoveUpdate;

  DetailedGestureLongPressUpCallback? get onLongPressUp;

  DetailedGestureLongPressEndCallback? get onLongPressEnd;

  DetailedGestureLongPressDownCallback? get onSecondaryLongPressDown;

  DetailedGestureLongPressCancelCallback? get onSecondaryLongPressCancel;

  DetailedGestureLongPressCallback? get onSecondaryLongPress;

  DetailedGestureLongPressStartCallback? get onSecondaryLongPressStart;

  DetailedGestureLongPressMoveUpdateCallback? get onSecondaryLongPressMoveUpdate;

  DetailedGestureLongPressUpCallback? get onSecondaryLongPressUp;

  DetailedGestureLongPressEndCallback? get onSecondaryLongPressEnd;

  DetailedGestureLongPressDownCallback? get onTertiaryLongPressDown;

  DetailedGestureLongPressCancelCallback? get onTertiaryLongPressCancel;

  DetailedGestureLongPressCallback? get onTertiaryLongPress;

  DetailedGestureLongPressStartCallback? get onTertiaryLongPressStart;

  DetailedGestureLongPressMoveUpdateCallback? get onTertiaryLongPressMoveUpdate;

  DetailedGestureLongPressUpCallback? get onTertiaryLongPressUp;

  DetailedGestureLongPressEndCallback? get onTertiaryLongPressEnd;

  DetailedGestureDragDownCallback? get onVerticalDragDown;

  DetailedGestureDragStartCallback? get onVerticalDragStart;

  DetailedGestureDragUpdateCallback? get onVerticalDragUpdate;

  DetailedGestureDragEndCallback? get onVerticalDragEnd;

  DetailedGestureDragCancelCallback? get onVerticalDragCancel;

  DetailedGestureDragDownCallback? get onHorizontalDragDown;

  DetailedGestureDragStartCallback? get onHorizontalDragStart;

  DetailedGestureDragUpdateCallback? get onHorizontalDragUpdate;

  DetailedGestureDragEndCallback? get onHorizontalDragEnd;

  DetailedGestureDragCancelCallback? get onHorizontalDragCancel;

  DetailedGestureDragDownCallback? get onPanDown;

  DetailedGestureDragStartCallback? get onPanStart;

  DetailedGestureDragUpdateCallback? get onPanUpdate;

  DetailedGestureDragEndCallback? get onPanEnd;

  DetailedGestureDragCancelCallback? get onPanCancel;

  DetailedGestureScaleStartCallback? get onScaleStart;

  DetailedGestureScaleUpdateCallback? get onScaleUpdate;

  DetailedGestureScaleEndCallback? get onScaleEnd;

  DetailedGestureForcePressStartCallback? get onForcePressStart;

  DetailedGestureForcePressPeakCallback? get onForcePressPeak;

  DetailedGestureForcePressUpdateCallback? get onForcePressUpdate;

  DetailedGestureForcePressEndCallback? get onForcePressEnd;
}
