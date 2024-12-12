import 'dart:math' as math;
import 'package:graphilia_board/graphilia_board.dart';
import 'package:simpli/simpli.dart';

class RamerDouglasPeuckerPointsSimplifier extends PointsSimplifier {
  const RamerDouglasPeuckerPointsSimplifier();

  @override
  List<Point> simplify(List<Point> points, {required double pixelTolerance}) {
    if (pixelTolerance == 0) return points;

    // TODO: Skip mapping to math.Point
    final mathPoints = points.map((e) => math.Point(e.x, e.y)).toList();

    final simplified = Simpli.ramerDouglasPeucker(
      mathPoints,
      pixelTolerance: pixelTolerance,
    );

    // TODO: Why do not just return simplified?
    final removedIndices = mathPoints.removedIndices(simplified.cast());

    return points.withRemovedIndices(removedIndices.toSet()).toList();
  }
}
