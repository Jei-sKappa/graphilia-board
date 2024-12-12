import 'package:graphilia_board/graphilia_board.dart';

abstract class PointsSimplifier {
  const PointsSimplifier();

  List<Point> simplify(List<Point> points, {required double pixelTolerance});
}
