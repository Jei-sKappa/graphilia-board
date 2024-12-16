import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class SimplePolygonDrawing<T> extends SimpleDrawing<T, AnchoredDrawingRepresentation> with EquatableMixin {
  const SimplePolygonDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
    required this.polygonTemplate,
  });

  factory SimplePolygonDrawing.fromMap(Map<String, dynamic> map) {
    return SimplePolygonDrawing(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
      polygonTemplate: PolygonTemplate.fromJson(map['polygonTemplate']),
    );
  }

  final PolygonTemplate polygonTemplate;

  @override
  List<Object?> get props => [...super.props, polygonTemplate];

  @override
  SimplePolygonDrawing<T> updateRepresentation(AnchoredDrawingRepresentation value) => copyWith(representation: value);

  @override
  Rect getBounds() {
    // Check if the polygon representation has only one point
    if (representation.isInitializedOnlyOnePoint()) return Rect.zero;

    final scaledDrawingVertices = _getScaledVertices();

    return getPointListBounds(scaledDrawingVertices);
  }

  @override
  Paint getPaint() => Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  @override
  void draw(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas, {
    required bool isSelected,
  }) {
    // Check if the polygon representation has only one point
    if (representation.isInitializedOnlyOnePoint()) {
      // TODO: Consider drawing a mini version of the polygon
      return;
    }

    if (polygonTemplate.vertices.length < 3) {
      // TODO(Jei-sKappa): Throw an error
      return;
    }

    final scaledVertices = _getScaledVertices();

    final path = Path()
      ..moveTo(
        scaledVertices.first.dx,
        scaledVertices.first.dy,
      );

    for (var i = 1; i < polygonTemplate.vertices.length; i++) {
      path.lineTo(
        scaledVertices[i].dx,
        scaledVertices[i].dy,
      );
    }

    path.close();

    // TODO(Jei-sKappa): Check if is required to draw filled polygon or not
    canvas.drawPath(
      path,
      getPaint(),
    );
  }

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance,
  ) {
    // Check if the polygon representation has only one point
    if (representation.isInitializedOnlyOnePoint()) {
      // TODO: Refer to [// TODO: Consider drawing a mini version of the polygon]
      return false;
    }

    return doesCircleTouchPolygon(
      point,
      tolerance,
      _getScaledVertices(),
    );
  }

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode,
  ) {
    // Check if the polygon representation has only one point
    if (representation.isInitializedOnlyOnePoint()) {
      return false;
    }

    if (polygonTemplate.vertices.length < 3) {
      // TODO(Jei-sKappa): Throw an error
      return false;
    }

    final scaledDrawingVertices = _getScaledVertices();

    return isPolygonInsideOther(scaledDrawingVertices, vertices, mode);
  }

  List<Offset> _getScaledVertices() => polygonTemplate.calculateScaledVertices(
        representation.anchorPoint,
        representation.endPoint,
      );

  SimplePolygonDrawing<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
    PolygonTemplate? polygonTemplate,
  }) =>
      SimplePolygonDrawing(
        id: id ?? super.id,
        zIndex: zIndex ?? super.zIndex,
        representation: representation ?? super.representation,
        color: color ?? super.color,
        width: width ?? super.width,
        polygonTemplate: polygonTemplate ?? this.polygonTemplate,
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'simple_polygon_drawing',
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
      'polygonTemplate': polygonTemplate.toJson(),
    };
  }
}
