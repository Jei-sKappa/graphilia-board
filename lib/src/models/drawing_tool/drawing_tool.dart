import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

export 'base_drawing_tool_factories.dart';
export 'function_graph_tool.dart';
export 'highlighter_circle_tool.dart';
export 'highlighter_line_tool.dart';
export 'highlighter_polygon_tool.dart';
export 'highlighter_straight_line_tool.dart';
export 'simple_drawing_tool.dart';
export 'simple_circle_tool.dart';
export 'simple_line_tool.dart';
export 'simple_polygon_tool.dart';
export 'simple_straight_line_tool.dart';

typedef DrawingToolFactory<T> = DrawingTool<T> Function(Map<String, dynamic>);

abstract class DrawingTool<T> {
  const DrawingTool();

  factory DrawingTool.fromMap(Map<String, dynamic> map) {
    final factories = DrawingTool._factoriesOfExactType[T];
    if (factories == null) {
      throw ArgumentError('No factories registered for type $T');
    }

    final type = map['type'];

    if (factories.containsKey(type)) {
      final constructed = factories[type]!(map);
      if (constructed is DrawingTool<T>) {
        return constructed;
      } else {
        throw ArgumentError('The factory for type $type did not return a DrawingTool<$T>');
      }
    } else {
      if (type == null) {
        throw ArgumentError("Missing 'type' key in map");
      }

      throw ArgumentError('Unknown DrawingTool type: $type');
    }
  }

  // Factory registration map.
  static final Map<Type, Map<String, DrawingToolFactory>> _factoriesOfExactType = {};

  // Register factory method.
  static void registerFactory<T>(String type, DrawingToolFactory<T> factory) {
    // TODO: Add a explaination for this assert: This is likely to be caused by calling "GraphiliaBoard.registerDrawingToolFactories()" with no parameters and no type parameters. This can be fixed by calling "GraphiliaBoard.registerDrawingToolFactories<MyType>()" instead.
    assert(T != dynamic);

    DrawingTool._factoriesOfExactType[T] ??= {};
    DrawingTool._factoriesOfExactType[T]![type] = factory;
  }

  Drawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  );

  void drawPreview(
    Canvas canvas,
    Point point,
    BoardState<T, BoardStateConfig> state,
  );

  DrawingTool<T> copyWith();

  /// Converts the drawing to a map.
  ///
  /// Every drawing tool should have a `type` key that specifies the type of
  /// drawing tool.
  Map<String, dynamic> toMap();
}
