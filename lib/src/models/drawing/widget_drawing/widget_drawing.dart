import 'package:flutter/widgets.dart';
import 'package:graphilia_board/graphilia_board.dart';

export 'representable_widget_drawing.dart';

abstract class WidgetDrawing<T> extends Drawing<T> {
  const WidgetDrawing({
    required super.id,
    required super.zIndex,
  });

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode,
  ) =>
      isPolygonInsideOther(_getVertices(), vertices, mode);

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance,
  ) =>
      doesCircleTouchPolygon(
        point,
        tolerance,
        _getVertices(),
      );

  List<Offset> _getVertices() {
    final bounds = getBounds();

    return [
      bounds.topLeft,
      bounds.topRight,
      bounds.bottomRight,
      bounds.bottomLeft,
    ];
  }

  Widget build(
    BuildContext context,
    BoardState<T, BoardStateConfig> state, {
    required bool isSelected,
  });
}
