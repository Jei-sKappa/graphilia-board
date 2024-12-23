import 'package:graphilia_board/graphilia_board.dart';

Map<String, DrawingToolFactory<T>> getBaseDrawingToolFactories<T>() {
  return {
    'function_graph_tool': (map) => FunctionGraphDrawingTool.fromMap(map),
    'highlighter_circle_tool': (map) => HighlighterCircleDrawingTool.fromMap(map),
    'highlighter_line_tool': (map) => HighlighterLineTool.fromMap(map),
    'highlighter_polygon_tool': (map) => HighlighterPolygonDrawingTool.fromMap(map),
    'highlighter_straight_line_tool': (map) => HighlighterStraightLineTool.fromMap(map),
    'simple_circle_tool': (map) => SimpleCircleDrawingTool.fromMap(map),
    'simple_line_tool': (map) => SimpleLineTool.fromMap(map),
    'simple_polygon_tool': (map) => SimplePolygonDrawingTool.fromMap(map),
    'simple_straight_line_tool': (map) => SimpleStraightLineTool.fromMap(map),
  };
}