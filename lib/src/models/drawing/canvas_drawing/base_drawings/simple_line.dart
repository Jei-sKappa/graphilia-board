import 'dart:ui';

import 'package:graphilia_board/graphilia_board.dart';

// ignore: must_be_immutable
class SimpleLine<T> extends SimpleDrawing<T, LineRepresentation> with SinglePointDrawer<T> {
  SimpleLine({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
  });

  factory SimpleLine.fromMap(Map<String, dynamic> map) {
    return SimpleLine(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: LineRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
    );
  }

  @override
  SimpleLine<T> updateRepresentation(LineRepresentation value) => copyWith(representation: value);

  // Cache used to store the outline points of the line
  List<Point>? _outlinePointsCache;

  // Cache used to store the bounds of the line
  Rect? _boundsCache;

  /// Returns the outline points of the line
  ///
  /// Uses the cache if it is not null, otherwise it calculates the outline
  /// points and stores them in the cache
  List<Point> getOutlinePoints({
    required bool simulatePressure,
  }) =>
      _outlinePointsCache ??= representation.getOutlinePoints(
        width: width,
        simulatePressure: simulatePressure,
      );

  @override
  Rect getBounds() => _boundsCache ??= _getBounds();

  Rect _getBounds() {
    if (representation.points.isEmpty) {
      return Rect.zero;
    }

    if (representation.points.length == 1) {
      return Rect.fromCircle(
        center: representation.points.first,
        radius: width / 2,
      );
    }

    final points = getOutlinePoints(
      simulatePressure: false, // TODO: This is  hardcoded
    );

    return getPointListBounds(points);
  }

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance, {
    required bool simulatePressure,
  }) {
    final outlinePoints = getOutlinePoints(simulatePressure: simulatePressure);

    return doesCircleTouchPolygon(point, tolerance, outlinePoints);
  }

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode, {
    required bool simulatePressure,
  }) {
    final outLinePoints = getOutlinePoints(simulatePressure: simulatePressure);

    return isPolygonInsideOther(outLinePoints, vertices, mode);
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
    required bool simulatePressure,
    required bool isSelected,
  }) {
    final path = getPath(simulatePressure: simulatePressure);

    if (path == null) {
      return;
    }

    canvas.drawPath(
      path,
      getPaint(),
    );
  }

  Path? getPath({
    required bool simulatePressure,
  }) {
    final outlinePoints = getOutlinePoints(simulatePressure: simulatePressure);

    if (outlinePoints.isEmpty) {
      return null;
    } else if (outlinePoints.length < 2) {
      return Path()
        ..addOval(
          Rect.fromCircle(
            center: outlinePoints[0],
            radius: 1,
          ),
        );
    } else {
      final path = Path()..moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (var i = 1; i < outlinePoints.length - 1; i++) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(
          p0.x,
          p0.y,
          (p0.x + p1.x) / 2,
          (p0.y + p1.y) / 2,
        );
      }
      return path;
    }
  }

  SimpleLine<T> copyWith({
    T? id,
    int? zIndex,
    LineRepresentation? representation,
    Color? color,
    double? width,
  }) {
    return SimpleLine(
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
      'type': 'simple_line',
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
    };
  }
}
