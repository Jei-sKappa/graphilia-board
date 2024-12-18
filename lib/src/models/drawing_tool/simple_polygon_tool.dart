import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/graphilia_board.dart';

class SimplePolygonDrawingTool<T> extends SimpleDrawingTool<T> with EquatableMixin {
  const SimplePolygonDrawingTool({
    required super.color,
    required super.width,
    super.shouldScale,
    required this.polygonTemplate,
  });

  final PolygonTemplate polygonTemplate;

  @override
  List<Object?> get props => [...super.props, polygonTemplate];

  @override
  SimplePolygonDrawing<T> createDrawing(
    Point firstPoint,
    T id,
    int zIndex,
    BoardState<T, BoardStateConfig> state,
  ) {
    return SimplePolygonDrawing(
      id: id,
      zIndex: zIndex,
      representation: AnchoredDrawingRepresentation.initial(firstPoint),
      color: color,
      width: getScaledWidthIfNecessary(state),
      polygonTemplate: polygonTemplate,
    );
  }

  @override
  SimplePolygonDrawingTool<T> copyWith({
    Color? color,
    double? width,
    bool? shouldScale,
    PolygonTemplate? polygonTemplate,
  }) {
    return SimplePolygonDrawingTool(
      color: color ?? super.color,
      width: width ?? super.width,
      shouldScale: shouldScale ?? super.shouldScale,
      polygonTemplate: polygonTemplate ?? this.polygonTemplate,
    );
  }
}
