import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

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

abstract class DrawingTool<T> {
  const DrawingTool();

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
}
