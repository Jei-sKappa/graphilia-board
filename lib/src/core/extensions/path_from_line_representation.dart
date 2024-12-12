import 'package:graphilia_board/src/core/helpers/get_outline_points.dart' as outline_helper;
import 'package:graphilia_board/src/models/drawing_representation/line_representation.dart';
import 'package:graphilia_board/src/models/point/point.dart';

extension PathFromLineRepresentation on LineRepresentation {
  /// Generates List of [Point] that represents the outline of a line from a List of [Point] that represent a line without the width information.
  ///
  /// The [width] is used to determine the width of the line.
  ///
  /// If [simulatePressure] is true, the line will be drawn as if it had pressure information, only if all its points have the same pressure.
  List<Point> getOutlinePoints({
    required double width,
    required bool simulatePressure,
  }) =>
      outline_helper.getOutlinePoints(
        points,
        width: width,
        simulatePressure: simulatePressure,
      );
}
