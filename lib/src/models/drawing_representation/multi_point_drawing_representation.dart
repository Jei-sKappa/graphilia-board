import 'package:graphilia_board/src/models/drawing_representation/drawing_representation.dart';
import 'package:graphilia_board/src/models/point/point.dart';

abstract class MultiPointDrawingRepresentation extends DrawingRepresentation {
  const MultiPointDrawingRepresentation();

  bool isInitializedOnlyOnePoint();

  Point getSinglePoint();
}
