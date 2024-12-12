import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

export 'base_drawing_representation_factories.dart';
export 'anchored_drawing_representation.dart';
export 'line_representation.dart';
export 'multi_point_drawing_representation.dart';
export 'placeholder_rect_representation.dart';

typedef DrawingRepresentationFactory = DrawingRepresentation Function(Map<String, dynamic>);

abstract class DrawingRepresentation {
  const DrawingRepresentation();

  factory DrawingRepresentation.fromMap(Map<String, dynamic> map) {
    final type = map['type'];
    if (_factories.containsKey(type)) {
      return _factories[type]!(map);
    } else {
      throw ArgumentError('Unknown DrawingRepresentation type: $type');
    }
  }

  // Factory registration map.
  static final Map<String, DrawingRepresentationFactory> _factories = {};

  // Register factory method.
  static void registerFactory(String type, DrawingRepresentationFactory factory) {
    DrawingRepresentation._factories[type] = factory;
  }

  DrawingRepresentation setFirstPoint(BoardState state, Point point);

  DrawingRepresentation setNewPoint(BoardState state, Point point);

  DrawingRepresentation move(BoardState state, Point offset);

  DrawingRepresentation resize(
    BoardState state,
    Rect resizeRect,
    ResizeAnchor anchor,
    Offset delta,
  );

  bool isPointDistanceEnoughFromLastPoint(BoardState state, Point newPoint);

  Map<String, dynamic> toMap();
}
