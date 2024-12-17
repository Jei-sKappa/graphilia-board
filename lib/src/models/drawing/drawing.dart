import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:graphilia_board/graphilia_board.dart';

export 'canvas_drawing/canvas_drawing.dart';
export 'widget_drawing/widget_drawing.dart';
export 'connectable_drawing_mixin.dart';
export 'drawing_group.dart';
export 'representable_drawing_mixin.dart';

typedef DrawingFactory = Drawing Function(Map<String, dynamic>);

abstract class Drawing<T> with EquatableMixin {
  const Drawing({
    required this.id,
    required this.zIndex,
  });

  factory Drawing.fromMap(Map<String, dynamic> map) {
    final type = map['type'];
    if (_factories.containsKey(type)) {
      final constructed = _factories[type]!(map);
      if (constructed is Drawing<T>) {
        return constructed;
      } else {
        throw ArgumentError('The factory for type $type did not return a Drawing<$T>');
      }
    } else {
      throw ArgumentError('Unknown Drawing type: $type');
    }
  }

  // Factory registration map.
  static final Map<String, DrawingFactory> _factories = {};

  // Register factory method.
  static void registerFactory(String type, DrawingFactory factory) {
    Drawing._factories[type] = factory;
  }

  // TODO: Add lockAspectRatio on resize property to Drawing

  final T id;

  /// The z-index of the drawing. The higher the z-index, the more on top the
  /// drawing will be.
  ///
  /// If two drawings have the same z-index, the one that was added last will
  /// be on top.
  final int zIndex;

  @override
  List<Object?> get props => [id, zIndex];

  BoardStateListener<T, BoardStateConfig>? get stateListener => null;

  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance,
  );

  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode,
  );

  Drawing<T>? update(BoardState<T, BoardStateConfig> state, Point newPoint);

  Drawing<T> move(BoardState<T, BoardStateConfig> state, Point offset);

  Drawing<T> resize(
    BoardState<T, BoardStateConfig> state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  );

  Rect getBounds();

  /// {@template drawing.on_tap_down}
  /// The callback that gets called when a tap down gesture is detected on a
  /// drawing.
  /// {@endtemplate}
  TapEventSketchResult<T> onTapDown(
    BoardState<T, BoardStateConfig> state,
    PointerEvent details,
  ) =>
      const EventResult.ignored();

  /// {@template drawing.on_tap_up}
  /// The callback that gets called when a tap up gesture is detected on a
  /// drawing.
  /// {@endtemplate}
  TapEventSketchResult<T> onTapUp(
    BoardState<T, BoardStateConfig> state,
    PointerEvent details,
  ) =>
      const EventResult.ignored();
  
  Drawing<T> copyWith({
    T? id,
    int? zIndex,
  });

  /// Converts the drawing to a map.
  ///
  /// Every drawing should have a `type` key that specifies the type of drawing.
  Map<String, dynamic> toMap();
}
