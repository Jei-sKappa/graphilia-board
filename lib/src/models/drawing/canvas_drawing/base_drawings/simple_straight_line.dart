import 'dart:math';
import 'dart:ui';

import 'package:graphilia_board/src/core/constants/constants.dart';
import 'package:graphilia_board/src/core/helpers/helpers.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/state.dart';

class SimpleStraightLine<T> extends SimpleDrawing<T, AnchoredDrawingRepresentation> with SinglePointDrawer {
  const SimpleStraightLine({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
  });

  factory SimpleStraightLine.fromMap(Map<String, dynamic> map) {
    return SimpleStraightLine(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
    );
  }

  // TODO: Make this configurable in the config
  static double snapThreshold = kDefaultSnapTreshold;

  @override
  SimpleStraightLine<T> updateRepresentation(AnchoredDrawingRepresentation value) => copyWith(representation: value);

  @override
  Rect getBounds() {
    final bounds = getCartesianPlaneBounds(includeRoundedEdges: true);
    final left = min(bounds.topLeft.dx, bounds.bottomLeft.dx);
    final top = min(bounds.topLeft.dy, bounds.topRight.dy);
    final right = max(bounds.topRight.dx, bounds.bottomRight.dx);
    final bottom = max(bounds.bottomLeft.dy, bounds.bottomRight.dy);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// In Dart the Rect is constructed with the top left and bottom right points.
  /// These values can't include any information about the rotation of the
  /// rectangle.
  ///
  /// This method calculates the four [Offset] points of the rectangle that
  /// represents the actual rectangle shape of the line in a cartesian plane.
  CartesianRectangle getCartesianPlaneBounds({
    required bool includeRoundedEdges,
  }) {
    // The line representation is a straight line, with no width so we need to
    // calculate the bounds of the line.

    late final Offset upperPoint;
    late final Offset lowerPoint;
    if (representation.anchorPoint.dy < representation.endPoint.dy) {
      upperPoint = representation.anchorPoint;
      lowerPoint = representation.endPoint;
    } else {
      upperPoint = representation.endPoint;
      lowerPoint = representation.anchorPoint;
    }

    final halfWidth = width / 2;

    // Calculate the direction of the line
    final dx = lowerPoint.dx - upperPoint.dx;
    final dy = lowerPoint.dy - upperPoint.dy;
    final length = sqrt(dx * dx + dy * dy);

    // Calculate perpendicular offsets
    late final double offsetX;
    late final double offsetY;
    if (length == 0) {
      offsetX = 0;
      offsetY = 0;
    } else {
      offsetX = -dy * halfWidth / length;
      offsetY = dx * halfWidth / length;
    }

    final edgeOffsetX = includeRoundedEdges ? offsetY : 0;
    final edgeOffsetY = includeRoundedEdges ? -offsetX : 0;

    // Calculate the four points of the filled polygon
    final topLeft = Offset(
      upperPoint.dx - edgeOffsetX + offsetX,
      upperPoint.dy - edgeOffsetY + offsetY,
    );
    final topRight = Offset(
      upperPoint.dx - edgeOffsetX - offsetX,
      upperPoint.dy - edgeOffsetY - offsetY,
    );
    final bottomLeft = Offset(
      lowerPoint.dx + edgeOffsetX + offsetX,
      lowerPoint.dy + edgeOffsetY + offsetY,
    );
    final bottomRight = Offset(
      lowerPoint.dx + edgeOffsetX - offsetX,
      lowerPoint.dy + edgeOffsetY - offsetY,
    );

    return (
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  @override
  bool isPointInside(
    BoardState<T, BoardStateConfig> state,
    Point point,
    double tolerance, {
    required bool simulatePressure,
  }) {
    final rectangleVertices = getCartesianPlaneBounds(includeRoundedEdges: false).vertices;

    // Check if the point is inside the rectangle
    var isInside = doesCircleTouchPolygon(point, tolerance, rectangleVertices);
    if (isInside) return true;

    // Check if the point is inside the anchor point circle
    isInside = doCirclesIntersect(
      center1: point,
      radius1: tolerance,
      center2: representation.anchorPoint,
      radius2: width,
    );
    if (isInside) return true;

    // Check if the point is inside the end point circle
    isInside = doCirclesIntersect(
      center1: point,
      radius1: tolerance,
      center2: representation.endPoint,
      radius2: width,
    );
    if (isInside) return true;

    return false;
  }

  @override
  bool isInsidePolygon(
    BoardState<T, BoardStateConfig> state,
    List<Point> vertices,
    PointsInPolygonMode mode, {
    required bool simulatePressure,
  }) {
    final rectangleVertices = getCartesianPlaneBounds(includeRoundedEdges: false).vertices;

    var isPolygonInside = isPolygonInsideOther(rectangleVertices, vertices, mode);

    if (isPolygonInside) return true;

    // Check if the anchor point circle is inside the polygon
    isPolygonInside = isPolygonInsideCircle(
      vertices,
      representation.anchorPoint,
      width,
      mode,
    );
    if (isPolygonInside) return true;

    // Check if the end point circle is inside the polygon
    isPolygonInside = isPolygonInsideCircle(
      vertices,
      representation.endPoint,
      width,
      mode,
    );

    if (isPolygonInside) return true;

    return false;
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
    final halfWidth = width / 2;

    // Do not include rounded edges because the method arcToPoint will be used
    // to generate the rounded edges.
    final cartesianPlaneBounds = getCartesianPlaneBounds(
      includeRoundedEdges: false,
    );

    final path = Path()
      ..moveTo(cartesianPlaneBounds.topRight.dx, cartesianPlaneBounds.topRight.dy)
      ..lineTo(cartesianPlaneBounds.bottomRight.dx, cartesianPlaneBounds.bottomRight.dy)
      ..arcToPoint(cartesianPlaneBounds.bottomLeft, radius: Radius.circular(halfWidth))
      ..lineTo(cartesianPlaneBounds.topLeft.dx, cartesianPlaneBounds.topLeft.dy)
      ..arcToPoint(cartesianPlaneBounds.topRight, radius: Radius.circular(halfWidth));

    canvas.drawPath(
      path,
      getPaint(),
    );
  }

  @override
  // Override [update] to implement snapping
  SimpleStraightLine<T>? update(
    BoardState<T, BoardStateConfig> state,
    Point newPoint,
  ) {
    final shouldUpdate = representation.isPointDistanceEnoughFromLastPoint(
      state,
      newPoint,
    );
    if (!shouldUpdate) return null;

    return copyWith(
      representation: representation.copyWith(
        endPoint: newPoint.snapTo(
          representation.anchorPoint,
          snapThreshold / state.scaleFactor,
        ),
      ),
    );
  }

  SimpleStraightLine<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
  }) {
    return SimpleStraightLine(
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
      'type': 'simple_straight_line',
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
    };
  }
}
