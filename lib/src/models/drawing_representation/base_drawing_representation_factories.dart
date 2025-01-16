import 'package:graphilia_board/src/models/drawing_representation/drawing_representation.dart';

Map<String, DrawingRepresentationFactory> baseDrawingRepresentationFactories = {
  PlaceholderRectRepresentation.mapKey: (map) => PlaceholderRectRepresentation.fromMap(map),
  AnchoredDrawingRepresentation.mapKey: (map) => AnchoredDrawingRepresentation.fromMap(map),
  LineRepresentation.mapKey: (map) => LineRepresentation.fromMap(map),
};
