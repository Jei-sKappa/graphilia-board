import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:graphilia_board/src/core/core.dart';
import 'package:graphilia_board/src/models/models.dart';
import 'package:graphilia_board/src/presentation/notifier/notifier.dart';
import 'package:graphilia_board/src/presentation/state/board_state.dart';

class FunctionGraphDrawing<T> extends RepresentableCanvasDrawing<T, AnchoredDrawingRepresentation> with EquatableMixin {
  const FunctionGraphDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required this.expression,
    this.unit = 25,
  });

  factory FunctionGraphDrawing.fromMap(Map<String, dynamic> map) {
    return FunctionGraphDrawing(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      expression: Parser().parse(map['expression']),
      unit: map['unit'],
    );
  }

  final Expression expression;

  final double unit;

  @override
  List<Object?> get props => [...super.props, expression, unit];

  @override
  ScaleFactorListener<T, BoardStateConfig> get stateListener => ScaleFactorListener<T, BoardStateConfig>();

  @override
  FunctionGraphDrawing<T> updateRepresentation(AnchoredDrawingRepresentation value) => copyWith(representation: value);

  double unitMultiplier(num value) => value * unit;

  double unitDivider(num value) => value / unit;

  double f(double x) {
    final cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    final y = expression.evaluate(EvaluationType.REAL, cm);
    return y;
  }

  void _calculateYAndAddToPointsListIfInBounds(
    List<Offset> points,
    Rect bounds,
    double x,
  ) {
    // Calculate y
    final y = f(x);

    final firstXValue = bounds.center.dx;
    final firstYValue = bounds.center.dy;

    // Check if y is in bounds
    final realY = firstYValue - unitMultiplier(y);
    if (realY >= bounds.top && realY <= bounds.bottom) {
      final realX = firstXValue + unitMultiplier(x);
      points.add(Offset(realX, realY));
    }
  }

  List<Offset> getGraphPointsOnPositiveXAxis({
    required double step,
    required Rect bounds,
  }) {
    final points = <Offset>[];

    final lastX = unitDivider(bounds.width / 2);

    for (var x = -lastX; x < lastX; x += step) {
      _calculateYAndAddToPointsListIfInBounds(points, bounds, x);
    }

    // Add last point that (probably) was skipped by the last step
    _calculateYAndAddToPointsListIfInBounds(points, bounds, lastX);

    return points;
  }

  double negateXCoord(double x, {required Rect bounds}) => bounds.center.dx - (x - bounds.center.dx);

  double negateYCoord(double y, {required Rect bounds}) => bounds.center.dy - (y - bounds.center.dy);

  @override
  void draw(
    BoardState<T, BoardStateConfig> state,
    Canvas canvas, {
    required bool isSelected,
  }) {
    final bounds = getBounds();

    final borderPaint = Paint()
      ..color = const Color(0x44FFFFFF)
      ..strokeWidth = 1 / state.scaleFactor
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    canvas.drawRect(bounds, borderPaint);

    final axisPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 1 / state.scaleFactor
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    // Draw X axis
    final xAxisStart = Offset(bounds.left, bounds.center.dy);
    final xAxisEnd = Offset(bounds.right, bounds.center.dy);
    canvas.drawLine(xAxisStart, xAxisEnd, axisPaint);

    // Draw Y axis
    final yAxisStart = Offset(bounds.center.dx, bounds.top);
    final yAxisEnd = Offset(bounds.center.dx, bounds.bottom);
    canvas.drawLine(yAxisStart, yAxisEnd, axisPaint);

    // Draw unit lines

    final unitLinePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 1 / state.scaleFactor
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;

    final unitLineLength = 4 / state.scaleFactor;

    final xLineStart = bounds.center.dx - unitLineLength;
    final xLineEnd = bounds.center.dx + unitLineLength;

    final yLineStart = bounds.center.dy - unitLineLength;
    final yLineEnd = bounds.center.dy + unitLineLength;

    final unitLineStep = 1 / state.scaleFactor;

    final fontSize = 14 / state.scaleFactor;

    final textHeight = fontSize / 0.675;

    // Draw unite lines and numbers on the X axis
    final unitHalfWidth = unitDivider(bounds.width / 2);
    var lastDisplayedTextRight = bounds.centerLeft.dx;
    final xAxisTextY = bounds.center.dy + unitLineLength + (5 / state.scaleFactor);
    for (var i = -unitHalfWidth; i < unitHalfWidth; i += unitLineStep) {
      final unitText = i.toStringAsFixed(2);
      if (unitText == "0.00" || unitText == "-0.00") continue;

      final x = bounds.center.dx + unitMultiplier(i);

      // Draw unit line
      canvas.drawLine(
        Offset(x, yLineStart),
        Offset(x, yLineEnd),
        unitLinePaint,
      );

      // Calculate text space and position
      final textWidth = (unitText.length * fontSize) / 1.8;
      final textLeft = x - (textWidth / 2);

      // Draw unit number if there is enough space
      if (textLeft > lastDisplayedTextRight) {
        canvas.drawText(
          i.toStringAsFixed(2),
          style: TextStyle(fontSize: fontSize),
          maxWidth: textWidth,
          offset: Offset(textLeft, xAxisTextY),
        );

        final textRightX = x + (textWidth / 2);
        lastDisplayedTextRight = textRightX;
      }
    }

    // Draw unite lines and numbers on the Y axis
    final unitHalfHeight = unitDivider(bounds.height / 2);
    var lastDisplayedTextBottom = bounds.bottomCenter.dy;
    final xAxisTextBottom = xAxisTextY + textHeight;
    final yAxisTextX = bounds.center.dx + unitLineLength + (5 / state.scaleFactor);
    for (var i = -unitHalfHeight; i < unitHalfHeight; i += unitLineStep) {
      final unitText = i.toStringAsFixed(2);
      if (unitText == "0.00" || unitText == "-0.00") continue;

      final y = bounds.center.dy - unitMultiplier(i);

      // Draw unit line
      canvas.drawLine(
        Offset(xLineStart, y),
        Offset(xLineEnd, y),
        unitLinePaint,
      );

      // Calculate text space and position
      final textWidth = (unitText.length * fontSize) / 1.8;

      final textTop = y - (textHeight / 2);
      final textBottomY = y + (textHeight / 2);

      // Verify if the text unit in the Y axis is not overlapping with the text
      // unit in the X axis
      if (!textTop.isBetweenStrict(bounds.center.dy, xAxisTextBottom) && !textBottomY.isBetweenStrict(bounds.center.dy, xAxisTextBottom)) {
        // Draw unit number if there is enough space
        if (textTop < lastDisplayedTextBottom) {
          canvas.drawText(
            i.toStringAsFixed(2),
            style: TextStyle(fontSize: fontSize),
            maxWidth: textWidth,
            offset: Offset(yAxisTextX, textTop),
          );

          lastDisplayedTextBottom = textBottomY;
        }
      }
    }

    // Calculate graph points
    final points = getGraphPointsOnPositiveXAxis(
      step: 0.01, // TODO: Check if the scale factor is needed
      // step: 0.01 * state.scaleFactor,
      // step: 0.01 / state.scaleFactor,
      bounds: bounds,
    );

    if (points.isEmpty) return;

    // Create graph path
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Draw graph
    final graphPaint = Paint()
      ..color = const Color(0xFFAA3A2F)
      ..strokeWidth = 2 / state.scaleFactor
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, graphPaint);

    // Draw expression text
    canvas.drawText(
      expression.toString(),
      style: TextStyle(
        fontSize: 20 / state.scaleFactor,
        backgroundColor: const Color(0x22FFFFFF),
      ),
      maxWidth: bounds.width,
      offset: bounds.topLeft,
    );
  }

  @override
  Rect getBounds() => Rect.fromPoints(
        representation.anchorPoint,
        representation.endPoint,
      );

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

  @override
  FunctionGraphDrawing<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Expression? expression,
    double? unit,
  }) =>
      FunctionGraphDrawing(
        id: id ?? super.id,
        zIndex: zIndex ?? super.zIndex,
        representation: representation ?? super.representation,
        expression: expression ?? this.expression,
        unit: unit ?? this.unit,
      );

  @override
  Map<String, dynamic> toMap() => {
        'type': 'function_graph',
        'id': id,
        'zIndex': zIndex,
        'representation': representation.toMap(),
        'expression': expression.toString(),
        'unit': unit,
      };
}
