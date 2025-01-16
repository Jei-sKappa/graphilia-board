import 'package:graphilia_board/src/models/drawing/drawing.dart';

Map<String, DrawingFactory<T>> getBaseDrawingFactories<T>() {
  return {
    FunctionGraphDrawing.typeKey: FunctionGraphDrawing.fromMap,
    HighlighterCircleDrawing.typeKey: HighlighterCircleDrawing.fromMap,
    HighlighterLine.typeKey: HighlighterLine.fromMap,
    HighlighterPolygonDrawing.typeKey: HighlighterPolygonDrawing.fromMap,
    HighlighterStraightLine.typeKey: HighlighterStraightLine.fromMap,
    SimpleCircleDrawing.typeKey: SimpleCircleDrawing.fromMap,
    SimpleLine.typeKey: SimpleLine.fromMap,
    SimplePolygonDrawing.typeKey: SimplePolygonDrawing.fromMap,
    SimpleStraightLine.typeKey: SimpleStraightLine.fromMap,
  };
}
