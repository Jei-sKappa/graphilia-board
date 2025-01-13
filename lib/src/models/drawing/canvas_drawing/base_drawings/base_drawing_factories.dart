import 'package:graphilia_board/src/models/drawing/drawing.dart';

Map<String, DrawingFactory<T>> getBaseDrawingFactories<T>() {
  return {
    'function_graph': (Map<String, dynamic> map) => FunctionGraphDrawing.fromMap(map),
    'highlighter_circle': (map) => HighlighterCircleDrawing.fromMap(map),
    'highlighter_line': (map) => HighlighterLine.fromMap(map),
    'highlighter_polygon_drawing': (map) => HighlighterPolygonDrawing.fromMap(map),
    'highlighter_straight_line': (map) => HighlighterStraightLine.fromMap(map),
    'simple_circle': (map) => SimpleCircleDrawing.fromMap(map),
    'simple_line': (map) => SimpleLine.fromMap(map),
    'simple_polygon_drawing': (map) => SimplePolygonDrawing.fromMap(map),
    'simple_straight_line': (map) => SimpleStraightLine.fromMap(map),
  };
}