import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graphilia_board/src/models/models.dart';

abstract class SimpleDrawing<T, R extends DrawingRepresentation> extends RepresentableCanvasDrawing<T, R> with EquatableMixin {
  const SimpleDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;

  @override
  List<Object?> get props => [...super.props, color, width];

  Paint getPaint() => createSimplePaint(color);

  static Paint createSimplePaint(Color color) => Paint()
    ..style = PaintingStyle.fill
    ..color = color;

  @override
  SimpleDrawing<T, R> copyWith({
    T? id,
    int? zIndex,
    R? representation,
    Color? color,
    double? width,
  });
}
