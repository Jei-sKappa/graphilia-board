import 'package:perfect_freehand/perfect_freehand.dart' as pf;
import 'package:graphilia_board/src/models/point/point.dart';

/// Generates List of [Point] that represents the outline of a line from a List
/// of [Point] that represent a line without the width information.
///
/// The [width] is used to determine the width of the line.
///
/// If [simulatePressure] is true, the line will be drawn as if it had
/// pressure information, only if all its points have the same pressure.
List<Point> getOutlinePoints(
  List<Point> points, {
  required double width,
  required bool simulatePressure,
}) {
  final needSimulate = simulatePressure && points.length > 1 && points.every((p) => p.pressure == points.first.pressure);
  final pointVectors = points.map((point) => pf.PointVector(point.x, point.y, point.pressure)).toList();
  final outlinePoints = pf.getStroke(
    pointVectors,
    options: pf.StrokeOptions(
      size: width,
      thinning: 0.5,
      smoothing: 0.5,
      streamline: 0.5,
      easing: pf.StrokeEasings.identity,
      simulatePressure: needSimulate,
      start: pf.StrokeEndOptions.start(easing: pf.StrokeEasings.identity),
      end: pf.StrokeEndOptions.end(easing: pf.StrokeEasings.identity),
      // TODO: Considering set "isComplete" to true only when the stroke is actually finished
      isComplete: true,
    ),
  );

  return outlinePoints.map((point) => Point(point.dx, point.dy)).toList();
}
