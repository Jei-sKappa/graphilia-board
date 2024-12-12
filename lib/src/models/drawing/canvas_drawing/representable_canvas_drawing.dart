import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/models/models.dart';

abstract class RepresentableCanvasDrawing<T, R extends DrawingRepresentation> extends CanvasDrawing<T> with EquatableMixin, RepresentableDrawingMixin {
  const RepresentableCanvasDrawing({
    required super.id,
    required super.zIndex,
    required this.representation,
  });

  @override
  final R representation;

  @override
  List<Object?> get props => [...super.props, representation];

  @override
  Drawing updateRepresentation(DrawingRepresentation value);
}
