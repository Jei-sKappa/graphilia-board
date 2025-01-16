import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

class HighlighterStraightLine<T> extends SimpleStraightLine<T> {
  const HighlighterStraightLine({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
  });

  factory HighlighterStraightLine.fromMap(Map<String, dynamic> map) {
    return HighlighterStraightLine(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
    );
  }

  static const typeKey = 'highlighter_straight_line';

  @override
  HighlighterStraightLine<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
  }) {
    return HighlighterStraightLine(
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
      'type': typeKey,
      'id': id,
      'zIndex': zIndex,
      'representation': representation.toMap(),
      'color': color.value,
      'width': width,
    };
  }
}
