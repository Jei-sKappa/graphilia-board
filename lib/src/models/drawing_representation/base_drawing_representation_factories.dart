import 'package:graphilia_board/src/models/drawing_representation/drawing_representation.dart';

Map<String, DrawingRepresentationFactory> baseDrawingRepresentationFactories = {
  PlaceholderRectRepresentation.typeKey: PlaceholderRectRepresentation.fromMap,
  AnchoredDrawingRepresentation.typeKey: AnchoredDrawingRepresentation.fromMap,
  LineRepresentation.typeKey: LineRepresentation.fromMap,
};
