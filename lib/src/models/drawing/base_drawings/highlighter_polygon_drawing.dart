import 'dart:ui';

import 'package:graphilia_board/src/models/models.dart';

class HighlighterPolygonDrawing<T> extends SimplePolygonDrawing<T> {
  const HighlighterPolygonDrawing({
    required super.id,
    required super.zIndex,
    required super.representation,
    required super.color,
    required super.width,
    required super.polygonTemplate,
  });

  factory HighlighterPolygonDrawing.fromMap(Map<String, dynamic> map) {
    return HighlighterPolygonDrawing(
      id: map['id'],
      zIndex: map['zIndex'],
      representation: AnchoredDrawingRepresentation.fromMap(map['representation']),
      color: Color(map['color']),
      width: map['width'],
      polygonTemplate: PolygonTemplate.fromJson(map['polygonTemplate']),
    );
  }

  static const typeKey = 'highlighter_polygon';

  @override
  HighlighterPolygonDrawing<T> copyWith({
    T? id,
    int? zIndex,
    AnchoredDrawingRepresentation? representation,
    Color? color,
    double? width,
    PolygonTemplate? polygonTemplate,
  }) {
    return HighlighterPolygonDrawing(
      id: id ?? this.id,
      zIndex: zIndex ?? this.zIndex,
      representation: representation ?? this.representation,
      color: color ?? this.color,
      width: width ?? this.width,
      polygonTemplate: polygonTemplate ?? this.polygonTemplate,
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
      'polygonTemplate': polygonTemplate.toJson(),
    };
  }
}
