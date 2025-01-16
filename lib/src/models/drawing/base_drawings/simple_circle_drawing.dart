import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

class SimpleCircleDrawing<T> extends SimpleDrawing<T, AnchoredDrawingRepresentation> with SinglePointDrawer {
  const SimpleCircleDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
  });

  factory SimpleCircleDrawing.fromMap(Map<String, dynamic> map) {
    return SimpleCircleDrawing(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
    );
  }

  static const typeKey = 'simple_circle';

  double get diameter => getBounds().width;

  double get radius => diameter / 2;

  @override
  Rect getBounds() {
    if (representation.isInitializedOnlyOnePoint()) {
      return Rect.zero;
    }

    final representationRect = Rect.fromPoints(
      representation.anchorPoint,
      representation.endPoint,
    );

    final radius = representationRect.shortestSide / 2;

    final center = representationRect.center;

    return Rect.fromCircle(
      center: center,
      radius: radius,
    );
  }

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance,
  ) {
    final center = getBounds().center;

    final distance = center.distanceTo(point);

    return distance <= radius + tolerance;
  }

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode,
  ) {
    final center = getBounds().center;
    return doesCircleTouchPolygon(center, radius, vertices);
  }

  @override
  bool shouldDrawSinglePoint() => representation.isInitializedOnlyOnePoint();

  @override
  Point getSinglePoint() => representation.getSinglePoint();

  @override
  void drawSinglePoint(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas,
    Point point,
  ) =>
      drawPoint(
        canvas,
        point,
        width,
        SimpleDrawing.createSimplePaint(color),
      );

  @override
  void drawMultiplePoints(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas, {
    required bool isSelected,
  }) {
    final center = getBounds().center;

    canvas.drawCircle(
      center,
      radius,
      getPaint(),
    );
  }

  @override
  SimpleCircleDrawing<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
  }) {
    return SimpleCircleDrawing(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      representation: representation ?? this.representation,
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': typeKey,
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
    };
  }
}
