import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

// ignore: must_be_immutable
class HighlighterLine<T> extends SimpleLine<T> {
  HighlighterLine({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
    required super.simulatePressure,
  });

  factory HighlighterLine.fromMap(Map<String, dynamic> map) {
    return HighlighterLine(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: LineRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
      simulatePressure: map['simulatePressure'],
    );
  }

  static const typeKey = 'highlighter_line';

  @override
  HighlighterLine<T> copyWith({
    T? id,
    int? zIndex,
    LineRepresentation? representation,
    Color? color,
    double? width,
    bool? simulatePressure,
  }) {
    return HighlighterLine(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      representation: representation ?? this.representation,
      color: color ?? this.color,
      width: width ?? this.width,
      simulatePressure: simulatePressure ?? this.simulatePressure,
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
      'simulatePressure': simulatePressure,
    };
  }
}
