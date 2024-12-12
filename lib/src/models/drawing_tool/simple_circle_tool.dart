import 'package:graphilia_board/graphilia_board.dart';

class SimpleCircleDrawingTool<T> extends SimpleDrawingTool<T> {
  const SimpleCircleDrawingTool({
    required super.color,
    required super.width,
    super.shouldScale,
  });

  @override
  SimpleCircleDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState state,
  ) {
    return SimpleCircleDrawing(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
    );
  }
}
