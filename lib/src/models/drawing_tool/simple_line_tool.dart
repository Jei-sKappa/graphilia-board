import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class SimpleLineTool<T> extends SimpleDrawingTool<T> {
  const SimpleLineTool({
    required super.color,
    required super.width,
    super.shouldScale,
    this.simulatePressure = false,
  });

  final bool simulatePressure;

  @override
  SimpleLine<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return SimpleLine(
      id: id,
      zIndex: zIndex,
      representation: LineRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
      simulatePressure: simulatePressure,
    );
  }
}
