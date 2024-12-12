import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

class HighlighterCircleDrawing<T> extends SimpleCircleDrawing<T> {
  const HighlighterCircleDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
  });

  factory HighlighterCircleDrawing.fromMap(Map<String, dynamic> map) {
    return HighlighterCircleDrawing(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
    );
  }

  @override
  HighlighterCircleDrawing<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
  }) {
    return HighlighterCircleDrawing(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      representation: representation ?? this.representation,
      color: color ?? this.color,
      width: width ?? this.width,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'highlighter_circle',
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
    };
  }
}
