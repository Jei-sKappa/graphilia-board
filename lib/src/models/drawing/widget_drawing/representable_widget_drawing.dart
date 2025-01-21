import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/models/models.dart';

abstract class RepresentableWidgetDrawing<T> extends WidgetDrawing<T> with EquatableMixin, RepresentableDrawingMixin {
  const RepresentableWidgetDrawing({
    required super.id,
    required super.zIndex,
    required this.representation,
  });

  @override
  final AnchoredDrawingRepresentation representation;

  @override
  List<Object?> get props => [...super.props, representation];

  @override
  Rect getBounds() => Rect.fromPoints(
        representation.anchorPoint,
        representation.endPoint,
      );
}
