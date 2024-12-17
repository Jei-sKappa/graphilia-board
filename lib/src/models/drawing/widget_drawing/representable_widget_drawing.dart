import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

abstract class RepresentableWidgetDrawing<T> extends WidgetDrawing<T> with RepresentableDrawingMixin {
  const RepresentableWidgetDrawing({
    required super.id,
    required super.zIndex,
    required this.representation,
  });

  @override
  final AnchoredDrawingRepresentation representation;

  @override
  Rect getBounds() => Rect.fromPoints(
        representation.anchorPoint,
        representation.endPoint,
      );
}
