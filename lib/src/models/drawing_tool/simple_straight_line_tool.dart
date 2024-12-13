import 'package:graphilia_board/graphilia_board.dart';

class SimpleStraightLineTool<T> extends SimpleDrawingTool<T> {
  const SimpleStraightLineTool({
    required super.color,
    required super.width,
    super.shouldScale,
  });

  @override
  SimpleStraightLine<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return SimpleStraightLine(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }
}
