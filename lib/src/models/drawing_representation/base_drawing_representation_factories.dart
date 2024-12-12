import 'package:graphilia_board/src/models/drawing_representation/drawing_representation.dart';

Map<String, DrawingRepresentationFactory> baseDrawingRepresentationFactories = {
  'anchored_drawing_representation': (map) => AnchoredDrawingRepresentation.fromMap(map),
  'line_representation': (map) => LineRepresentation.fromMap(map),
};
