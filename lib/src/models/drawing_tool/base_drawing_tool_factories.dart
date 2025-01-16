import 'package:graphilia_board/graphilia_board.dart';

Map<String, DrawingToolFactory<T>> getBaseDrawingToolFactories<T>() {
  return {
    FunctionGraphDrawingTool.typeKey: FunctionGraphDrawingTool.fromMap,
    HighlighterCircleDrawingTool.typeKey: HighlighterCircleDrawingTool.fromMap,
    HighlighterLineTool.typeKey: HighlighterLineTool.fromMap,
    HighlighterPolygonDrawingTool.typeKey: HighlighterPolygonDrawingTool.fromMap,
    HighlighterStraightLineTool.typeKey: HighlighterStraightLineTool.fromMap,
    SimpleCircleDrawingTool.typeKey: SimpleCircleDrawingTool.fromMap,
    SimpleLineTool.typeKey: SimpleLineTool.fromMap,
    SimplePolygonDrawingTool.typeKey: SimplePolygonDrawingTool.fromMap,
    SimpleStraightLineTool.typeKey: SimpleStraightLineTool.fromMap,
  };
}
